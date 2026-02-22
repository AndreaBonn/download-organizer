#!/bin/bash
# ============================================================================
# Sprache: Deutsch
# ============================================================================

LANG_NAME="Deutsch"
LANG_CODE="de"

# Ordnernamen
FOLDER_RECENT="Neueste"
FOLDER_TODAY="Heute"
FOLDER_THIS_WEEK="Diese-Woche"

FOLDER_DATA="Daten"
FOLDER_CSV="CSV"
FOLDER_EXCEL="Excel"
FOLDER_JSON="JSON"
FOLDER_DATABASE="Datenbank"
FOLDER_PARQUET="Parquet"
FOLDER_OTHER_FORMATS="Andere-Formate"

FOLDER_DOCUMENTS="Dokumente"
FOLDER_PDF="PDF"
FOLDER_WORD="Word"
FOLDER_PRESENTATIONS="Praesentationen"
FOLDER_TEXT="Text"
FOLDER_EBOOK="Ebook"

FOLDER_MEDIA="Medien"
FOLDER_IMAGES="Bilder"
FOLDER_VIDEO="Video"
FOLDER_AUDIO="Audio"
FOLDER_DIAGRAMS="Diagramme"

FOLDER_DEVELOPMENT="Entwicklung"
FOLDER_CODE="Code"
FOLDER_NOTEBOOKS="Notebooks"
FOLDER_CONFIG="Config"
FOLDER_REPOSITORY="Repository"
FOLDER_PACKAGE="Pakete"

FOLDER_SOFTWARE="Software"
FOLDER_INSTALLERS="Installationsprogramme"
FOLDER_ARCHIVES="Archive"
FOLDER_DOCKER="Docker"
FOLDER_SCRIPTS="Scripts"

FOLDER_WORK="Arbeit"
FOLDER_INVOICES="Rechnungen"
FOLDER_CONTRACTS="Vertraege"
FOLDER_QUOTES="Angebote"
FOLDER_OTHER_DOCS="Andere-Dokumente"

FOLDER_TEMPORARY="Temporaer"

# Schluesselwoerter fuer Arbeitsdokumente (Regex, getrennt durch |)
WORK_KW_INVOICES="rechnung|invoice|quittung|fattura"
WORK_KW_CONTRACTS="vertrag|contract|agreement|vereinbarung|contratto"
WORK_KW_QUOTES="angebot|quote|estimate|kostenvoranschlag|preventivo"

# Nachrichten
MSG_START="Starte Organisation des Download-Ordners"
MSG_DONE="Organisation abgeschlossen!"
MSG_CREATING_FOLDERS="Erstelle Ordnerstruktur..."
MSG_CREATED_FOLDER="Ordner erstellt"
MSG_MOVED="Verschoben"
MSG_DRY_MOVE="Wuerde verschieben"
MSG_DRY_DELETE="Wuerde loeschen"
MSG_DELETED="Alte Datei geloescht"
MSG_DIR_NOT_FOUND="Das Verzeichnis existiert nicht!"
MSG_PHASE1="Phase 1: Verschiebe neue Dateien nach"
MSG_PHASE2="Phase 2: Verschiebe von %TODAY% nach %THIS_WEEK%"
MSG_PHASE3="Phase 3: Kategorisiere Dateien aus %THIS_WEEK%"
MSG_PHASE4="Phase 4: Bereinige Ordner"
MSG_AGE="Alter"
MSG_DAYS="Tage"
MSG_LANG_NOT_FOUND="Sprachdatei nicht gefunden"
MSG_LANG_FALLBACK="Verwende Standardsprache (it)"
