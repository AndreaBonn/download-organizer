#!/bin/bash
# ============================================================================
# Language: English
# ============================================================================

LANG_NAME="English"
LANG_CODE="en"

# Folder names
FOLDER_RECENT="Recent"
FOLDER_TODAY="Today"
FOLDER_THIS_WEEK="This-Week"

FOLDER_DATA="Data"
FOLDER_CSV="CSV"
FOLDER_EXCEL="Excel"
FOLDER_JSON="JSON"
FOLDER_DATABASE="Database"
FOLDER_PARQUET="Parquet"
FOLDER_OTHER_FORMATS="Other-Formats"

FOLDER_DOCUMENTS="Documents"
FOLDER_PDF="PDF"
FOLDER_WORD="Word"
FOLDER_PRESENTATIONS="Presentations"
FOLDER_TEXT="Text"
FOLDER_EBOOK="Ebook"

FOLDER_MEDIA="Media"
FOLDER_IMAGES="Images"
FOLDER_VIDEO="Video"
FOLDER_AUDIO="Audio"
FOLDER_DIAGRAMS="Diagrams"

FOLDER_DEVELOPMENT="Development"
FOLDER_CODE="Code"
FOLDER_NOTEBOOKS="Notebooks"
FOLDER_CONFIG="Config"
FOLDER_REPOSITORY="Repository"
FOLDER_PACKAGE="Package"

FOLDER_SOFTWARE="Software"
FOLDER_INSTALLERS="Installers"
FOLDER_ARCHIVES="Archives"
FOLDER_DOCKER="Docker"
FOLDER_SCRIPTS="Scripts"

FOLDER_WORK="Work"
FOLDER_INVOICES="Invoices"
FOLDER_CONTRACTS="Contracts"
FOLDER_QUOTES="Quotes"
FOLDER_OTHER_DOCS="Other-Documents"

FOLDER_TEMPORARY="Temporary"

# Work document keywords (regex, separated by |)
WORK_KW_INVOICES="invoice|receipt|bill|fattura"
WORK_KW_CONTRACTS="contract|agreement|deed|contratto"
WORK_KW_QUOTES="quote|estimate|proposal|bid|preventivo"

# Messages
MSG_START="Starting Download folder organization"
MSG_DONE="Organization completed!"
MSG_CREATING_FOLDERS="Creating folder structure..."
MSG_CREATED_FOLDER="Created folder"
MSG_MOVED="Moved"
MSG_DRY_MOVE="Would move"
MSG_DRY_DELETE="Would delete"
MSG_DELETED="Deleted old file"
MSG_DIR_NOT_FOUND="Directory does not exist!"
MSG_PHASE1="Phase 1: Moving new files to"
MSG_PHASE2="Phase 2: Moving from %TODAY% to %THIS_WEEK%"
MSG_PHASE3="Phase 3: Categorizing files from %THIS_WEEK%"
MSG_PHASE4="Phase 4: Cleaning folder"
MSG_AGE="age"
MSG_DAYS="days"
MSG_LANG_NOT_FOUND="Language file not found"
MSG_LANG_FALLBACK="Using default language (it)"
