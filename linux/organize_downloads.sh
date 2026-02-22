#!/bin/bash

# ============================================================================
# Script di Organizzazione Automatica della Cartella Download
# ============================================================================
# Autore: Claude
# Descrizione: Organizza automaticamente i file in Download secondo una
#              struttura ibrida temporale + categorica
# ============================================================================

# Configurazione
DOWNLOAD_DIR="$HOME/Download"
LOG_FILE="$HOME/.download_organizer.log"
DRY_RUN=false  # Cambia in true per testare senza spostare file

# Configurazione lingua
LANGUAGE="it"  # Impostata dall'installer
LANG_DIR="$HOME/.local/share/download_organizer/lang"

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================================================
# FUNZIONI DI UTILITÀ
# ============================================================================

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
    log_message "INFO: $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    log_message "WARN: $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    log_message "ERROR: $1"
}

# Carica il file di lingua
load_language() {
    local lang_file="$LANG_DIR/${LANGUAGE}.sh"
    if [ -f "$lang_file" ]; then
        source "$lang_file"
    else
        # Fallback: cerca nella directory dello script
        local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        local local_lang_file="$script_dir/lang/${LANGUAGE}.sh"
        if [ -f "$local_lang_file" ]; then
            source "$local_lang_file"
        else
            print_error "File lingua non trovato: $lang_file"
            print_error "Uso lingua predefinita (it)"
            # Fallback a italiano
            local fallback="$LANG_DIR/it.sh"
            if [ -f "$fallback" ]; then
                source "$fallback"
            else
                local local_fallback="$script_dir/lang/it.sh"
                if [ -f "$local_fallback" ]; then
                    source "$local_fallback"
                fi
            fi
        fi
    fi
}

# Crea una directory se non esiste
create_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        print_info "$MSG_CREATED_FOLDER: $1"
    fi
}

# Sposta un file con controllo
move_file() {
    local source="$1"
    local dest_dir="$2"
    local filename=$(basename "$source")
    local dest="$dest_dir/$filename"

    # Gestisci file con lo stesso nome
    if [ -f "$dest" ]; then
        local base="${filename%.*}"
        local ext="${filename##*.}"
        local counter=1

        # Se il file non ha estensione
        if [ "$base" = "$ext" ]; then
            while [ -f "$dest_dir/${filename}_$counter" ]; do
                ((counter++))
            done
            dest="$dest_dir/${filename}_$counter"
        else
            while [ -f "$dest_dir/${base}_$counter.$ext" ]; do
                ((counter++))
            done
            dest="$dest_dir/${base}_$counter.$ext"
        fi
    fi

    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] $MSG_DRY_MOVE: $filename -> $dest_dir"
    else
        mv "$source" "$dest"
        print_info "$MSG_MOVED: $filename -> $dest_dir"
    fi
}

# ============================================================================
# CREAZIONE STRUTTURA CARTELLE
# ============================================================================

create_folder_structure() {
    print_info "$MSG_CREATING_FOLDERS"

    # Cartelle 001__Recenti
    create_dir "$DOWNLOAD_DIR/001__${FOLDER_RECENT}/${FOLDER_TODAY}"
    create_dir "$DOWNLOAD_DIR/001__${FOLDER_RECENT}/${FOLDER_THIS_WEEK}"

    # 005__Sviluppo
    create_dir "$DOWNLOAD_DIR/005__${FOLDER_DEVELOPMENT}/${FOLDER_CODE}"
    create_dir "$DOWNLOAD_DIR/005__${FOLDER_DEVELOPMENT}/${FOLDER_NOTEBOOKS}"
    create_dir "$DOWNLOAD_DIR/005__${FOLDER_DEVELOPMENT}/${FOLDER_CONFIG}"
    create_dir "$DOWNLOAD_DIR/005__${FOLDER_DEVELOPMENT}/${FOLDER_REPOSITORY}"
    create_dir "$DOWNLOAD_DIR/005__${FOLDER_DEVELOPMENT}/${FOLDER_PACKAGE}"

    # 002__Dati
    create_dir "$DOWNLOAD_DIR/002__${FOLDER_DATA}/${FOLDER_CSV}"
    create_dir "$DOWNLOAD_DIR/002__${FOLDER_DATA}/${FOLDER_EXCEL}"
    create_dir "$DOWNLOAD_DIR/002__${FOLDER_DATA}/${FOLDER_JSON}"
    create_dir "$DOWNLOAD_DIR/002__${FOLDER_DATA}/${FOLDER_DATABASE}"
    create_dir "$DOWNLOAD_DIR/002__${FOLDER_DATA}/${FOLDER_PARQUET}"
    create_dir "$DOWNLOAD_DIR/002__${FOLDER_DATA}/${FOLDER_OTHER_FORMATS}"

    # 003__Documenti
    create_dir "$DOWNLOAD_DIR/003__${FOLDER_DOCUMENTS}/${FOLDER_PDF}"
    create_dir "$DOWNLOAD_DIR/003__${FOLDER_DOCUMENTS}/${FOLDER_WORD}"
    create_dir "$DOWNLOAD_DIR/003__${FOLDER_DOCUMENTS}/${FOLDER_PRESENTATIONS}"
    create_dir "$DOWNLOAD_DIR/003__${FOLDER_DOCUMENTS}/${FOLDER_TEXT}"
    create_dir "$DOWNLOAD_DIR/003__${FOLDER_DOCUMENTS}/${FOLDER_EBOOK}"

    # 004__Media
    create_dir "$DOWNLOAD_DIR/004__${FOLDER_MEDIA}/${FOLDER_IMAGES}"
    create_dir "$DOWNLOAD_DIR/004__${FOLDER_MEDIA}/${FOLDER_VIDEO}"
    create_dir "$DOWNLOAD_DIR/004__${FOLDER_MEDIA}/${FOLDER_AUDIO}"
    create_dir "$DOWNLOAD_DIR/004__${FOLDER_MEDIA}/${FOLDER_DIAGRAMS}"

    # 006__Software
    create_dir "$DOWNLOAD_DIR/006__${FOLDER_SOFTWARE}/${FOLDER_INSTALLERS}"
    create_dir "$DOWNLOAD_DIR/006__${FOLDER_SOFTWARE}/${FOLDER_ARCHIVES}"
    create_dir "$DOWNLOAD_DIR/006__${FOLDER_SOFTWARE}/${FOLDER_DOCKER}"
    create_dir "$DOWNLOAD_DIR/006__${FOLDER_SOFTWARE}/${FOLDER_SCRIPTS}"

    # 007__Lavoro
    create_dir "$DOWNLOAD_DIR/007__${FOLDER_WORK}/${FOLDER_INVOICES}"
    create_dir "$DOWNLOAD_DIR/007__${FOLDER_WORK}/${FOLDER_CONTRACTS}"
    create_dir "$DOWNLOAD_DIR/007__${FOLDER_WORK}/${FOLDER_QUOTES}"
    create_dir "$DOWNLOAD_DIR/007__${FOLDER_WORK}/${FOLDER_OTHER_DOCS}"

    # 008__Temporaneo
    create_dir "$DOWNLOAD_DIR/008__${FOLDER_TEMPORARY}"
}

# ============================================================================
# FUNZIONI DI CATEGORIZZAZIONE
# ============================================================================

get_file_age_days() {
    local file="$1"
    local file_time=$(stat -c %Y "$file")
    local current_time=$(date +%s)
    local age_seconds=$((current_time - file_time))
    local age_days=$((age_seconds / 86400))
    echo $age_days
}

is_work_document() {
    local filename="$1"
    local lowercase=$(echo "$filename" | tr '[:upper:]' '[:lower:]')

    if [[ "$lowercase" =~ ($WORK_KW_INVOICES|$WORK_KW_CONTRACTS|$WORK_KW_QUOTES) ]]; then
        return 0
    fi
    return 1
}

get_work_category() {
    local filename="$1"
    local lowercase=$(echo "$filename" | tr '[:upper:]' '[:lower:]')

    if [[ "$lowercase" =~ ($WORK_KW_INVOICES) ]]; then
        echo "$FOLDER_INVOICES"
    elif [[ "$lowercase" =~ ($WORK_KW_CONTRACTS) ]]; then
        echo "$FOLDER_CONTRACTS"
    elif [[ "$lowercase" =~ ($WORK_KW_QUOTES) ]]; then
        echo "$FOLDER_QUOTES"
    else
        echo "$FOLDER_OTHER_DOCS"
    fi
}

categorize_file() {
    local filepath="$1"
    local filename=$(basename "$filepath")
    local extension="${filename##*.}"
    local extension_lower=$(echo "$extension" | tr '[:upper:]' '[:lower:]')

    # Prima controlla se è un documento di lavoro (solo se nome esplicito)
    if is_work_document "$filename"; then
        local subcategory=$(get_work_category "$filename")
        echo "$DOWNLOAD_DIR/007__${FOLDER_WORK}/$subcategory"
        return
    fi

    # 005__Sviluppo - Codice
    case "$extension_lower" in
        py|js|ts|jsx|tsx|go|rs|java|cpp|c|h|hpp|cs|php|rb|swift|kt|scala|r)
            echo "$DOWNLOAD_DIR/005__${FOLDER_DEVELOPMENT}/${FOLDER_CODE}"
            return
            ;;
    esac

    # 005__Sviluppo - Notebooks
    case "$extension_lower" in
        ipynb)
            echo "$DOWNLOAD_DIR/005__${FOLDER_DEVELOPMENT}/${FOLDER_NOTEBOOKS}"
            return
            ;;
    esac

    # 005__Sviluppo - Config
    case "$extension_lower" in
        json|yaml|yml|toml|env|ini|conf|config|properties)
            echo "$DOWNLOAD_DIR/005__${FOLDER_DEVELOPMENT}/${FOLDER_CONFIG}"
            return
            ;;
    esac

    # 005__Sviluppo - Package
    case "$extension_lower" in
        whl|egg|deb|rpm|gem|jar)
            echo "$DOWNLOAD_DIR/005__${FOLDER_DEVELOPMENT}/${FOLDER_PACKAGE}"
            return
            ;;
    esac

    # 002__Dati - CSV
    case "$extension_lower" in
        csv|tsv)
            echo "$DOWNLOAD_DIR/002__${FOLDER_DATA}/${FOLDER_CSV}"
            return
            ;;
    esac

    # 002__Dati - Excel
    case "$extension_lower" in
        xlsx|xls|xlsm|ods)
            echo "$DOWNLOAD_DIR/002__${FOLDER_DATA}/${FOLDER_EXCEL}"
            return
            ;;
    esac

    # 002__Dati - JSON (solo se non già categorizzato come config)
    case "$extension_lower" in
        jsonl|ndjson)
            echo "$DOWNLOAD_DIR/002__${FOLDER_DATA}/${FOLDER_JSON}"
            return
            ;;
    esac

    # 002__Dati - Database
    case "$extension_lower" in
        sql|db|sqlite|sqlite3|mdb)
            echo "$DOWNLOAD_DIR/002__${FOLDER_DATA}/${FOLDER_DATABASE}"
            return
            ;;
    esac

    # 002__Dati - Parquet
    case "$extension_lower" in
        parquet|feather|arrow)
            echo "$DOWNLOAD_DIR/002__${FOLDER_DATA}/${FOLDER_PARQUET}"
            return
            ;;
    esac

    # 002__Dati - Altri formati
    case "$extension_lower" in
        xml|avro|orc|hdf5|h5|mat)
            echo "$DOWNLOAD_DIR/002__${FOLDER_DATA}/${FOLDER_OTHER_FORMATS}"
            return
            ;;
    esac

    # 003__Documenti - PDF
    case "$extension_lower" in
        pdf)
            echo "$DOWNLOAD_DIR/003__${FOLDER_DOCUMENTS}/${FOLDER_PDF}"
            return
            ;;
    esac

    # 003__Documenti - Word
    case "$extension_lower" in
        doc|docx|odt|rtf)
            echo "$DOWNLOAD_DIR/003__${FOLDER_DOCUMENTS}/${FOLDER_WORD}"
            return
            ;;
    esac

    # 003__Documenti - Presentazioni
    case "$extension_lower" in
        ppt|pptx|odp|key)
            echo "$DOWNLOAD_DIR/003__${FOLDER_DOCUMENTS}/${FOLDER_PRESENTATIONS}"
            return
            ;;
    esac

    # 003__Documenti - Testo
    case "$extension_lower" in
        txt|md|rst|tex|log)
            echo "$DOWNLOAD_DIR/003__${FOLDER_DOCUMENTS}/${FOLDER_TEXT}"
            return
            ;;
    esac

    # 003__Documenti - Ebook
    case "$extension_lower" in
        epub|mobi|azw|azw3)
            echo "$DOWNLOAD_DIR/003__${FOLDER_DOCUMENTS}/${FOLDER_EBOOK}"
            return
            ;;
    esac

    # 004__Media - Immagini
    case "$extension_lower" in
        jpg|jpeg|png|gif|bmp|svg|webp|ico|tiff|tif|heic|raw|cr2|nef)
            echo "$DOWNLOAD_DIR/004__${FOLDER_MEDIA}/${FOLDER_IMAGES}"
            return
            ;;
    esac

    # 004__Media - Video
    case "$extension_lower" in
        mp4|avi|mkv|mov|wmv|flv|webm|m4v|mpg|mpeg|3gp|ogv)
            echo "$DOWNLOAD_DIR/004__${FOLDER_MEDIA}/${FOLDER_VIDEO}"
            return
            ;;
    esac

    # 004__Media - Audio
    case "$extension_lower" in
        mp3|wav|flac|aac|ogg|wma|m4a|opus|ape|alac)
            echo "$DOWNLOAD_DIR/004__${FOLDER_MEDIA}/${FOLDER_AUDIO}"
            return
            ;;
    esac

    # 004__Media - Diagrammi
    case "$extension_lower" in
        drawio|mermaid|puml|plantuml|vsd|vsdx)
            echo "$DOWNLOAD_DIR/004__${FOLDER_MEDIA}/${FOLDER_DIAGRAMS}"
            return
            ;;
    esac

    # 006__Software - Installatori
    case "$extension_lower" in
        exe|msi|dmg|pkg|appimage|snap|flatpak)
            echo "$DOWNLOAD_DIR/006__${FOLDER_SOFTWARE}/${FOLDER_INSTALLERS}"
            return
            ;;
    esac

    # 006__Software - Scripts
    case "$extension_lower" in
        sh|bash|zsh|bat|ps1|cmd)
            echo "$DOWNLOAD_DIR/006__${FOLDER_SOFTWARE}/${FOLDER_SCRIPTS}"
            return
            ;;
    esac

    # 006__Software - Docker (per nome file specifico)
    if [[ "$filename" =~ ^(Dockerfile|docker-compose\.yml|docker-compose\.yaml)$ ]]; then
        echo "$DOWNLOAD_DIR/006__${FOLDER_SOFTWARE}/${FOLDER_DOCKER}"
        return
    fi

    # 006__Software - Archivi (solo se non sono package di sviluppo)
    case "$extension_lower" in
        zip|rar|7z|tar|gz|bz2|xz|tgz)
            # Se sembra un repository (contiene versioni o "src")
            if [[ "$filename" =~ (v[0-9]|src|source|master|main|repo) ]]; then
                echo "$DOWNLOAD_DIR/005__${FOLDER_DEVELOPMENT}/${FOLDER_REPOSITORY}"
            else
                echo "$DOWNLOAD_DIR/006__${FOLDER_SOFTWARE}/${FOLDER_ARCHIVES}"
            fi
            return
            ;;
    esac

    # Default: 008__Temporaneo
    echo "$DOWNLOAD_DIR/008__${FOLDER_TEMPORARY}"
}

# ============================================================================
# PROCESSO DI ORGANIZZAZIONE
# ============================================================================

process_new_files() {
    print_info "=== $MSG_PHASE1 001__${FOLDER_RECENT}/${FOLDER_TODAY} ==="

    # Trova tutti i file direttamente in Download (non nelle sottocartelle)
    find "$DOWNLOAD_DIR" -maxdepth 1 -type f | while read -r file; do
        local filename=$(basename "$file")

        # Ignora file nascosti e di sistema
        if [[ "$filename" == .* ]] || [[ "$filename" == *".part" ]] || [[ "$filename" == *".crdownload" ]]; then
            continue
        fi

        move_file "$file" "$DOWNLOAD_DIR/001__${FOLDER_RECENT}/${FOLDER_TODAY}"
    done
}

process_today_to_week() {
    local phase2_msg="${MSG_PHASE2//%TODAY%/$FOLDER_TODAY}"
    phase2_msg="${phase2_msg//%THIS_WEEK%/$FOLDER_THIS_WEEK}"
    print_info "=== $phase2_msg ==="

    # Sposta file più vecchi di 1 giorno da Oggi a Questa-Settimana
    if [ -d "$DOWNLOAD_DIR/001__${FOLDER_RECENT}/${FOLDER_TODAY}" ]; then
        find "$DOWNLOAD_DIR/001__${FOLDER_RECENT}/${FOLDER_TODAY}" -type f | while read -r file; do
            local age=$(get_file_age_days "$file")

            if [ $age -ge 1 ]; then
                move_file "$file" "$DOWNLOAD_DIR/001__${FOLDER_RECENT}/${FOLDER_THIS_WEEK}"
            fi
        done
    fi
}

process_week_to_categories() {
    local phase3_msg="${MSG_PHASE3//%THIS_WEEK%/$FOLDER_THIS_WEEK}"
    print_info "=== $phase3_msg ==="

    # Sposta file più vecchi di 7 giorni alle categorie finali
    if [ -d "$DOWNLOAD_DIR/001__${FOLDER_RECENT}/${FOLDER_THIS_WEEK}" ]; then
        find "$DOWNLOAD_DIR/001__${FOLDER_RECENT}/${FOLDER_THIS_WEEK}" -type f | while read -r file; do
            local age=$(get_file_age_days "$file")

            if [ $age -ge 7 ]; then
                local dest_dir=$(categorize_file "$file")
                move_file "$file" "$dest_dir"
            fi
        done
    fi
}

clean_temporary() {
    print_info "=== $MSG_PHASE4 008__${FOLDER_TEMPORARY} ==="

    # Elimina file più vecchi di 30 giorni da 008__Temporaneo
    if [ -d "$DOWNLOAD_DIR/008__${FOLDER_TEMPORARY}" ]; then
        find "$DOWNLOAD_DIR/008__${FOLDER_TEMPORARY}" -type f | while read -r file; do
            local age=$(get_file_age_days "$file")
            local filename=$(basename "$file")

            if [ $age -ge 30 ]; then
                if [ "$DRY_RUN" = true ]; then
                    print_warning "[DRY RUN] $MSG_DRY_DELETE: $filename ($MSG_AGE: $age $MSG_DAYS)"
                else
                    rm "$file"
                    print_warning "$MSG_DELETED: $filename ($MSG_AGE: $age $MSG_DAYS)"
                fi
            fi
        done
    fi
}

# ============================================================================
# FUNZIONE PRINCIPALE
# ============================================================================

main() {
    # Carica la lingua
    load_language

    print_info "============================================"
    print_info "$MSG_START"
    print_info "Directory: $DOWNLOAD_DIR"
    print_info "============================================"

    # Verifica che la directory Download esista
    if [ ! -d "$DOWNLOAD_DIR" ]; then
        print_error "$MSG_DIR_NOT_FOUND $DOWNLOAD_DIR"
        exit 1
    fi

    # Crea la struttura delle cartelle
    create_folder_structure

    # Esegui le fasi di organizzazione
    process_new_files
    process_today_to_week
    process_week_to_categories
    clean_temporary

    print_info "============================================"
    print_info "$MSG_DONE"
    print_info "============================================"
}

# Esegui lo script
main
