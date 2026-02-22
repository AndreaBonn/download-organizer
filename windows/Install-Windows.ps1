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
    if ($continue -ne 's' -and $continue -ne 'S') {
        exit
    }
}

# Definisci i percorsi
$ScriptName = "Organize-Downloads.ps1"
$InstallDir = "$env:USERPROFILE\Scripts"
$ScriptPath = Join-Path $InstallDir $ScriptName

# Crea la directory se non esiste
if (-not (Test-Path $InstallDir)) {
    Write-Host "📁 Creazione directory $InstallDir..." -ForegroundColor Green
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

# Copia lo script nella directory
Write-Host "📋 Copia dello script in $InstallDir..." -ForegroundColor Green
Copy-Item -Path $ScriptName -Destination $ScriptPath -Force

Write-Host ""
Write-Host "✅ Script installato con successo in: $ScriptPath" -ForegroundColor Green
Write-Host ""

# Test esecuzione
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
    
    if ($confirm -eq 's' -or $confirm -eq 'S') {
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
