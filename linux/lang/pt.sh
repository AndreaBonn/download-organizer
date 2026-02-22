#!/bin/bash
# ============================================================================
# Idioma: Portugues
# ============================================================================

LANG_NAME="Portugues"
LANG_CODE="pt"

# Nomes das pastas
FOLDER_RECENT="Recentes"
FOLDER_TODAY="Hoje"
FOLDER_THIS_WEEK="Esta-Semana"

FOLDER_DATA="Dados"
FOLDER_CSV="CSV"
FOLDER_EXCEL="Excel"
FOLDER_JSON="JSON"
FOLDER_DATABASE="Banco-de-Dados"
FOLDER_PARQUET="Parquet"
FOLDER_OTHER_FORMATS="Outros-Formatos"

FOLDER_DOCUMENTS="Documentos"
FOLDER_PDF="PDF"
FOLDER_WORD="Word"
FOLDER_PRESENTATIONS="Apresentacoes"
FOLDER_TEXT="Texto"
FOLDER_EBOOK="Ebook"

FOLDER_MEDIA="Media"
FOLDER_IMAGES="Imagens"
FOLDER_VIDEO="Video"
FOLDER_AUDIO="Audio"
FOLDER_DIAGRAMS="Diagramas"

FOLDER_DEVELOPMENT="Desenvolvimento"
FOLDER_CODE="Codigo"
FOLDER_NOTEBOOKS="Notebooks"
FOLDER_CONFIG="Config"
FOLDER_REPOSITORY="Repositorio"
FOLDER_PACKAGE="Pacotes"

FOLDER_SOFTWARE="Software"
FOLDER_INSTALLERS="Instaladores"
FOLDER_ARCHIVES="Arquivos"
FOLDER_DOCKER="Docker"
FOLDER_SCRIPTS="Scripts"

FOLDER_WORK="Trabalho"
FOLDER_INVOICES="Faturas"
FOLDER_CONTRACTS="Contratos"
FOLDER_QUOTES="Orcamentos"
FOLDER_OTHER_DOCS="Outros-Documentos"

FOLDER_TEMPORARY="Temporario"

# Palavras-chave para documentos de trabalho (regex, separadas por |)
WORK_KW_INVOICES="fatura|invoice|recibo|fattura"
WORK_KW_CONTRACTS="contrato|contract|agreement|acordo|contratto"
WORK_KW_QUOTES="orcamento|quote|estimate|proposta|preventivo"

# Mensagens
MSG_START="Iniciando organizacao da pasta Downloads"
MSG_DONE="Organizacao concluida!"
MSG_CREATING_FOLDERS="Criando estrutura de pastas..."
MSG_CREATED_FOLDER="Pasta criada"
MSG_MOVED="Movido"
MSG_DRY_MOVE="Moveria"
MSG_DRY_DELETE="Eliminaria"
MSG_DELETED="Arquivo antigo eliminado"
MSG_DIR_NOT_FOUND="O diretorio nao existe!"
MSG_PHASE1="Fase 1: Movendo novos arquivos para"
MSG_PHASE2="Fase 2: Movendo de %TODAY% para %THIS_WEEK%"
MSG_PHASE3="Fase 3: Categorizando arquivos de %THIS_WEEK%"
MSG_PHASE4="Fase 4: Limpando pasta"
MSG_AGE="idade"
MSG_DAYS="dias"
MSG_LANG_NOT_FOUND="Arquivo de idioma nao encontrado"
MSG_LANG_FALLBACK="Usando idioma padrao (it)"
