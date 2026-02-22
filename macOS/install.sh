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

# Definisci i percorsi
SCRIPT_NAME="organize_downloads.sh"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_PATH="$INSTALL_DIR/$SCRIPT_NAME"

# Crea la directory se non esiste
if [ ! -d "$INSTALL_DIR" ]; then
    echo "📁 Creazione directory $INSTALL_DIR..."
    mkdir -p "$INSTALL_DIR"
fi

# Copia lo script nella directory
echo "📋 Copia dello script in $INSTALL_DIR..."
cp "$SCRIPT_NAME" "$SCRIPT_PATH"

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
echo ""

# Test esecuzione
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

if [[ $REPLY =~ ^[Ss]$ ]]; then
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

echo "✨ Installazione completata!"
echo ""
