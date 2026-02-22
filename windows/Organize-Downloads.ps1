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

# Configurazione lingua
$Language = "it"  # Impostata dall'installer
$LangDir = "$env:USERPROFILE\Scripts\lang"

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

# Carica il file di lingua
function Import-Language {
    $langFile = Join-Path $LangDir "$Language.ps1"
    if (Test-Path $langFile) {
        . $langFile
    } else {
        # Fallback: cerca nella directory dello script
        $scriptDir = Split-Path -Parent $MyInvocation.ScriptName
        $localLangFile = Join-Path $scriptDir "lang\$Language.ps1"
        if (Test-Path $localLangFile) {
            . $localLangFile
        } else {
            Write-ColorOutput "File lingua non trovato: $langFile" "ERROR"
            Write-ColorOutput "Uso lingua predefinita (it)" "ERROR"
            # Fallback a italiano
            $fallback = Join-Path $LangDir "it.ps1"
            if (Test-Path $fallback) {
                . $fallback
            } else {
                $localFallback = Join-Path $scriptDir "lang\it.ps1"
                if (Test-Path $localFallback) {
                    . $localFallback
                }
            }
        }
    }
}

function New-DirectoryIfNotExists {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-ColorOutput "$MsgCreatedFolder`: $Path" "INFO"
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
        Write-ColorOutput "[DRY RUN] $MsgDryMove`: $fileName -> $DestinationDir" "INFO"
    } else {
        Move-Item -Path $SourcePath -Destination $destinationPath -Force
        Write-ColorOutput "$MsgMoved`: $fileName -> $DestinationDir" "INFO"
    }
}

# ============================================================================
# CREAZIONE STRUTTURA CARTELLE
# ============================================================================

function Initialize-FolderStructure {
    Write-ColorOutput "$MsgCreatingFolders" "INFO"

    # 001__Recenti
    New-DirectoryIfNotExists (Join-Path $DownloadDir "001__$FolderRecent\$FolderToday")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "001__$FolderRecent\$FolderThisWeek")

    # 002__Dati
    New-DirectoryIfNotExists (Join-Path $DownloadDir "002__$FolderData\$FolderCSV")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "002__$FolderData\$FolderExcel")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "002__$FolderData\$FolderJSON")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "002__$FolderData\$FolderDatabase")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "002__$FolderData\$FolderParquet")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "002__$FolderData\$FolderOtherFormats")

    # 003__Documenti
    New-DirectoryIfNotExists (Join-Path $DownloadDir "003__$FolderDocuments\$FolderPDF")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "003__$FolderDocuments\$FolderWord")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "003__$FolderDocuments\$FolderPresentations")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "003__$FolderDocuments\$FolderText")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "003__$FolderDocuments\$FolderEbook")

    # 004__Media
    New-DirectoryIfNotExists (Join-Path $DownloadDir "004__$FolderMedia\$FolderImages")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "004__$FolderMedia\$FolderVideo")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "004__$FolderMedia\$FolderAudio")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "004__$FolderMedia\$FolderDiagrams")

    # 005__Sviluppo
    New-DirectoryIfNotExists (Join-Path $DownloadDir "005__$FolderDevelopment\$FolderCode")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "005__$FolderDevelopment\$FolderNotebooks")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "005__$FolderDevelopment\$FolderConfig")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "005__$FolderDevelopment\$FolderRepository")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "005__$FolderDevelopment\$FolderPackage")

    # 006__Software
    New-DirectoryIfNotExists (Join-Path $DownloadDir "006__$FolderSoftware\$FolderInstallers")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "006__$FolderSoftware\$FolderArchives")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "006__$FolderSoftware\$FolderDocker")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "006__$FolderSoftware\$FolderScripts")

    # 007__Lavoro
    New-DirectoryIfNotExists (Join-Path $DownloadDir "007__$FolderWork\$FolderInvoices")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "007__$FolderWork\$FolderContracts")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "007__$FolderWork\$FolderQuotes")
    New-DirectoryIfNotExists (Join-Path $DownloadDir "007__$FolderWork\$FolderOtherDocs")

    # 008__Temporaneo
    New-DirectoryIfNotExists (Join-Path $DownloadDir "008__$FolderTemporary")
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
    return $lowerName -match $WorkKwAll
}

function Get-WorkCategory {
    param([string]$FileName)

    $lowerName = $FileName.ToLower()

    if ($lowerName -match $WorkKwInvoices) {
        return $FolderInvoices
    } elseif ($lowerName -match $WorkKwContracts) {
        return $FolderContracts
    } elseif ($lowerName -match $WorkKwQuotes) {
        return $FolderQuotes
    } else {
        return $FolderOtherDocs
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
        return Join-Path $DownloadDir "007__$FolderWork\$subCategory"
    }

    # 005__Sviluppo - Codice
    if ($extension -match "^(py|js|ts|jsx|tsx|go|rs|java|cpp|c|h|hpp|cs|php|rb|swift|kt|scala|r)$") {
        return Join-Path $DownloadDir "005__$FolderDevelopment\$FolderCode"
    }

    # 005__Sviluppo - Notebooks
    if ($extension -eq "ipynb") {
        return Join-Path $DownloadDir "005__$FolderDevelopment\$FolderNotebooks"
    }

    # 005__Sviluppo - Config
    if ($extension -match "^(json|yaml|yml|toml|env|ini|conf|config|properties)$") {
        return Join-Path $DownloadDir "005__$FolderDevelopment\$FolderConfig"
    }

    # 005__Sviluppo - Package
    if ($extension -match "^(whl|egg|jar|nupkg)$") {
        return Join-Path $DownloadDir "005__$FolderDevelopment\$FolderPackage"
    }

    # 002__Dati - CSV
    if ($extension -match "^(csv|tsv)$") {
        return Join-Path $DownloadDir "002__$FolderData\$FolderCSV"
    }

    # 002__Dati - Excel
    if ($extension -match "^(xlsx|xls|xlsm|ods)$") {
        return Join-Path $DownloadDir "002__$FolderData\$FolderExcel"
    }

    # 002__Dati - JSON
    if ($extension -match "^(jsonl|ndjson)$") {
        return Join-Path $DownloadDir "002__$FolderData\$FolderJSON"
    }

    # 002__Dati - Database
    if ($extension -match "^(sql|db|sqlite|sqlite3|mdb|accdb)$") {
        return Join-Path $DownloadDir "002__$FolderData\$FolderDatabase"
    }

    # 002__Dati - Parquet
    if ($extension -match "^(parquet|feather|arrow)$") {
        return Join-Path $DownloadDir "002__$FolderData\$FolderParquet"
    }

    # 002__Dati - Altri formati
    if ($extension -match "^(xml|avro|orc|hdf5|h5|mat)$") {
        return Join-Path $DownloadDir "002__$FolderData\$FolderOtherFormats"
    }

    # 003__Documenti - PDF
    if ($extension -eq "pdf") {
        return Join-Path $DownloadDir "003__$FolderDocuments\$FolderPDF"
    }

    # 003__Documenti - Word
    if ($extension -match "^(doc|docx|odt|rtf)$") {
        return Join-Path $DownloadDir "003__$FolderDocuments\$FolderWord"
    }

    # 003__Documenti - Presentazioni
    if ($extension -match "^(ppt|pptx|odp)$") {
        return Join-Path $DownloadDir "003__$FolderDocuments\$FolderPresentations"
    }

    # 003__Documenti - Testo
    if ($extension -match "^(txt|md|rst|tex|log)$") {
        return Join-Path $DownloadDir "003__$FolderDocuments\$FolderText"
    }

    # 003__Documenti - Ebook
    if ($extension -match "^(epub|mobi|azw|azw3)$") {
        return Join-Path $DownloadDir "003__$FolderDocuments\$FolderEbook"
    }

    # 004__Media - Immagini
    if ($extension -match "^(jpg|jpeg|png|gif|bmp|svg|webp|ico|tiff|tif|heic|raw|cr2|nef)$") {
        return Join-Path $DownloadDir "004__$FolderMedia\$FolderImages"
    }

    # 004__Media - Video
    if ($extension -match "^(mp4|avi|mkv|mov|wmv|flv|webm|m4v|mpg|mpeg|3gp|ogv)$") {
        return Join-Path $DownloadDir "004__$FolderMedia\$FolderVideo"
    }

    # 004__Media - Audio
    if ($extension -match "^(mp3|wav|flac|aac|ogg|wma|m4a|opus|ape|alac)$") {
        return Join-Path $DownloadDir "004__$FolderMedia\$FolderAudio"
    }

    # 004__Media - Diagrammi
    if ($extension -match "^(drawio|mermaid|puml|plantuml|vsd|vsdx)$") {
        return Join-Path $DownloadDir "004__$FolderMedia\$FolderDiagrams"
    }

    # 006__Software - Installatori
    if ($extension -match "^(exe|msi|appx|msix)$") {
        return Join-Path $DownloadDir "006__$FolderSoftware\$FolderInstallers"
    }

    # 006__Software - Scripts
    if ($extension -match "^(bat|ps1|cmd|vbs)$") {
        return Join-Path $DownloadDir "006__$FolderSoftware\$FolderScripts"
    }

    # 006__Software - Docker
    if ($FileName -match "^(Dockerfile|docker-compose\.yml|docker-compose\.yaml)$") {
        return Join-Path $DownloadDir "006__$FolderSoftware\$FolderDocker"
    }

    # 006__Software - Archivi
    if ($extension -match "^(zip|rar|7z|tar|gz|bz2|xz|tgz)$") {
        # Se sembra un repository
        if ($FileName -match "(v[0-9]|src|source|master|main|repo)") {
            return Join-Path $DownloadDir "005__$FolderDevelopment\$FolderRepository"
        } else {
            return Join-Path $DownloadDir "006__$FolderSoftware\$FolderArchives"
        }
    }

    # Default: 008__Temporaneo
    return Join-Path $DownloadDir "008__$FolderTemporary"
}

# ============================================================================
# PROCESSO DI ORGANIZZAZIONE
# ============================================================================

function Invoke-ProcessNewFiles {
    Write-ColorOutput "=== $MsgPhase1 001__$FolderRecent\$FolderToday ===" "INFO"

    # Trova tutti i file direttamente in Download (non nelle sottocartelle)
    $files = Get-ChildItem -Path $DownloadDir -File -ErrorAction SilentlyContinue

    foreach ($file in $files) {
        $fileName = $file.Name

        # Ignora file nascosti e temporanei
        if ($fileName.StartsWith('.') -or $fileName.EndsWith('.tmp') -or $fileName.EndsWith('.crdownload') -or $fileName.EndsWith('.part')) {
            continue
        }

        $destDir = Join-Path $DownloadDir "001__$FolderRecent\$FolderToday"
        Move-FileWithCheck -SourcePath $file.FullName -DestinationDir $destDir
    }
}

function Invoke-ProcessTodayToWeek {
    Write-ColorOutput "=== $MsgPhase2 ===" "INFO"

    $todayPath = Join-Path $DownloadDir "001__$FolderRecent\$FolderToday"
    if (Test-Path $todayPath) {
        $files = Get-ChildItem -Path $todayPath -File -ErrorAction SilentlyContinue

        foreach ($file in $files) {
            $age = Get-FileAgeDays -FilePath $file.FullName

            if ($age -ge 1) {
                $destDir = Join-Path $DownloadDir "001__$FolderRecent\$FolderThisWeek"
                Move-FileWithCheck -SourcePath $file.FullName -DestinationDir $destDir
            }
        }
    }
}

function Invoke-ProcessWeekToCategories {
    Write-ColorOutput "=== $MsgPhase3 ===" "INFO"

    $weekPath = Join-Path $DownloadDir "001__$FolderRecent\$FolderThisWeek"
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
    Write-ColorOutput "=== $MsgPhase4 008__$FolderTemporary ===" "INFO"

    $tempPath = Join-Path $DownloadDir "008__$FolderTemporary"
    if (Test-Path $tempPath) {
        $files = Get-ChildItem -Path $tempPath -File -ErrorAction SilentlyContinue

        foreach ($file in $files) {
            $age = Get-FileAgeDays -FilePath $file.FullName

            if ($age -ge 30) {
                if ($DryRun) {
                    Write-ColorOutput "[DRY RUN] $MsgDryDelete`: $($file.Name) ($MsgAge`: $age $MsgDays)" "WARN"
                } else {
                    Remove-Item -Path $file.FullName -Force
                    Write-ColorOutput "$MsgDeleted`: $($file.Name) ($MsgAge`: $age $MsgDays)" "WARN"
                }
            }
        }
    }
}

# ============================================================================
# FUNZIONE PRINCIPALE
# ============================================================================

function Start-DownloadOrganizer {
    # Carica la lingua
    Import-Language

    Write-ColorOutput "============================================" "INFO"
    Write-ColorOutput "$MsgStart" "INFO"
    Write-ColorOutput "Directory: $DownloadDir" "INFO"
    Write-ColorOutput "============================================" "INFO"

    # Verifica che la directory Download esista
    if (-not (Test-Path $DownloadDir)) {
        Write-ColorOutput "$MsgDirNotFound $DownloadDir" "ERROR"
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
    Write-ColorOutput "$MsgDone" "INFO"
    Write-ColorOutput "============================================" "INFO"
}

# Esegui lo script
Start-DownloadOrganizer
