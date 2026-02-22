# ============================================================================
# Script di Installazione - Download Organizer per Windows
# ============================================================================
# Questo script installa e configura l'organizzatore automatico di Download
# ============================================================================

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Installazione Download Organizer per Windows              ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ============================================================================
# SELEZIONE LINGUA / LANGUAGE SELECTION
# ============================================================================

Write-Host "Scegli la lingua / Choose your language:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1) Italiano"
Write-Host "  2) English"
Write-Host "  3) Español"
Write-Host "  4) Français"
Write-Host "  5) Deutsch"
Write-Host "  6) Português"
Write-Host ""
$langChoice = Read-Host "Lingua/Language [1]"

$Language = switch ($langChoice) {
    "2" { "en" }
    "3" { "es" }
    "4" { "fr" }
    "5" { "de" }
    "6" { "pt" }
    default { "it" }
}

Write-Host ""

# Verifica privilegi amministratore
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "⚠️  ATTENZIONE: Questo script richiede privilegi di amministratore per configurare il Task Scheduler." -ForegroundColor Yellow
    Write-Host "   Riavvia PowerShell come Amministratore e riprova." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "   In alternativa, puoi:" -ForegroundColor Yellow
    Write-Host "   1. Eseguire manualmente lo script: .\Organize-Downloads.ps1" -ForegroundColor Yellow
    Write-Host "   2. Configurare il Task Scheduler manualmente (vedi istruzioni sotto)" -ForegroundColor Yellow
    Write-Host ""

    $continue = Read-Host "Vuoi continuare comunque senza configurare il Task Scheduler? (s/n)"
    if ($continue -ne 's' -and $continue -ne 'S' -and $continue -ne 'y' -and $continue -ne 'Y') {
        exit
    }
}

# Definisci i percorsi
$ScriptName = "Organize-Downloads.ps1"
$InstallDir = "$env:USERPROFILE\Scripts"
$ScriptPath = Join-Path $InstallDir $ScriptName
$LangInstallDir = Join-Path $InstallDir "lang"

# Crea le directory se non esistono
if (-not (Test-Path $InstallDir)) {
    Write-Host "📁 Creazione directory $InstallDir..." -ForegroundColor Green
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

if (-not (Test-Path $LangInstallDir)) {
    New-Item -ItemType Directory -Path $LangInstallDir -Force | Out-Null
}

# Copia lo script nella directory
Write-Host "📋 Copia dello script in $InstallDir..." -ForegroundColor Green
Copy-Item -Path $ScriptName -Destination $ScriptPath -Force

# Imposta la lingua nello script installato
(Get-Content $ScriptPath) -replace '^\$Language = ".*"', "`$Language = `"$Language`"" | Set-Content $ScriptPath

# Copia i file di lingua
Write-Host "🌍 Copia file di lingua in $LangInstallDir..." -ForegroundColor Green
Copy-Item -Path "lang\*.ps1" -Destination $LangInstallDir -Force

Write-Host ""
Write-Host "✅ Script installato con successo in: $ScriptPath" -ForegroundColor Green
Write-Host "🌍 Lingua selezionata: $Language" -ForegroundColor Green
Write-Host ""

# ============================================================================
# MIGRAZIONE CARTELLE ESISTENTI
# ============================================================================

$DownloadDirCheck = "$env:USERPROFILE\Downloads"

if (Test-Path $DownloadDirCheck) {
    # Carica la nuova lingua
    . "lang\$Language.ps1"
    $NewFolderRecent = $FolderRecent

    # Cerca cartelle con prefisso numerico di una lingua diversa
    $hasOldFolders = $false
    $oldLanguage = ""

    foreach ($oldLang in @("it", "en", "es", "fr", "de", "pt")) {
        if ($oldLang -eq $Language) { continue }

        $oldLangFile = "lang\$oldLang.ps1"
        if (Test-Path $oldLangFile) {
            . $oldLangFile
            $oldRecentCheck = $FolderRecent

            if (Test-Path (Join-Path $DownloadDirCheck "001__$oldRecentCheck")) {
                $hasOldFolders = $true
                $oldLanguage = $oldLang
                break
            }
        }
    }

    if ($hasOldFolders) {
        Write-Host ""
        Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
        Write-Host "║  Cartelle esistenti rilevate (lingua: $oldLanguage)               ║" -ForegroundColor Yellow
        Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
        Write-Host ""
        $migrateChoice = Read-Host "Vuoi rinominare le cartelle nella nuova lingua ($Language)? (s/n)"

        if ($migrateChoice -eq 's' -or $migrateChoice -eq 'S' -or $migrateChoice -eq 'y' -or $migrateChoice -eq 'Y') {
            Write-Host "📂 Migrazione cartelle in corso..." -ForegroundColor Green

            # Carica nomi vecchi
            . "lang\$oldLanguage.ps1"
            $OldRecent = $FolderRecent; $OldToday = $FolderToday; $OldThisWeek = $FolderThisWeek
            $OldData = $FolderData; $OldCSV = $FolderCSV; $OldExcel = $FolderExcel
            $OldJSON = $FolderJSON; $OldDatabase = $FolderDatabase; $OldParquet = $FolderParquet
            $OldOtherFormats = $FolderOtherFormats; $OldDocuments = $FolderDocuments
            $OldPDF = $FolderPDF; $OldWord = $FolderWord; $OldPresentations = $FolderPresentations
            $OldText = $FolderText; $OldEbook = $FolderEbook; $OldMedia = $FolderMedia
            $OldImages = $FolderImages; $OldVideo = $FolderVideo; $OldAudio = $FolderAudio
            $OldDiagrams = $FolderDiagrams; $OldDevelopment = $FolderDevelopment
            $OldCode = $FolderCode; $OldNotebooks = $FolderNotebooks; $OldConfig = $FolderConfig
            $OldRepository = $FolderRepository; $OldPackage = $FolderPackage
            $OldSoftware = $FolderSoftware; $OldInstallers = $FolderInstallers
            $OldArchives = $FolderArchives; $OldDocker = $FolderDocker; $OldScripts = $FolderScripts
            $OldWork = $FolderWork; $OldInvoices = $FolderInvoices; $OldContracts = $FolderContracts
            $OldQuotes = $FolderQuotes; $OldOtherDocs = $FolderOtherDocs
            $OldTemporary = $FolderTemporary

            # Ricarica nomi nuovi
            . "lang\$Language.ps1"

            # Funzione per rinominare in sicurezza
            function Rename-IfExists {
                param([string]$OldPath, [string]$NewPath)
                if ((Test-Path $OldPath) -and ($OldPath -ne $NewPath)) {
                    if (Test-Path $NewPath) {
                        Write-Host "   ⚠️  $NewPath esiste già, sposto i file..." -ForegroundColor Yellow
                        Get-ChildItem -Path $OldPath -File | Move-Item -Destination $NewPath -Force
                        Remove-Item -Path $OldPath -Force -ErrorAction SilentlyContinue
                    } else {
                        Rename-Item -Path $OldPath -NewName (Split-Path $NewPath -Leaf)
                        Write-Host "   ✅ $(Split-Path $OldPath -Leaf) → $(Split-Path $NewPath -Leaf)" -ForegroundColor Green
                    }
                }
            }

            $D = $DownloadDirCheck

            # Rinomina sottocartelle prima delle cartelle principali
            Rename-IfExists "$D\001__$OldRecent\$OldToday" "$D\001__$OldRecent\$FolderToday"
            Rename-IfExists "$D\001__$OldRecent\$OldThisWeek" "$D\001__$OldRecent\$FolderThisWeek"
            Rename-IfExists "$D\001__$OldRecent" "$D\001__$FolderRecent"

            Rename-IfExists "$D\002__$OldData\$OldCSV" "$D\002__$OldData\$FolderCSV"
            Rename-IfExists "$D\002__$OldData\$OldExcel" "$D\002__$OldData\$FolderExcel"
            Rename-IfExists "$D\002__$OldData\$OldJSON" "$D\002__$OldData\$FolderJSON"
            Rename-IfExists "$D\002__$OldData\$OldDatabase" "$D\002__$OldData\$FolderDatabase"
            Rename-IfExists "$D\002__$OldData\$OldParquet" "$D\002__$OldData\$FolderParquet"
            Rename-IfExists "$D\002__$OldData\$OldOtherFormats" "$D\002__$OldData\$FolderOtherFormats"
            Rename-IfExists "$D\002__$OldData" "$D\002__$FolderData"

            Rename-IfExists "$D\003__$OldDocuments\$OldPDF" "$D\003__$OldDocuments\$FolderPDF"
            Rename-IfExists "$D\003__$OldDocuments\$OldWord" "$D\003__$OldDocuments\$FolderWord"
            Rename-IfExists "$D\003__$OldDocuments\$OldPresentations" "$D\003__$OldDocuments\$FolderPresentations"
            Rename-IfExists "$D\003__$OldDocuments\$OldText" "$D\003__$OldDocuments\$FolderText"
            Rename-IfExists "$D\003__$OldDocuments\$OldEbook" "$D\003__$OldDocuments\$FolderEbook"
            Rename-IfExists "$D\003__$OldDocuments" "$D\003__$FolderDocuments"

            Rename-IfExists "$D\004__$OldMedia\$OldImages" "$D\004__$OldMedia\$FolderImages"
            Rename-IfExists "$D\004__$OldMedia\$OldVideo" "$D\004__$OldMedia\$FolderVideo"
            Rename-IfExists "$D\004__$OldMedia\$OldAudio" "$D\004__$OldMedia\$FolderAudio"
            Rename-IfExists "$D\004__$OldMedia\$OldDiagrams" "$D\004__$OldMedia\$FolderDiagrams"
            Rename-IfExists "$D\004__$OldMedia" "$D\004__$FolderMedia"

            Rename-IfExists "$D\005__$OldDevelopment\$OldCode" "$D\005__$OldDevelopment\$FolderCode"
            Rename-IfExists "$D\005__$OldDevelopment\$OldNotebooks" "$D\005__$OldDevelopment\$FolderNotebooks"
            Rename-IfExists "$D\005__$OldDevelopment\$OldConfig" "$D\005__$OldDevelopment\$FolderConfig"
            Rename-IfExists "$D\005__$OldDevelopment\$OldRepository" "$D\005__$OldDevelopment\$FolderRepository"
            Rename-IfExists "$D\005__$OldDevelopment\$OldPackage" "$D\005__$OldDevelopment\$FolderPackage"
            Rename-IfExists "$D\005__$OldDevelopment" "$D\005__$FolderDevelopment"

            Rename-IfExists "$D\006__$OldSoftware\$OldInstallers" "$D\006__$OldSoftware\$FolderInstallers"
            Rename-IfExists "$D\006__$OldSoftware\$OldArchives" "$D\006__$OldSoftware\$FolderArchives"
            Rename-IfExists "$D\006__$OldSoftware\$OldDocker" "$D\006__$OldSoftware\$FolderDocker"
            Rename-IfExists "$D\006__$OldSoftware\$OldScripts" "$D\006__$OldSoftware\$FolderScripts"
            Rename-IfExists "$D\006__$OldSoftware" "$D\006__$FolderSoftware"

            Rename-IfExists "$D\007__$OldWork\$OldInvoices" "$D\007__$OldWork\$FolderInvoices"
            Rename-IfExists "$D\007__$OldWork\$OldContracts" "$D\007__$OldWork\$FolderContracts"
            Rename-IfExists "$D\007__$OldWork\$OldQuotes" "$D\007__$OldWork\$FolderQuotes"
            Rename-IfExists "$D\007__$OldWork\$OldOtherDocs" "$D\007__$OldWork\$FolderOtherDocs"
            Rename-IfExists "$D\007__$OldWork" "$D\007__$FolderWork"

            Rename-IfExists "$D\008__$OldTemporary" "$D\008__$FolderTemporary"

            Write-Host ""
            Write-Host "✅ Migrazione cartelle completata!" -ForegroundColor Green
        } else {
            Write-Host "⏭️  Migrazione cartelle saltata." -ForegroundColor Yellow
        }
    }
}

# Test esecuzione
Write-Host ""
Write-Host "🧪 Test esecuzione dello script..." -ForegroundColor Green
Write-Host ""

# Imposta execution policy temporaneamente
$currentPolicy = Get-ExecutionPolicy -Scope CurrentUser
if ($currentPolicy -eq "Restricted" -or $currentPolicy -eq "AllSigned") {
    Write-Host "⚙️  Impostazione Execution Policy per CurrentUser..." -ForegroundColor Yellow
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
}

# Esegui lo script
& $ScriptPath

Write-Host ""

# Configurazione Task Scheduler
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Configurazione Task Scheduler                             ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if ($isAdmin) {
    Write-Host "Configurazione automatica del task schedulato..." -ForegroundColor Green

    # Chiedi conferma
    $confirm = Read-Host "Vuoi configurare l'esecuzione automatica ogni 3 ore? (s/n)"

    if ($confirm -eq 's' -or $confirm -eq 'S' -or $confirm -eq 'y' -or $confirm -eq 'Y') {
        try {
            # Crea l'azione
            $action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
                -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""

            # Crea il trigger (ogni 3 ore)
            $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 3)

            # Crea le impostazioni
            $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

            # Crea il principal (esegui come utente corrente)
            $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType S4U

            # Registra il task
            $taskName = "OrganizeDownloads"

            # Rimuovi task esistente se presente
            $existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
            if ($existingTask) {
                Write-Host "⚠️  Task esistente trovato. Rimozione..." -ForegroundColor Yellow
                Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
            }

            # Registra il nuovo task
            Register-ScheduledTask -TaskName $taskName `
                -Action $action `
                -Trigger $trigger `
                -Settings $settings `
                -Principal $principal `
                -Description "Organizza automaticamente la cartella Download ogni 3 ore" | Out-Null

            Write-Host "✅ Task Scheduler configurato con successo!" -ForegroundColor Green
            Write-Host ""
            Write-Host "📋 Dettagli task:" -ForegroundColor Cyan
            Write-Host "   Nome: $taskName" -ForegroundColor White
            Write-Host "   Frequenza: Ogni 3 ore" -ForegroundColor White
            Write-Host "   Utente: $env:USERNAME" -ForegroundColor White
            Write-Host ""

            # Mostra il task
            Get-ScheduledTask -TaskName $taskName | Format-List TaskName, State, LastRunTime, NextRunTime

        } catch {
            Write-Host "❌ Errore nella configurazione del Task Scheduler: $_" -ForegroundColor Red
            Write-Host "   Puoi configurarlo manualmente seguendo le istruzioni sotto." -ForegroundColor Yellow
        }
    } else {
        Write-Host "⏭️  Configurazione Task Scheduler saltata." -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️  Configurazione manuale necessaria (richiede privilegi amministratore)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Per configurare manualmente il Task Scheduler:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1️⃣  Apri Task Scheduler (taskschd.msc)" -ForegroundColor White
    Write-Host "2️⃣  Crea nuova attività di base..." -ForegroundColor White
    Write-Host "3️⃣  Nome: OrganizeDownloads" -ForegroundColor White
    Write-Host "4️⃣  Trigger: Giornaliero, ripeti ogni 3 ore" -ForegroundColor White
    Write-Host "5️⃣  Azione: Avvia un programma" -ForegroundColor White
    Write-Host "     Programma: PowerShell.exe" -ForegroundColor White
    Write-Host "     Argomenti: -NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`"" -ForegroundColor White
    Write-Host ""
}

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Comandi Utili                                             ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 Esegui manualmente:" -ForegroundColor Green
Write-Host "   $ScriptPath" -ForegroundColor White
Write-Host ""
Write-Host "📊 Vedi i log:" -ForegroundColor Green
Write-Host "   Get-Content `$env:USERPROFILE\.download_organizer.log -Tail 50" -ForegroundColor White
Write-Host ""
Write-Host "⚙️  Apri Task Scheduler:" -ForegroundColor Green
Write-Host "   taskschd.msc" -ForegroundColor White
Write-Host ""
Write-Host "📋 Visualizza task attivi:" -ForegroundColor Green
Write-Host "   Get-ScheduledTask -TaskName OrganizeDownloads" -ForegroundColor White
Write-Host ""
Write-Host "▶️  Avvia task manualmente:" -ForegroundColor Green
Write-Host "   Start-ScheduledTask -TaskName OrganizeDownloads" -ForegroundColor White
Write-Host ""
Write-Host "🗑️  Rimuovi task:" -ForegroundColor Green
Write-Host "   Unregister-ScheduledTask -TaskName OrganizeDownloads -Confirm:`$false" -ForegroundColor White
Write-Host ""
Write-Host "🌍 Cambia lingua:" -ForegroundColor Green
Write-Host "   Riesegui .\Install-Windows.ps1 e scegli una nuova lingua" -ForegroundColor White
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Alternative di Frequenza                                  ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "Per modificare la frequenza, cambia il trigger nel Task Scheduler:" -ForegroundColor Yellow
Write-Host ""
Write-Host "Ogni ora:        RepetitionInterval = 1 ora" -ForegroundColor White
Write-Host "Ogni 2 ore:      RepetitionInterval = 2 ore" -ForegroundColor White
Write-Host "Ogni 6 ore:      RepetitionInterval = 6 ore" -ForegroundColor White
Write-Host "Una volta al giorno: Rimuovi RepetitionInterval" -ForegroundColor White
Write-Host "All'avvio:       Aggiungi trigger 'All'avvio'" -ForegroundColor White
Write-Host ""
Write-Host "✨ Installazione completata!" -ForegroundColor Green
Write-Host ""

# Crea un file batch per esecuzione rapida (opzionale)
$batchPath = Join-Path $InstallDir "Organize-Downloads.bat"
$batchContent = "@echo off
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`"
pause"

$batchContent | Out-File -FilePath $batchPath -Encoding ASCII

Write-Host "💡 BONUS: Creato anche file batch per esecuzione rapida:" -ForegroundColor Cyan
Write-Host "   $batchPath" -ForegroundColor White
Write-Host "   (Puoi fare doppio clic su questo file per eseguire lo script)" -ForegroundColor White
Write-Host ""
