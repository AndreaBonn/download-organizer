#!/bin/bash
# ============================================================================
# Idioma: Espanol
# ============================================================================

LANG_NAME="Espanol"
LANG_CODE="es"

# Nombres de carpetas
FOLDER_RECENT="Recientes"
FOLDER_TODAY="Hoy"
FOLDER_THIS_WEEK="Esta-Semana"

FOLDER_DATA="Datos"
FOLDER_CSV="CSV"
FOLDER_EXCEL="Excel"
FOLDER_JSON="JSON"
FOLDER_DATABASE="Base-de-Datos"
FOLDER_PARQUET="Parquet"
FOLDER_OTHER_FORMATS="Otros-Formatos"

FOLDER_DOCUMENTS="Documentos"
FOLDER_PDF="PDF"
FOLDER_WORD="Word"
FOLDER_PRESENTATIONS="Presentaciones"
FOLDER_TEXT="Texto"
FOLDER_EBOOK="Ebook"

FOLDER_MEDIA="Media"
FOLDER_IMAGES="Imagenes"
FOLDER_VIDEO="Video"
FOLDER_AUDIO="Audio"
FOLDER_DIAGRAMS="Diagramas"

FOLDER_DEVELOPMENT="Desarrollo"
FOLDER_CODE="Codigo"
FOLDER_NOTEBOOKS="Notebooks"
FOLDER_CONFIG="Config"
FOLDER_REPOSITORY="Repositorio"
FOLDER_PACKAGE="Paquetes"

FOLDER_SOFTWARE="Software"
FOLDER_INSTALLERS="Instaladores"
FOLDER_ARCHIVES="Archivos"
FOLDER_DOCKER="Docker"
FOLDER_SCRIPTS="Scripts"

FOLDER_WORK="Trabajo"
FOLDER_INVOICES="Facturas"
FOLDER_CONTRACTS="Contratos"
FOLDER_QUOTES="Presupuestos"
FOLDER_OTHER_DOCS="Otros-Documentos"

FOLDER_TEMPORARY="Temporal"

# Palabras clave para documentos de trabajo (regex, separadas por |)
WORK_KW_INVOICES="factura|invoice|recibo|fattura"
WORK_KW_CONTRACTS="contrato|contract|agreement|acuerdo|contratto"
WORK_KW_QUOTES="presupuesto|quote|estimate|oferta|preventivo"

# Mensajes
MSG_START="Iniciando organizacion de carpeta Descargas"
MSG_DONE="Organizacion completada!"
MSG_CREATING_FOLDERS="Creando estructura de carpetas..."
MSG_CREATED_FOLDER="Carpeta creada"
MSG_MOVED="Movido"
MSG_DRY_MOVE="Moveria"
MSG_DRY_DELETE="Eliminaria"
MSG_DELETED="Archivo antiguo eliminado"
MSG_DIR_NOT_FOUND="El directorio no existe!"
MSG_PHASE1="Fase 1: Moviendo nuevos archivos a"
MSG_PHASE2="Fase 2: Moviendo de %TODAY% a %THIS_WEEK%"
MSG_PHASE3="Fase 3: Categorizando archivos de %THIS_WEEK%"
MSG_PHASE4="Fase 4: Limpiando carpeta"
MSG_AGE="antiguedad"
MSG_DAYS="dias"
MSG_LANG_NOT_FOUND="Archivo de idioma no encontrado"
MSG_LANG_FALLBACK="Usando idioma predeterminado (it)"
