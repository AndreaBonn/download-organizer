#!/bin/bash

# ============================================================================
# Script di Installazione - Download Organizer per macOS
# ============================================================================
# Questo script installa e configura l'organizzatore automatico di Download
# ============================================================================

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Installazione Download Organizer per macOS                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# ============================================================================
# SELEZIONE LINGUA / LANGUAGE SELECTION
# ============================================================================

echo "Scegli la lingua / Choose your language:"
echo ""
echo "  1) Italiano"
echo "  2) English"
echo "  3) Español"
echo "  4) Français"
echo "  5) Deutsch"
echo "  6) Português"
echo ""
read -p "Lingua/Language [1]: " lang_choice

case "$lang_choice" in
    2) LANGUAGE="en" ;;
    3) LANGUAGE="es" ;;
    4) LANGUAGE="fr" ;;
    5) LANGUAGE="de" ;;
    6) LANGUAGE="pt" ;;
    *) LANGUAGE="it" ;;
esac

echo ""

# Definisci i percorsi
SCRIPT_NAME="organize_downloads.sh"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_PATH="$INSTALL_DIR/$SCRIPT_NAME"
LANG_INSTALL_DIR="$HOME/.local/share/download_organizer/lang"

# Crea le directory se non esistono
if [ ! -d "$INSTALL_DIR" ]; then
    echo "📁 Creazione directory $INSTALL_DIR..."
    mkdir -p "$INSTALL_DIR"
fi

mkdir -p "$LANG_INSTALL_DIR"

# Copia lo script nella directory
echo "📋 Copia dello script in $INSTALL_DIR..."
cp "$SCRIPT_NAME" "$SCRIPT_PATH"

# Imposta la lingua nello script installato (macOS sed richiede -i '')
sed -i '' "s/^LANGUAGE=.*/LANGUAGE=\"$LANGUAGE\"/" "$SCRIPT_PATH"

# Copia i file di lingua
echo "🌍 Copia file di lingua in $LANG_INSTALL_DIR..."
cp lang/*.sh "$LANG_INSTALL_DIR/"

# Rendi lo script eseguibile
echo "🔧 Impostazione permessi di esecuzione..."
chmod +x "$SCRIPT_PATH"

# Aggiungi al PATH se necessario (macOS usa zsh come shell predefinita)
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "⚠️  $INSTALL_DIR non e nel PATH"

    # Rileva la shell in uso
    SHELL_RC="$HOME/.zshrc"
    if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bash_profile" ]; then
        SHELL_RC="$HOME/.bash_profile"
    fi

    # Aggiungi al PATH
    if ! grep -q "$INSTALL_DIR" "$SHELL_RC" 2>/dev/null; then
        echo "   Aggiungo $INSTALL_DIR al PATH in $SHELL_RC..."
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$SHELL_RC"
        echo "   ✅ PATH aggiornato. Riapri il Terminale per applicare."
    fi
fi

echo ""
echo "✅ Script installato con successo in: $SCRIPT_PATH"
echo "🌍 Lingua selezionata: $LANGUAGE"
echo ""

# ============================================================================
# MIGRAZIONE CARTELLE ESISTENTI
# ============================================================================

# Carica la nuova lingua per ottenere i nomi delle cartelle
source "lang/$LANGUAGE.sh"

DOWNLOAD_DIR_CHECK="$HOME/Downloads"

if [ -d "$DOWNLOAD_DIR_CHECK" ]; then
    # Cerca cartelle con prefisso numerico che potrebbero essere di una lingua diversa
    HAS_OLD_FOLDERS=false

    for old_lang in it en es fr de pt; do
        if [ "$old_lang" = "$LANGUAGE" ]; then
            continue
        fi

        if [ -f "lang/$old_lang.sh" ]; then
            OLD_RECENT=""
            eval "$(grep '^FOLDER_RECENT=' "lang/$old_lang.sh")"
            OLD_RECENT="$FOLDER_RECENT"

            if [ -d "$DOWNLOAD_DIR_CHECK/001__$OLD_RECENT" ]; then
                HAS_OLD_FOLDERS=true
                OLD_LANGUAGE="$old_lang"
                break
            fi
        fi
    done

    if [ "$HAS_OLD_FOLDERS" = true ]; then
        echo ""
        echo "╔════════════════════════════════════════════════════════════╗"
        echo "║  Cartelle esistenti rilevate (lingua: $OLD_LANGUAGE)               ║"
        echo "╚════════════════════════════════════════════════════════════╝"
        echo ""
        read -p "❓ Vuoi rinominare le cartelle nella nuova lingua ($LANGUAGE)? (s/n): " -n 1 -r
        echo ""

        if [[ $REPLY =~ ^[Ss]$ ]] || [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "📂 Migrazione cartelle in corso..."

            # Carica nomi vecchi
            source "lang/$OLD_LANGUAGE.sh"
            OLD_FOLDER_RECENT="$FOLDER_RECENT"
            OLD_FOLDER_TODAY="$FOLDER_TODAY"
            OLD_FOLDER_THIS_WEEK="$FOLDER_THIS_WEEK"
            OLD_FOLDER_DATA="$FOLDER_DATA"
            OLD_FOLDER_CSV="$FOLDER_CSV"
            OLD_FOLDER_EXCEL="$FOLDER_EXCEL"
            OLD_FOLDER_JSON="$FOLDER_JSON"
            OLD_FOLDER_DATABASE="$FOLDER_DATABASE"
            OLD_FOLDER_PARQUET="$FOLDER_PARQUET"
            OLD_FOLDER_OTHER_FORMATS="$FOLDER_OTHER_FORMATS"
            OLD_FOLDER_DOCUMENTS="$FOLDER_DOCUMENTS"
            OLD_FOLDER_PDF="$FOLDER_PDF"
            OLD_FOLDER_WORD="$FOLDER_WORD"
            OLD_FOLDER_PRESENTATIONS="$FOLDER_PRESENTATIONS"
            OLD_FOLDER_TEXT="$FOLDER_TEXT"
            OLD_FOLDER_EBOOK="$FOLDER_EBOOK"
            OLD_FOLDER_MEDIA="$FOLDER_MEDIA"
            OLD_FOLDER_IMAGES="$FOLDER_IMAGES"
            OLD_FOLDER_VIDEO="$FOLDER_VIDEO"
            OLD_FOLDER_AUDIO="$FOLDER_AUDIO"
            OLD_FOLDER_DIAGRAMS="$FOLDER_DIAGRAMS"
            OLD_FOLDER_DEVELOPMENT="$FOLDER_DEVELOPMENT"
            OLD_FOLDER_CODE="$FOLDER_CODE"
            OLD_FOLDER_NOTEBOOKS="$FOLDER_NOTEBOOKS"
            OLD_FOLDER_CONFIG="$FOLDER_CONFIG"
            OLD_FOLDER_REPOSITORY="$FOLDER_REPOSITORY"
            OLD_FOLDER_PACKAGE="$FOLDER_PACKAGE"
            OLD_FOLDER_SOFTWARE="$FOLDER_SOFTWARE"
            OLD_FOLDER_INSTALLERS="$FOLDER_INSTALLERS"
            OLD_FOLDER_ARCHIVES="$FOLDER_ARCHIVES"
            OLD_FOLDER_DOCKER="$FOLDER_DOCKER"
            OLD_FOLDER_SCRIPTS="$FOLDER_SCRIPTS"
            OLD_FOLDER_WORK="$FOLDER_WORK"
            OLD_FOLDER_INVOICES="$FOLDER_INVOICES"
            OLD_FOLDER_CONTRACTS="$FOLDER_CONTRACTS"
            OLD_FOLDER_QUOTES="$FOLDER_QUOTES"
            OLD_FOLDER_OTHER_DOCS="$FOLDER_OTHER_DOCS"
            OLD_FOLDER_TEMPORARY="$FOLDER_TEMPORARY"

            # Ricarica nomi nuovi
            source "lang/$LANGUAGE.sh"

            # Funzione per rinominare in sicurezza
            rename_if_exists() {
                local old_path="$1"
                local new_path="$2"
                if [ -d "$old_path" ] && [ "$old_path" != "$new_path" ]; then
                    if [ -d "$new_path" ]; then
                        echo "   ⚠️  $new_path esiste già, sposto i file..."
                        find "$old_path" -maxdepth 1 -type f -exec mv {} "$new_path/" \;
                        rmdir "$old_path" 2>/dev/null
                    else
                        mv "$old_path" "$new_path"
                        echo "   ✅ $(basename "$old_path") → $(basename "$new_path")"
                    fi
                fi
            }

            D="$DOWNLOAD_DIR_CHECK"

            # Rinomina sottocartelle prima delle cartelle principali
            # 001__Recenti
            rename_if_exists "$D/001__$OLD_FOLDER_RECENT/$OLD_FOLDER_TODAY" "$D/001__$OLD_FOLDER_RECENT/$FOLDER_TODAY"
            rename_if_exists "$D/001__$OLD_FOLDER_RECENT/$OLD_FOLDER_THIS_WEEK" "$D/001__$OLD_FOLDER_RECENT/$FOLDER_THIS_WEEK"
            rename_if_exists "$D/001__$OLD_FOLDER_RECENT" "$D/001__$FOLDER_RECENT"

            # 002__Dati
            rename_if_exists "$D/002__$OLD_FOLDER_DATA/$OLD_FOLDER_CSV" "$D/002__$OLD_FOLDER_DATA/$FOLDER_CSV"
            rename_if_exists "$D/002__$OLD_FOLDER_DATA/$OLD_FOLDER_EXCEL" "$D/002__$OLD_FOLDER_DATA/$FOLDER_EXCEL"
            rename_if_exists "$D/002__$OLD_FOLDER_DATA/$OLD_FOLDER_JSON" "$D/002__$OLD_FOLDER_DATA/$FOLDER_JSON"
            rename_if_exists "$D/002__$OLD_FOLDER_DATA/$OLD_FOLDER_DATABASE" "$D/002__$OLD_FOLDER_DATA/$FOLDER_DATABASE"
            rename_if_exists "$D/002__$OLD_FOLDER_DATA/$OLD_FOLDER_PARQUET" "$D/002__$OLD_FOLDER_DATA/$FOLDER_PARQUET"
            rename_if_exists "$D/002__$OLD_FOLDER_DATA/$OLD_FOLDER_OTHER_FORMATS" "$D/002__$OLD_FOLDER_DATA/$FOLDER_OTHER_FORMATS"
            rename_if_exists "$D/002__$OLD_FOLDER_DATA" "$D/002__$FOLDER_DATA"

            # 003__Documenti
            rename_if_exists "$D/003__$OLD_FOLDER_DOCUMENTS/$OLD_FOLDER_PDF" "$D/003__$OLD_FOLDER_DOCUMENTS/$FOLDER_PDF"
            rename_if_exists "$D/003__$OLD_FOLDER_DOCUMENTS/$OLD_FOLDER_WORD" "$D/003__$OLD_FOLDER_DOCUMENTS/$FOLDER_WORD"
            rename_if_exists "$D/003__$OLD_FOLDER_DOCUMENTS/$OLD_FOLDER_PRESENTATIONS" "$D/003__$OLD_FOLDER_DOCUMENTS/$FOLDER_PRESENTATIONS"
            rename_if_exists "$D/003__$OLD_FOLDER_DOCUMENTS/$OLD_FOLDER_TEXT" "$D/003__$OLD_FOLDER_DOCUMENTS/$FOLDER_TEXT"
            rename_if_exists "$D/003__$OLD_FOLDER_DOCUMENTS/$OLD_FOLDER_EBOOK" "$D/003__$OLD_FOLDER_DOCUMENTS/$FOLDER_EBOOK"
            rename_if_exists "$D/003__$OLD_FOLDER_DOCUMENTS" "$D/003__$FOLDER_DOCUMENTS"

            # 004__Media
            rename_if_exists "$D/004__$OLD_FOLDER_MEDIA/$OLD_FOLDER_IMAGES" "$D/004__$OLD_FOLDER_MEDIA/$FOLDER_IMAGES"
            rename_if_exists "$D/004__$OLD_FOLDER_MEDIA/$OLD_FOLDER_VIDEO" "$D/004__$OLD_FOLDER_MEDIA/$FOLDER_VIDEO"
            rename_if_exists "$D/004__$OLD_FOLDER_MEDIA/$OLD_FOLDER_AUDIO" "$D/004__$OLD_FOLDER_MEDIA/$FOLDER_AUDIO"
            rename_if_exists "$D/004__$OLD_FOLDER_MEDIA/$OLD_FOLDER_DIAGRAMS" "$D/004__$OLD_FOLDER_MEDIA/$FOLDER_DIAGRAMS"
            rename_if_exists "$D/004__$OLD_FOLDER_MEDIA" "$D/004__$FOLDER_MEDIA"

            # 005__Sviluppo
            rename_if_exists "$D/005__$OLD_FOLDER_DEVELOPMENT/$OLD_FOLDER_CODE" "$D/005__$OLD_FOLDER_DEVELOPMENT/$FOLDER_CODE"
            rename_if_exists "$D/005__$OLD_FOLDER_DEVELOPMENT/$OLD_FOLDER_NOTEBOOKS" "$D/005__$OLD_FOLDER_DEVELOPMENT/$FOLDER_NOTEBOOKS"
            rename_if_exists "$D/005__$OLD_FOLDER_DEVELOPMENT/$OLD_FOLDER_CONFIG" "$D/005__$OLD_FOLDER_DEVELOPMENT/$FOLDER_CONFIG"
            rename_if_exists "$D/005__$OLD_FOLDER_DEVELOPMENT/$OLD_FOLDER_REPOSITORY" "$D/005__$OLD_FOLDER_DEVELOPMENT/$FOLDER_REPOSITORY"
            rename_if_exists "$D/005__$OLD_FOLDER_DEVELOPMENT/$OLD_FOLDER_PACKAGE" "$D/005__$OLD_FOLDER_DEVELOPMENT/$FOLDER_PACKAGE"
            rename_if_exists "$D/005__$OLD_FOLDER_DEVELOPMENT" "$D/005__$FOLDER_DEVELOPMENT"

            # 006__Software
            rename_if_exists "$D/006__$OLD_FOLDER_SOFTWARE/$OLD_FOLDER_INSTALLERS" "$D/006__$OLD_FOLDER_SOFTWARE/$FOLDER_INSTALLERS"
            rename_if_exists "$D/006__$OLD_FOLDER_SOFTWARE/$OLD_FOLDER_ARCHIVES" "$D/006__$OLD_FOLDER_SOFTWARE/$FOLDER_ARCHIVES"
            rename_if_exists "$D/006__$OLD_FOLDER_SOFTWARE/$OLD_FOLDER_DOCKER" "$D/006__$OLD_FOLDER_SOFTWARE/$FOLDER_DOCKER"
            rename_if_exists "$D/006__$OLD_FOLDER_SOFTWARE/$OLD_FOLDER_SCRIPTS" "$D/006__$OLD_FOLDER_SOFTWARE/$FOLDER_SCRIPTS"
            rename_if_exists "$D/006__$OLD_FOLDER_SOFTWARE" "$D/006__$FOLDER_SOFTWARE"

            # 007__Lavoro
            rename_if_exists "$D/007__$OLD_FOLDER_WORK/$OLD_FOLDER_INVOICES" "$D/007__$OLD_FOLDER_WORK/$FOLDER_INVOICES"
            rename_if_exists "$D/007__$OLD_FOLDER_WORK/$OLD_FOLDER_CONTRACTS" "$D/007__$OLD_FOLDER_WORK/$FOLDER_CONTRACTS"
            rename_if_exists "$D/007__$OLD_FOLDER_WORK/$OLD_FOLDER_QUOTES" "$D/007__$OLD_FOLDER_WORK/$FOLDER_QUOTES"
            rename_if_exists "$D/007__$OLD_FOLDER_WORK/$OLD_FOLDER_OTHER_DOCS" "$D/007__$OLD_FOLDER_WORK/$FOLDER_OTHER_DOCS"
            rename_if_exists "$D/007__$OLD_FOLDER_WORK" "$D/007__$FOLDER_WORK"

            # 008__Temporaneo
            rename_if_exists "$D/008__$OLD_FOLDER_TEMPORARY" "$D/008__$FOLDER_TEMPORARY"

            echo ""
            echo "✅ Migrazione cartelle completata!"
        else
            echo "⏭️  Migrazione cartelle saltata."
        fi
    fi
fi

# Test esecuzione
echo ""
echo "🧪 Test esecuzione dello script..."
echo ""
"$SCRIPT_PATH"
echo ""

# Configurazione cron
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Configurazione Cron Job                                   ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Per eseguire lo script automaticamente ogni 3 ore:"
echo ""
echo "1️⃣  Apri l'editor cron:"
echo "    crontab -e"
echo ""
echo "2️⃣  Aggiungi questa riga alla fine del file:"
echo "    0 */3 * * * $SCRIPT_PATH >> $HOME/.download_organizer.log 2>&1"
echo ""
echo "    Questo eseguira lo script:"
echo "    - Ogni 3 ore (0, 3, 6, 9, 12, 15, 18, 21)"
echo "    - Log salvati in: ~/.download_organizer.log"
echo ""

# Nota su Full Disk Access per macOS
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  IMPORTANTE: Permessi macOS                                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "⚠️  macOS potrebbe bloccare l'accesso alla cartella Downloads."
echo "   Se il cron job non funziona, devi concedere l'accesso:"
echo ""
echo "   1. Apri Impostazioni di Sistema > Privacy e Sicurezza"
echo "      > Accesso completo al disco"
echo "   2. Clicca il lucchetto per sbloccare"
echo "   3. Aggiungi /usr/sbin/cron alla lista"
echo ""
echo "   In alternativa, aggiungi il Terminale (Terminal.app)"
echo "   alla lista di Accesso completo al disco."
echo ""

# Chiedi se configurare cron automaticamente
read -p "❓ Vuoi che io configuri il cron job automaticamente? (s/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Ss]$ ]] || [[ $REPLY =~ ^[Yy]$ ]]; then
    # Crea una entry cron
    CRON_ENTRY="0 */3 * * * $SCRIPT_PATH >> $HOME/.download_organizer.log 2>&1"

    # Verifica se l'entry esiste gia
    if crontab -l 2>/dev/null | grep -q "$SCRIPT_NAME"; then
        echo "⚠️  Il cron job esiste gia! Salto l'installazione."
    else
        # Aggiungi l'entry al crontab
        (crontab -l 2>/dev/null; echo "$CRON_ENTRY") | crontab -
        echo "✅ Cron job configurato con successo!"
        echo ""
        echo "📋 Cron job attuale:"
        crontab -l | grep "$SCRIPT_NAME"
    fi
else
    echo "⏭️  Configurazione cron saltata. Puoi farlo manualmente quando vuoi."
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Comandi Utili                                             ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "🚀 Esegui manualmente:"
echo "   $SCRIPT_PATH"
echo ""
echo "📊 Vedi i log:"
echo "   tail -f ~/.download_organizer.log"
echo ""
echo "⚙️  Modifica cron:"
echo "   crontab -e"
echo ""
echo "📋 Visualizza cron attivi:"
echo "   crontab -l"
echo ""
echo "🗑️  Rimuovi cron job:"
echo "   crontab -e  (poi cancella la riga manualmente)"
echo ""
echo "🌍 Cambia lingua:"
echo "   Riesegui ./install.sh e scegli una nuova lingua"
echo ""

echo "✨ Installazione completata!"
echo ""
