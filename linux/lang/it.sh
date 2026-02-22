#!/bin/bash
# ============================================================================
# Lingua: Italiano
# ============================================================================

LANG_NAME="Italiano"
LANG_CODE="it"

# Nomi cartelle
FOLDER_RECENT="Recenti"
FOLDER_TODAY="Oggi"
FOLDER_THIS_WEEK="Questa-Settimana"

FOLDER_DATA="Dati"
FOLDER_CSV="CSV"
FOLDER_EXCEL="Excel"
FOLDER_JSON="JSON"
FOLDER_DATABASE="Database"
FOLDER_PARQUET="Parquet"
FOLDER_OTHER_FORMATS="Altri-Formati"

FOLDER_DOCUMENTS="Documenti"
FOLDER_PDF="PDF"
FOLDER_WORD="Word"
FOLDER_PRESENTATIONS="Presentazioni"
FOLDER_TEXT="Testo"
FOLDER_EBOOK="Ebook"

FOLDER_MEDIA="Media"
FOLDER_IMAGES="Immagini"
FOLDER_VIDEO="Video"
FOLDER_AUDIO="Audio"
FOLDER_DIAGRAMS="Diagrammi"

FOLDER_DEVELOPMENT="Sviluppo"
FOLDER_CODE="Codice"
FOLDER_NOTEBOOKS="Notebooks"
FOLDER_CONFIG="Config"
FOLDER_REPOSITORY="Repository"
FOLDER_PACKAGE="Package"

FOLDER_SOFTWARE="Software"
FOLDER_INSTALLERS="Installatori"
FOLDER_ARCHIVES="Archivi"
FOLDER_DOCKER="Docker"
FOLDER_SCRIPTS="Scripts"

FOLDER_WORK="Lavoro"
FOLDER_INVOICES="Fatture"
FOLDER_CONTRACTS="Contratti"
FOLDER_QUOTES="Preventivi"
FOLDER_OTHER_DOCS="Altri-Documenti"

FOLDER_TEMPORARY="Temporaneo"

# Keyword per documenti di lavoro (regex, separate da |)
WORK_KW_INVOICES="fattura|invoice|ricevuta"
WORK_KW_CONTRACTS="contratto|contract|agreement|accordo"
WORK_KW_QUOTES="preventivo|quote|estimate|offerta"

# Messaggi
MSG_START="Avvio organizzazione cartella Download"
MSG_DONE="Organizzazione completata!"
MSG_CREATING_FOLDERS="Creazione struttura cartelle..."
MSG_CREATED_FOLDER="Creata cartella"
MSG_MOVED="Spostato"
MSG_DRY_MOVE="Sposterei"
MSG_DRY_DELETE="Eliminerei"
MSG_DELETED="Eliminato file vecchio"
MSG_DIR_NOT_FOUND="La directory non esiste!"
MSG_PHASE1="Fase 1: Spostamento nuovi file in"
MSG_PHASE2="Fase 2: Spostamento da %TODAY% a %THIS_WEEK%"
MSG_PHASE3="Fase 3: Categorizzazione file da %THIS_WEEK%"
MSG_PHASE4="Fase 4: Pulizia cartella"
MSG_AGE="eta"
MSG_DAYS="giorni"
MSG_LANG_NOT_FOUND="File lingua non trovato"
MSG_LANG_FALLBACK="Uso lingua predefinita (it)"
