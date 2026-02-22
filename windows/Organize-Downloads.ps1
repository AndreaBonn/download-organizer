# ============================================================================
# Script di Organizzazione Automatica della Cartella Download - Windows
# ============================================================================
# Autore: Claude
# Descrizione: Organizza automaticamente i file in Download secondo una
#              struttura ibrida temporale + categorica
# Piattaforma: Windows PowerShell
# ============================================================================

# Configurazione
$DownloadDir = "$env:USERPROFILE\Downloads"
$LogFile = "$env:USERPROFILE\.download_organizer.log"
$DryRun = $false  # Cambia in $true per testare senza spostare file

# ============================================================================
# FUNZIONI DI UTILITA
# ============================================================================

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[$timestamp] $Message" | Out-File -FilePath $LogFile -Append -Encoding UTF8
}

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Type = "INFO"
    )

    $color = switch ($Type) {
        "INFO" { "Green" }
        "WARN" { "Yellow" }
        "ERROR" { "Red" }
        default { "White" }
    }

    Write-Host "[$Type] $Message" -ForegroundColor $color
    Write-Log "$Type: $Message"
}

function New-DirectoryIfNotExists {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-ColorOutput "Creata cartella: $Path" "INFO"
    }
}

function Move-FileWithCheck {
    param(
        [string]$SourcePath,
        [string]$DestinationDir
    )

    $fileName = Split-Path $SourcePath -Leaf
    $destinationPath = Join-Path $DestinationDir $fileName

    # Gestisci file con lo stesso nome
    if (Test-Path $destinationPath) {
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
        $extension = [System.IO.Path]::GetExtension($fileName)
        $counter = 1

        while (Test-Path $destinationPath) {
            if ($extension) {
                $destinationPath = Join-Path $DestinationDir "${baseName}_$counter$extension"
            } else {
                $destinationPath = Join-Path $DestinationDir "${fileName}_$counter"
            }
            $counter++
        }
    }

    if ($DryRun) {
        Write-ColorOutput "[DRY RUN] Sposterei: $fileName -> $DestinationDir" "INFO"
    } else {
        Move-Item -Path $SourcePath -Destination $destinationPath -Force
        Write-ColorOutput "Spostato: $fileName -> $DestinationDir" "INFO"
    }
}

# ============================================================================
# CREAZIONE STRUTTURA CARTELLE
# ============================================================================

function Initialize-FolderStructure {
    Write-ColorOutput "Creazione struttura cartelle..." "INFO"

    # 001__Recenti
    New-DirectoryIfNotExists (Join-Path $DownloadDir "001__Recenti\Oggi")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "001__Recenti\Questa-Settimana")

    # 002__Dati
    New-DirectoryIfNotExists (Join-Path $DownloadDir "002__Dati\CSV")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "002__Dati\Excel")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "002__Dati\JSON")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "002__Dati\Database")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "002__Dati\Parquet")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "002__Dati\Altri-Formati")

    # 003__Documenti
    New-DirectoryIfNotExists (Join-Path $DownloadDir "003__Documenti\PDF")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "003__Documenti\Word")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "003__Documenti\Presentazioni")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "003__Documenti\Testo")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "003__Documenti\Ebook")

    # 004__Media
    New-DirectoryIfNotExists (Join-Path $DownloadDir "004__Media\Immagini")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "004__Media\Video")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "004__Media\Audio")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "004__Media\Diagrammi")

    # 005__Sviluppo
    New-DirectoryIfNotExists (Join-Path $DownloadDir "005__Sviluppo\Codice")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "005__Sviluppo\Notebooks")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "005__Sviluppo\Config")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "005__Sviluppo\Repository")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "005__Sviluppo\Package")

    # 006__Software
    New-DirectoryIfNotExists (Join-Path $DownloadDir "006__Software\Installatori")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "006__Software\Archivi")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "006__Software\Docker")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "006__Software\Scripts")

    # 007__Lavoro
    New-DirectoryIfNotExists (Join-Path $DownloadDir "007__Lavoro\Fatture")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "007__Lavoro\Contratti")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "007__Lavoro\Preventivi")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "007__Lavoro\Altri-Documenti")

    # 008__Temporaneo
    New-DirectoryIfNotExists (Join-Path $DownloadDir "008__Temporaneo")
}

# ============================================================================
# FUNZIONI DI CATEGORIZZAZIONE
# ============================================================================

function Get-FileAgeDays {
    param([string]$FilePath)

    $fileInfo = Get-Item $FilePath
    $age = (Get-Date) - $fileInfo.LastWriteTime
    return [int]$age.TotalDays
}

function Test-WorkDocument {
    param([string]$FileName)

    $lowerName = $FileName.ToLower()
    return $lowerName -match "(fattura|invoice|contratto|contract|agreement|preventivo|quote|estimate)"
}

function Get-WorkCategory {
    param([string]$FileName)

    $lowerName = $FileName.ToLower()

    if ($lowerName -match "(fattura|invoice)") {
        return "Fatture"
    } elseif ($lowerName -match "(contratto|contract|agreement)") {
        return "Contratti"
    } elseif ($lowerName -match "(preventivo|quote|estimate)") {
        return "Preventivi"
    } else {
        return "Altri-Documenti"
    }
}

function Get-CategoryPath {
    param(
        [string]$FilePath,
        [string]$FileName
    )

    $extension = [System.IO.Path]::GetExtension($FileName).TrimStart('.').ToLower()

    # Documenti di lavoro (controllo nome file)
    if (Test-WorkDocument $FileName) {
        $subCategory = Get-WorkCategory $FileName
        return Join-Path $DownloadDir "007__Lavoro\$subCategory"
    }

    # 005__Sviluppo - Codice
    if ($extension -match "^(py|js|ts|jsx|tsx|go|rs|java|cpp|c|h|hpp|cs|php|rb|swift|kt|scala|r)$") {
        return Join-Path $DownloadDir "005__Sviluppo\Codice"
    }

    # 005__Sviluppo - Notebooks
    if ($extension -eq "ipynb") {
        return Join-Path $DownloadDir "005__Sviluppo\Notebooks"
    }

    # 005__Sviluppo - Config
    if ($extension -match "^(json|yaml|yml|toml|env|ini|conf|config|properties)$") {
        return Join-Path $DownloadDir "005__Sviluppo\Config"
    }

    # 005__Sviluppo - Package
    if ($extension -match "^(whl|egg|jar|nupkg)$") {
        return Join-Path $DownloadDir "005__Sviluppo\Package"
    }

    # 002__Dati - CSV
    if ($extension -match "^(csv|tsv)$") {
        return Join-Path $DownloadDir "002__Dati\CSV"
    }

    # 002__Dati - Excel
    if ($extension -match "^(xlsx|xls|xlsm|ods)$") {
        return Join-Path $DownloadDir "002__Dati\Excel"
    }

    # 002__Dati - JSON
    if ($extension -match "^(jsonl|ndjson)$") {
        return Join-Path $DownloadDir "002__Dati\JSON"
    }

    # 002__Dati - Database
    if ($extension -match "^(sql|db|sqlite|sqlite3|mdb|accdb)$") {
        return Join-Path $DownloadDir "002__Dati\Database"
    }

    # 002__Dati - Parquet
    if ($extension -match "^(parquet|feather|arrow)$") {
        return Join-Path $DownloadDir "002__Dati\Parquet"
    }

    # 002__Dati - Altri formati
    if ($extension -match "^(xml|avro|orc|hdf5|h5|mat)$") {
        return Join-Path $DownloadDir "002__Dati\Altri-Formati"
    }

    # 003__Documenti - PDF
    if ($extension -eq "pdf") {
        return Join-Path $DownloadDir "003__Documenti\PDF"
    }

    # 003__Documenti - Word
    if ($extension -match "^(doc|docx|odt|rtf)$") {
        return Join-Path $DownloadDir "003__Documenti\Word"
    }

    # 003__Documenti - Presentazioni
    if ($extension -match "^(ppt|pptx|odp)$") {
        return Join-Path $DownloadDir "003__Documenti\Presentazioni"
    }

    # 003__Documenti - Testo
    if ($extension -match "^(txt|md|rst|tex|log)$") {
        return Join-Path $DownloadDir "003__Documenti\Testo"
    }

    # 003__Documenti - Ebook
    if ($extension -match "^(epub|mobi|azw|azw3)$") {
        return Join-Path $DownloadDir "003__Documenti\Ebook"
    }

    # 004__Media - Immagini
    if ($extension -match "^(jpg|jpeg|png|gif|bmp|svg|webp|ico|tiff|tif|heic|raw|cr2|nef)$") {
        return Join-Path $DownloadDir "004__Media\Immagini"
    }

    # 004__Media - Video
    if ($extension -match "^(mp4|avi|mkv|mov|wmv|flv|webm|m4v|mpg|mpeg|3gp|ogv)$") {
        return Join-Path $DownloadDir "004__Media\Video"
    }

    # 004__Media - Audio
    if ($extension -match "^(mp3|wav|flac|aac|ogg|wma|m4a|opus|ape|alac)$") {
        return Join-Path $DownloadDir "004__Media\Audio"
    }

    # 004__Media - Diagrammi
    if ($extension -match "^(drawio|mermaid|puml|plantuml|vsd|vsdx)$") {
        return Join-Path $DownloadDir "004__Media\Diagrammi"
    }

    # 006__Software - Installatori
    if ($extension -match "^(exe|msi|appx|msix)$") {
        return Join-Path $DownloadDir "006__Software\Installatori"
    }

    # 006__Software - Scripts
    if ($extension -match "^(bat|ps1|cmd|vbs)$") {
        return Join-Path $DownloadDir "006__Software\Scripts"
    }

    # 006__Software - Docker
    if ($FileName -match "^(Dockerfile|docker-compose\.yml|docker-compose\.yaml)$") {
        return Join-Path $DownloadDir "006__Software\Docker"
    }

    # 006__Software - Archivi
    if ($extension -match "^(zip|rar|7z|tar|gz|bz2|xz|tgz)$") {
        # Se sembra un repository
        if ($FileName -match "(v[0-9]|src|source|master|main|repo)") {
            return Join-Path $DownloadDir "005__Sviluppo\Repository"
        } else {
            return Join-Path $DownloadDir "006__Software\Archivi"
        }
    }

    # Default: 008__Temporaneo
    return Join-Path $DownloadDir "008__Temporaneo"
}

# ============================================================================
# PROCESSO DI ORGANIZZAZIONE
# ============================================================================

function Invoke-ProcessNewFiles {
    Write-ColorOutput "=== Fase 1: Spostamento nuovi file in 001__Recenti\Oggi ===" "INFO"

    # Trova tutti i file direttamente in Download (non nelle sottocartelle)
    $files = Get-ChildItem -Path $DownloadDir -File -ErrorAction SilentlyContinue

    foreach ($file in $files) {
        $fileName = $file.Name

        # Ignora file nascosti e temporanei
        if ($fileName.StartsWith('.') -or $fileName.EndsWith('.tmp') -or $fileName.EndsWith('.crdownload') -or $fileName.EndsWith('.part')) {
            continue
        }

        $destDir = Join-Path $DownloadDir "001__Recenti\Oggi"
        Move-FileWithCheck -SourcePath $file.FullName -DestinationDir $destDir
    }
}

function Invoke-ProcessTodayToWeek {
    Write-ColorOutput "=== Fase 2: Spostamento da Oggi a Questa-Settimana ===" "INFO"

    $todayPath = Join-Path $DownloadDir "001__Recenti\Oggi"
    if (Test-Path $todayPath) {
        $files = Get-ChildItem -Path $todayPath -File -ErrorAction SilentlyContinue

        foreach ($file in $files) {
            $age = Get-FileAgeDays -FilePath $file.FullName

            if ($age -ge 1) {
                $destDir = Join-Path $DownloadDir "001__Recenti\Questa-Settimana"
                Move-FileWithCheck -SourcePath $file.FullName -DestinationDir $destDir
            }
        }
    }
}

function Invoke-ProcessWeekToCategories {
    Write-ColorOutput "=== Fase 3: Categorizzazione file da Questa-Settimana ===" "INFO"

    $weekPath = Join-Path $DownloadDir "001__Recenti\Questa-Settimana"
    if (Test-Path $weekPath) {
        $files = Get-ChildItem -Path $weekPath -File -ErrorAction SilentlyContinue

        foreach ($file in $files) {
            $age = Get-FileAgeDays -FilePath $file.FullName

            if ($age -ge 7) {
                $destDir = Get-CategoryPath -FilePath $file.FullName -FileName $file.Name
                Move-FileWithCheck -SourcePath $file.FullName -DestinationDir $destDir
            }
        }
    }
}

function Invoke-CleanTemporary {
    Write-ColorOutput "=== Fase 4: Pulizia cartella 008__Temporaneo ===" "INFO"

    $tempPath = Join-Path $DownloadDir "008__Temporaneo"
    if (Test-Path $tempPath) {
        $files = Get-ChildItem -Path $tempPath -File -ErrorAction SilentlyContinue

        foreach ($file in $files) {
            $age = Get-FileAgeDays -FilePath $file.FullName

            if ($age -ge 30) {
                if ($DryRun) {
                    Write-ColorOutput "[DRY RUN] Eliminerei: $($file.Name) (eta: $age giorni)" "WARN"
                } else {
                    Remove-Item -Path $file.FullName -Force
                    Write-ColorOutput "Eliminato file vecchio: $($file.Name) (eta: $age giorni)" "WARN"
                }
            }
        }
    }
}

# ============================================================================
# FUNZIONE PRINCIPALE
# ============================================================================

function Start-DownloadOrganizer {
    Write-ColorOutput "============================================" "INFO"
    Write-ColorOutput "Avvio organizzazione cartella Download" "INFO"
    Write-ColorOutput "Directory: $DownloadDir" "INFO"
    Write-ColorOutput "============================================" "INFO"

    # Verifica che la directory Download esista
    if (-not (Test-Path $DownloadDir)) {
        Write-ColorOutput "La directory $DownloadDir non esiste!" "ERROR"
        exit 1
    }

    # Crea la struttura delle cartelle
    Initialize-FolderStructure

    # Esegui le fasi di organizzazione
    Invoke-ProcessNewFiles
    Invoke-ProcessTodayToWeek
    Invoke-ProcessWeekToCategories
    Invoke-CleanTemporary

    Write-ColorOutput "============================================" "INFO"
    Write-ColorOutput "Organizzazione completata!" "INFO"
    Write-ColorOutput "============================================" "INFO"
}

# Esegui lo script
Start-DownloadOrganizer
