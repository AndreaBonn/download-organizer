#!/bin/bash

# ============================================================================
# Script di Organizzazione Automatica della Cartella Download - macOS
# ============================================================================
# Autore: Claude
# Descrizione: Organizza automaticamente i file in Download secondo una
#              struttura ibrida temporale + categorica
# Piattaforma: macOS (compatibile con bash 3.2+)
# ============================================================================

# Configurazione
DOWNLOAD_DIR="$HOME/Downloads"
LOG_FILE="$HOME/.download_organizer.log"
DRY_RUN=false  # Cambia in true per testare senza spostare file

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================================================
# FUNZIONI DI UTILITA
# ============================================================================

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

print_info() {
    printf "${GREEN}[INFO]${NC} %s\n" "$1"
    log_message "INFO: $1"
}

print_warning() {
    printf "${YELLOW}[WARN]${NC} %s\n" "$1"
    log_message "WARN: $1"
}

print_error() {
    printf "${RED}[ERROR]${NC} %s\n" "$1"
    log_message "ERROR: $1"
}

# Crea una directory se non esiste
create_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        print_info "Creata cartella: $1"
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
        print_info "[DRY RUN] Sposterei: $filename -> $dest_dir"
    else
        mv "$source" "$dest"
        print_info "Spostato: $filename -> $dest_dir"
    fi
}

# ============================================================================
# CREAZIONE STRUTTURA CARTELLE
# ============================================================================

create_folder_structure() {
    print_info "Creazione struttura cartelle..."

    # 001__Recenti
    create_dir "$DOWNLOAD_DIR/001__Recenti/Oggi"
    create_dir "$DOWNLOAD_DIR/001__Recenti/Questa-Settimana"

    # 002__Dati
    create_dir "$DOWNLOAD_DIR/002__Dati/CSV"
    create_dir "$DOWNLOAD_DIR/002__Dati/Excel"
    create_dir "$DOWNLOAD_DIR/002__Dati/JSON"
    create_dir "$DOWNLOAD_DIR/002__Dati/Database"
    create_dir "$DOWNLOAD_DIR/002__Dati/Parquet"
    create_dir "$DOWNLOAD_DIR/002__Dati/Altri-Formati"

    # 003__Documenti
    create_dir "$DOWNLOAD_DIR/003__Documenti/PDF"
    create_dir "$DOWNLOAD_DIR/003__Documenti/Word"
    create_dir "$DOWNLOAD_DIR/003__Documenti/Presentazioni"
    create_dir "$DOWNLOAD_DIR/003__Documenti/Testo"
    create_dir "$DOWNLOAD_DIR/003__Documenti/Ebook"

    # 004__Media
    create_dir "$DOWNLOAD_DIR/004__Media/Immagini"
    create_dir "$DOWNLOAD_DIR/004__Media/Video"
    create_dir "$DOWNLOAD_DIR/004__Media/Audio"
    create_dir "$DOWNLOAD_DIR/004__Media/Diagrammi"

    # 005__Sviluppo
    create_dir "$DOWNLOAD_DIR/005__Sviluppo/Codice"
    create_dir "$DOWNLOAD_DIR/005__Sviluppo/Notebooks"
    create_dir "$DOWNLOAD_DIR/005__Sviluppo/Config"
    create_dir "$DOWNLOAD_DIR/005__Sviluppo/Repository"
    create_dir "$DOWNLOAD_DIR/005__Sviluppo/Package"

    # 006__Software
    create_dir "$DOWNLOAD_DIR/006__Software/Installatori"
    create_dir "$DOWNLOAD_DIR/006__Software/Archivi"
    create_dir "$DOWNLOAD_DIR/006__Software/Docker"
    create_dir "$DOWNLOAD_DIR/006__Software/Scripts"

    # 007__Lavoro
    create_dir "$DOWNLOAD_DIR/007__Lavoro/Fatture"
    create_dir "$DOWNLOAD_DIR/007__Lavoro/Contratti"
    create_dir "$DOWNLOAD_DIR/007__Lavoro/Preventivi"
    create_dir "$DOWNLOAD_DIR/007__Lavoro/Altri-Documenti"

    # 008__Temporaneo
    create_dir "$DOWNLOAD_DIR/008__Temporaneo"
}

# ============================================================================
# FUNZIONI DI CATEGORIZZAZIONE
# ============================================================================

get_file_age_days() {
    local file="$1"
    # macOS usa stat -f %m (sintassi BSD) invece di stat -c %Y (GNU)
    local file_time=$(stat -f %m "$file")
    local current_time=$(date +%s)
    local age_seconds=$((current_time - file_time))
    local age_days=$((age_seconds / 86400))
    echo $age_days
}

is_work_document() {
    local filename="$1"
    local lowercase=$(echo "$filename" | tr '[:upper:]' '[:lower:]')

    if [[ "$lowercase" =~ (fattura|invoice|contratto|contract|agreement|preventivo|quote|estimate) ]]; then
        return 0
    fi
    return 1
}

get_work_category() {
    local filename="$1"
    local lowercase=$(echo "$filename" | tr '[:upper:]' '[:lower:]')

    if [[ "$lowercase" =~ (fattura|invoice) ]]; then
        echo "Fatture"
    elif [[ "$lowercase" =~ (contratto|contract|agreement) ]]; then
        echo "Contratti"
    elif [[ "$lowercase" =~ (preventivo|quote|estimate) ]]; then
        echo "Preventivi"
    else
        echo "Altri-Documenti"
    fi
}

categorize_file() {
    local filepath="$1"
    local filename=$(basename "$filepath")
    local extension="${filename##*.}"
    local extension_lower=$(echo "$extension" | tr '[:upper:]' '[:lower:]')

    # Prima controlla se e un documento di lavoro (solo se nome esplicito)
    if is_work_document "$filename"; then
        local subcategory=$(get_work_category "$filename")
        echo "$DOWNLOAD_DIR/007__Lavoro/$subcategory"
        return
    fi

    # 005__Sviluppo - Codice
    case "$extension_lower" in
        py|js|ts|jsx|tsx|go|rs|java|cpp|c|h|hpp|cs|php|rb|swift|kt|scala|r)
            echo "$DOWNLOAD_DIR/005__Sviluppo/Codice"
            return
            ;;
    esac

    # 005__Sviluppo - Notebooks
    case "$extension_lower" in
        ipynb)
            echo "$DOWNLOAD_DIR/005__Sviluppo/Notebooks"
            return
            ;;
    esac

    # 005__Sviluppo - Config
    case "$extension_lower" in
        json|yaml|yml|toml|env|ini|conf|config|properties)
            echo "$DOWNLOAD_DIR/005__Sviluppo/Config"
            return
            ;;
    esac

    # 005__Sviluppo - Package
    case "$extension_lower" in
        whl|egg|gem|jar)
            echo "$DOWNLOAD_DIR/005__Sviluppo/Package"
            return
            ;;
    esac

    # 002__Dati - CSV
    case "$extension_lower" in
        csv|tsv)
            echo "$DOWNLOAD_DIR/002__Dati/CSV"
            return
            ;;
    esac

    # 002__Dati - Excel
    case "$extension_lower" in
        xlsx|xls|xlsm|ods)
            echo "$DOWNLOAD_DIR/002__Dati/Excel"
            return
            ;;
    esac

    # 002__Dati - JSON (solo se non gia categorizzato come config)
    case "$extension_lower" in
        jsonl|ndjson)
            echo "$DOWNLOAD_DIR/002__Dati/JSON"
            return
            ;;
    esac

    # 002__Dati - Database
    case "$extension_lower" in
        sql|db|sqlite|sqlite3|mdb)
            echo "$DOWNLOAD_DIR/002__Dati/Database"
            return
            ;;
    esac

    # 002__Dati - Parquet
    case "$extension_lower" in
        parquet|feather|arrow)
            echo "$DOWNLOAD_DIR/002__Dati/Parquet"
            return
            ;;
    esac

    # 002__Dati - Altri formati
    case "$extension_lower" in
        xml|avro|orc|hdf5|h5|mat)
            echo "$DOWNLOAD_DIR/002__Dati/Altri-Formati"
            return
            ;;
    esac

    # 003__Documenti - PDF
    case "$extension_lower" in
        pdf)
            echo "$DOWNLOAD_DIR/003__Documenti/PDF"
            return
            ;;
    esac

    # 003__Documenti - Word
    case "$extension_lower" in
        doc|docx|odt|rtf)
            echo "$DOWNLOAD_DIR/003__Documenti/Word"
            return
            ;;
    esac

    # 003__Documenti - Presentazioni
    case "$extension_lower" in
        ppt|pptx|odp|key)
            echo "$DOWNLOAD_DIR/003__Documenti/Presentazioni"
            return
            ;;
    esac

    # 003__Documenti - Testo
    case "$extension_lower" in
        txt|md|rst|tex|log)
            echo "$DOWNLOAD_DIR/003__Documenti/Testo"
            return
            ;;
    esac

    # 003__Documenti - Ebook
    case "$extension_lower" in
        epub|mobi|azw|azw3)
            echo "$DOWNLOAD_DIR/003__Documenti/Ebook"
            return
            ;;
    esac

    # 004__Media - Immagini
    case "$extension_lower" in
        jpg|jpeg|png|gif|bmp|svg|webp|ico|tiff|tif|heic|raw|cr2|nef)
            echo "$DOWNLOAD_DIR/004__Media/Immagini"
            return
            ;;
    esac

    # 004__Media - Video
    case "$extension_lower" in
        mp4|avi|mkv|mov|wmv|flv|webm|m4v|mpg|mpeg|3gp|ogv)
            echo "$DOWNLOAD_DIR/004__Media/Video"
            return
            ;;
    esac

    # 004__Media - Audio
    case "$extension_lower" in
        mp3|wav|flac|aac|ogg|wma|m4a|opus|ape|alac)
            echo "$DOWNLOAD_DIR/004__Media/Audio"
            return
            ;;
    esac

    # 004__Media - Diagrammi
    case "$extension_lower" in
        drawio|mermaid|puml|plantuml|vsd|vsdx)
            echo "$DOWNLOAD_DIR/004__Media/Diagrammi"
            return
            ;;
    esac

    # 006__Software - Installatori (formati macOS)
    case "$extension_lower" in
        dmg|pkg|app)
            echo "$DOWNLOAD_DIR/006__Software/Installatori"
            return
            ;;
    esac

    # 006__Software - Scripts
    case "$extension_lower" in
        sh|bash|zsh|command)
            echo "$DOWNLOAD_DIR/006__Software/Scripts"
            return
            ;;
    esac

    # 006__Software - Docker (per nome file specifico)
    if [[ "$filename" =~ ^(Dockerfile|docker-compose\.yml|docker-compose\.yaml)$ ]]; then
        echo "$DOWNLOAD_DIR/006__Software/Docker"
        return
    fi

    # 006__Software - Archivi (solo se non sono package di sviluppo)
    case "$extension_lower" in
        zip|rar|7z|tar|gz|bz2|xz|tgz)
            # Se sembra un repository (contiene versioni o "src")
            if [[ "$filename" =~ (v[0-9]|src|source|master|main|repo) ]]; then
                echo "$DOWNLOAD_DIR/005__Sviluppo/Repository"
            else
                echo "$DOWNLOAD_DIR/006__Software/Archivi"
            fi
            return
            ;;
    esac

    # Default: 008__Temporaneo
    echo "$DOWNLOAD_DIR/008__Temporaneo"
}

# ============================================================================
# PROCESSO DI ORGANIZZAZIONE
# ============================================================================

process_new_files() {
    print_info "=== Fase 1: Spostamento nuovi file in 001__Recenti/Oggi ==="

    # Trova tutti i file direttamente in Download (non nelle sottocartelle)
    find "$DOWNLOAD_DIR" -maxdepth 1 -type f | while read -r file; do
        local filename=$(basename "$file")

        # Ignora file nascosti, di sistema e download in corso
        if [[ "$filename" == .* ]] || [[ "$filename" == *".part" ]] || [[ "$filename" == *".crdownload" ]] || [[ "$filename" == *".download" ]]; then
            continue
        fi

        move_file "$file" "$DOWNLOAD_DIR/001__Recenti/Oggi"
    done
}

process_today_to_week() {
    print_info "=== Fase 2: Spostamento da Oggi a Questa-Settimana ==="

    # Sposta file piu vecchi di 1 giorno da Oggi a Questa-Settimana
    if [ -d "$DOWNLOAD_DIR/001__Recenti/Oggi" ]; then
        find "$DOWNLOAD_DIR/001__Recenti/Oggi" -type f | while read -r file; do
            local age=$(get_file_age_days "$file")

            if [ $age -ge 1 ]; then
                move_file "$file" "$DOWNLOAD_DIR/001__Recenti/Questa-Settimana"
            fi
        done
    fi
}

process_week_to_categories() {
    print_info "=== Fase 3: Categorizzazione file da Questa-Settimana ==="

    # Sposta file piu vecchi di 7 giorni alle categorie finali
    if [ -d "$DOWNLOAD_DIR/001__Recenti/Questa-Settimana" ]; then
        find "$DOWNLOAD_DIR/001__Recenti/Questa-Settimana" -type f | while read -r file; do
            local age=$(get_file_age_days "$file")

            if [ $age -ge 7 ]; then
                local dest_dir=$(categorize_file "$file")
                move_file "$file" "$dest_dir"
            fi
        done
    fi
}

clean_temporary() {
    print_info "=== Fase 4: Pulizia cartella 008__Temporaneo ==="

    # Elimina file piu vecchi di 30 giorni da 008__Temporaneo
    if [ -d "$DOWNLOAD_DIR/008__Temporaneo" ]; then
        find "$DOWNLOAD_DIR/008__Temporaneo" -type f | while read -r file; do
            local age=$(get_file_age_days "$file")
            local filename=$(basename "$file")

            if [ $age -ge 30 ]; then
                if [ "$DRY_RUN" = true ]; then
                    print_warning "[DRY RUN] Eliminerei: $filename (eta: $age giorni)"
                else
                    rm "$file"
                    print_warning "Eliminato file vecchio: $filename (eta: $age giorni)"
                fi
            fi
        done
    fi
}

# ============================================================================
# FUNZIONE PRINCIPALE
# ============================================================================

main() {
    print_info "============================================"
    print_info "Avvio organizzazione cartella Download"
    print_info "Directory: $DOWNLOAD_DIR"
    print_info "============================================"

    # Verifica che la directory Download esista
    if [ ! -d "$DOWNLOAD_DIR" ]; then
        print_error "La directory $DOWNLOAD_DIR non esiste!"
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
    print_info "Organizzazione completata!"
    print_info "============================================"
}

# Esegui lo script
main
