#!/bin/bash
# ============================================================================
# Langue: Francais
# ============================================================================

LANG_NAME="Francais"
LANG_CODE="fr"

# Noms des dossiers
FOLDER_RECENT="Recents"
FOLDER_TODAY="Aujourd-hui"
FOLDER_THIS_WEEK="Cette-Semaine"

FOLDER_DATA="Donnees"
FOLDER_CSV="CSV"
FOLDER_EXCEL="Excel"
FOLDER_JSON="JSON"
FOLDER_DATABASE="Base-de-Donnees"
FOLDER_PARQUET="Parquet"
FOLDER_OTHER_FORMATS="Autres-Formats"

FOLDER_DOCUMENTS="Documents"
FOLDER_PDF="PDF"
FOLDER_WORD="Word"
FOLDER_PRESENTATIONS="Presentations"
FOLDER_TEXT="Texte"
FOLDER_EBOOK="Ebook"

FOLDER_MEDIA="Media"
FOLDER_IMAGES="Images"
FOLDER_VIDEO="Video"
FOLDER_AUDIO="Audio"
FOLDER_DIAGRAMS="Diagrammes"

FOLDER_DEVELOPMENT="Developpement"
FOLDER_CODE="Code"
FOLDER_NOTEBOOKS="Notebooks"
FOLDER_CONFIG="Config"
FOLDER_REPOSITORY="Depot"
FOLDER_PACKAGE="Paquets"

FOLDER_SOFTWARE="Logiciels"
FOLDER_INSTALLERS="Installateurs"
FOLDER_ARCHIVES="Archives"
FOLDER_DOCKER="Docker"
FOLDER_SCRIPTS="Scripts"

FOLDER_WORK="Travail"
FOLDER_INVOICES="Factures"
FOLDER_CONTRACTS="Contrats"
FOLDER_QUOTES="Devis"
FOLDER_OTHER_DOCS="Autres-Documents"

FOLDER_TEMPORARY="Temporaire"

# Mots-cles pour documents de travail (regex, separes par |)
WORK_KW_INVOICES="facture|invoice|recu|fattura"
WORK_KW_CONTRACTS="contrat|contract|agreement|accord|contratto"
WORK_KW_QUOTES="devis|quote|estimate|offre|preventivo"

# Messages
MSG_START="Demarrage de l'organisation du dossier Telechargements"
MSG_DONE="Organisation terminee!"
MSG_CREATING_FOLDERS="Creation de la structure des dossiers..."
MSG_CREATED_FOLDER="Dossier cree"
MSG_MOVED="Deplace"
MSG_DRY_MOVE="Deplacerait"
MSG_DRY_DELETE="Supprimerait"
MSG_DELETED="Ancien fichier supprime"
MSG_DIR_NOT_FOUND="Le repertoire n'existe pas!"
MSG_PHASE1="Phase 1: Deplacement des nouveaux fichiers vers"
MSG_PHASE2="Phase 2: Deplacement de %TODAY% vers %THIS_WEEK%"
MSG_PHASE3="Phase 3: Categorisation des fichiers de %THIS_WEEK%"
MSG_PHASE4="Phase 4: Nettoyage du dossier"
MSG_AGE="age"
MSG_DAYS="jours"
MSG_LANG_NOT_FOUND="Fichier de langue introuvable"
MSG_LANG_FALLBACK="Utilisation de la langue par defaut (it)"
