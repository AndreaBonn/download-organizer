**🇮🇹 [Italiano](README.md) | 🇬🇧 [English](README.en.md)**

---

# Download Organizer per Windows

Organizzatore automatico della cartella Download per sistemi Windows.
Lo script gira in background ogni 3 ore e ordina i file scaricati in sottocartelle organizzate per tipo, senza bisogno di intervento manuale.

---

## Cosa fa

Ogni volta che lo script si attiva (ogni 3 ore), esegue queste operazioni:

1. **Prende i nuovi file** dalla cartella Download e li mette in `001__Recenti\Oggi\`
2. **Sposta i file vecchi di 1 giorno** da `Oggi\` a `Questa-Settimana\`
3. **Dopo 7 giorni**, li smista automaticamente nella cartella giusta in base al tipo (PDF, immagini, video, ecc.)
4. **Elimina i file sconosciuti** rimasti in `008__Temporaneo\` da oltre 30 giorni

In pratica: hai 7 giorni per trovare i file recenti nella cartella `001__Recenti\`, poi vengono archiviati automaticamente.

### Struttura delle cartelle

Dopo l'installazione, la tua cartella Download apparirà così:

```
Download\
├── 001__Recenti\
│   ├── Oggi\                    ← file scaricati nelle ultime 24 ore
│   └── Questa-Settimana\        ← file da 1 a 7 giorni
│
├── 002__Dati\
│   ├── CSV\                     ← .csv, .tsv
│   ├── Excel\                   ← .xlsx, .xls, .ods
│   ├── JSON\                    ← .jsonl, .ndjson
│   ├── Database\                ← .sql, .db, .sqlite, .mdb, .accdb
│   ├── Parquet\                 ← .parquet, .feather, .arrow
│   └── Altri-Formati\           ← .xml, .avro, .hdf5
│
├── 003__Documenti\
│   ├── PDF\                     ← .pdf
│   ├── Word\                    ← .doc, .docx, .odt
│   ├── Presentazioni\           ← .ppt, .pptx, .odp
│   ├── Testo\                   ← .txt, .md
│   └── Ebook\                   ← .epub, .mobi
│
├── 004__Media\
│   ├── Immagini\                ← .jpg, .png, .gif, .svg, .webp
│   ├── Video\                   ← .mp4, .avi, .mkv, .mov
│   ├── Audio\                   ← .mp3, .wav, .flac, .ogg
│   └── Diagrammi\               ← .drawio, .puml
│
├── 005__Sviluppo\
│   ├── Codice\                  ← .py, .js, .ts, .java, .cpp
│   ├── Notebooks\               ← .ipynb
│   ├── Config\                  ← .json, .yaml, .toml, .env
│   ├── Repository\              ← .zip/.tar.gz con nomi tipo "v1.0", "main"
│   └── Package\                 ← .whl, .jar, .nupkg
│
├── 006__Software\
│   ├── Installatori\            ← .exe, .msi, .appx, .msix
│   ├── Archivi\                 ← .zip, .rar, .7z, .tar.gz
│   ├── Docker\                  ← Dockerfile, docker-compose.yml
│   └── Scripts\                 ← .bat, .ps1, .cmd, .vbs
│
├── 007__Lavoro\
│   ├── Fatture\                 ← file con "fattura" o "invoice" nel nome
│   ├── Contratti\               ← file con "contratto" o "contract" nel nome
│   ├── Preventivi\              ← file con "preventivo" o "quote" nel nome
│   └── Altri-Documenti\
│
└── 008__Temporaneo\             ← file con estensione sconosciuta
                                    (eliminati automaticamente dopo 30 giorni)
```

Le cartelle sono numerate (`001__`, `002__`, ecc.) per apparire sempre nello stesso ordine in Esplora File.

---

## Guida all'installazione passo passo

### Requisiti

- Un computer con Windows 10 o Windows 11
- Sapere aprire PowerShell (spiegato al Passo 3)

### Passo 1: Scopri il nome della tua cartella Download

Su Windows la cartella si chiama quasi sempre `Downloads` e si trova in:

```
C:\Users\TUONOME\Downloads
```

Per verificare:
1. Apri Esplora File (l'icona della cartella gialla nella barra delle applicazioni)
2. Nella barra di sinistra cerca "Download" o "Downloads"
3. Fai click destro sulla cartella > Proprietà > guarda il campo "Percorso"

**Segna il nome esatto** perché ti servirà al Passo 2.

### Passo 2: Modifica il percorso della cartella Download (se necessario)

Il percorso predefinito nello script è `Downloads`. Se la tua cartella ha un nome diverso, devi cambiarlo.

1. Fai click destro su `Organize-Downloads.ps1` > "Apri con" > "Blocco Note" (oppure un altro editor di testo)

2. Cerca questa riga vicino all'inizio del file (riga 11):

   ```
   $DownloadDir = "$env:USERPROFILE\Downloads"
   ```

3. Se la tua cartella si chiama diversamente, modifica solo la parte dopo l'ultimo `\`. Esempio:

   - Se si chiama **Download** (senza la s):
     ```
     $DownloadDir = "$env:USERPROFILE\Download"
     ```

4. Salva il file e chiudi l'editor.

Se la tua cartella si chiama `Downloads` (come nella maggior parte dei PC Windows), **non devi cambiare nulla** e puoi passare direttamente al Passo 3.

### Passo 3: Apri PowerShell come Amministratore

Questo passaggio è necessario per configurare l'esecuzione automatica.

**Su Windows 11:**
1. Fai click destro sul pulsante Start (l'icona di Windows in basso a sinistra)
2. Seleziona "Terminale (Amministratore)" oppure "Windows PowerShell (Amministratore)"
3. Se appare una finestra che chiede "Vuoi consentire a questa app di apportare modifiche?", clicca "Sì"

**Su Windows 10:**
1. Scrivi "PowerShell" nella barra di ricerca in basso
2. Fai click destro su "Windows PowerShell"
3. Seleziona "Esegui come amministratore"
4. Se appare una finestra che chiede "Vuoi consentire a questa app di apportare modifiche?", clicca "Sì"

Si aprirà una finestra blu/nera con del testo. Questo è il terminale PowerShell.

### Passo 4: Lancia l'installazione

1. Nella finestra PowerShell, spostati nella cartella dove hai messo i file. Digita il percorso corretto e premi Invio.

   Per esempio, se hai messo i file in Download:
   ```powershell
   cd $env:USERPROFILE\Downloads
   ```

   Oppure, se li hai messi in una cartella specifica:
   ```powershell
   cd C:\Users\TUONOME\Documenti\download_organizer\windows
   ```

2. Avvia l'installazione:

   ```powershell
   .\Install-Windows.ps1
   ```

   **Se compare un errore** del tipo "l'esecuzione di script è disattivata", digita prima questo comando e riprova:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. **Scegli la lingua**: lo script ti chiederà in quale lingua vuoi i nomi delle cartelle.
   Le opzioni sono: Italiano, English, Español, Français, Deutsch, Português.
   Premi il numero corrispondente e poi Invio. Se non scegli nulla, sarà Italiano.

4. Lo script farà queste cose in automatico:
   - Copia il programma nella cartella `C:\Users\TUONOME\Scripts\`
   - Copia i file di lingua in `C:\Users\TUONOME\Scripts\lang\`
   - Se rileva cartelle esistenti in un'altra lingua, ti chiede se vuoi rinominarle
   - Fa un primo test di funzionamento
   - Ti chiede: **"Vuoi configurare l'esecuzione automatica ogni 3 ore?"**

5. **Rispondi `s`** e premi Invio per attivare l'esecuzione automatica.

Se tutto è andato bene, vedrai: `Installazione completata!`

### Passo 5: Verifica che tutto funzioni

1. Nella finestra PowerShell, digita:

   ```powershell
   Get-ScheduledTask -TaskName "OrganizeDownloads"
   ```

   Dovresti vedere una riga con `State: Ready` (o `Pronto`).

2. Apri la tua cartella Download in Esplora File: dovresti vedere le nuove sottocartelle numerate (`001__Recenti`, `002__Dati`, ecc.).

**Fatto!** Da questo momento lo script girerà automaticamente ogni 3 ore. Non devi fare altro.

---

## Come usarlo dopo l'installazione

### Uso normale

Non devi fare niente! Lo script lavora da solo in background. Continua a scaricare file come fai sempre: verranno organizzati automaticamente.

I file appena scaricati li trovi sempre in: `001__Recenti\Oggi\`

### Eseguire lo script manualmente

Se vuoi organizzare subito i file senza aspettare le 3 ore, hai tre modi:

**Modo 1 - Doppio click** (il più semplice):
Vai in `C:\Users\TUONOME\Scripts\` e fai doppio click su `Organize-Downloads.bat`

**Modo 2 - Da PowerShell:**
```powershell
& "$env:USERPROFILE\Scripts\Organize-Downloads.ps1"
```

**Modo 3 - Dal Task Scheduler:**
```powershell
Start-ScheduledTask -TaskName "OrganizeDownloads"
```

### Fare un test senza spostare nulla

Se vuoi vedere cosa farebbe lo script senza toccare i file:

1. Apri il file installato con Blocco Note:
   - Vai in `C:\Users\TUONOME\Scripts\`
   - Click destro su `Organize-Downloads.ps1` > "Apri con" > "Blocco Note"
2. Cerca la riga `$DryRun = $false` e cambiala in `$DryRun = $true`
3. Salva e chiudi
4. Esegui lo script: vedrai cosa sposterebbe, senza spostare nulla
5. **Ricordati di rimettere `$DryRun = $false`** quando hai finito il test

### Vedere cosa ha fatto lo script

Apri PowerShell e digita:

```powershell
Get-Content "$env:USERPROFILE\.download_organizer.log" -Tail 50
```

Questo mostra le ultime 50 righe del registro, dove sono elencati tutti i file spostati.

---

## Disattivazione e rimozione

### Disattivare temporaneamente

Se vuoi mettere in pausa lo script senza rimuoverlo:

1. Apri PowerShell come Amministratore (vedi Passo 3)
2. Digita:
   ```powershell
   Disable-ScheduledTask -TaskName "OrganizeDownloads"
   ```

Lo script non girerà più fino a quando non lo riattivi.

### Riattivare

```powershell
Enable-ScheduledTask -TaskName "OrganizeDownloads"
```

### Rimuovere completamente

1. Rimuovi il task automatico (da PowerShell come Amministratore):
   ```powershell
   Unregister-ScheduledTask -TaskName "OrganizeDownloads" -Confirm:$false
   ```

2. Cancella la cartella degli script:
   - Vai in `C:\Users\TUONOME\Scripts\` e cancella i file `Organize-Downloads.ps1` e `Organize-Downloads.bat`

3. (Opzionale) Cancella il file di log:
   - Vai in `C:\Users\TUONOME\` e cancella il file `.download_organizer.log`

Le cartelle create nella cartella Download restano: puoi riorganizzarle come preferisci.

---

## Risoluzione problemi

### Errore "l'esecuzione di script è disattivata"

Questo è un blocco di sicurezza di Windows. Per risolverlo, apri PowerShell come Amministratore e digita:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Poi riprova a lanciare l'installazione.

### Lo script non parte automaticamente

1. Verifica che il task esista:
   ```powershell
   Get-ScheduledTask -TaskName "OrganizeDownloads"
   ```
   Se non esiste, ripeti il Passo 4 dell'installazione.

2. Verifica che lo stato sia "Ready" (Pronto) e non "Disabled" (Disabilitato).

3. Controlla i log del Task Scheduler:
   - Apri "Visualizzatore eventi" (cerca nella barra di ricerca di Windows)
   - Vai in: Registri di Windows > Microsoft > Windows > TaskScheduler > Operational

### I file non vengono spostati

1. Controlla il log per capire cosa succede:
   ```powershell
   Get-Content "$env:USERPROFILE\.download_organizer.log" -Tail 50
   ```

2. Verifica che il percorso nello script sia corretto:
   - Apri `C:\Users\TUONOME\Scripts\Organize-Downloads.ps1`
   - Controlla la riga `$DownloadDir =` e assicurati che corrisponda al percorso reale della tua cartella

3. Se un file è aperto in un programma, non può essere spostato. Verrà spostato alla prossima esecuzione (entro 3 ore).

### I file duplicati

Se scarichi un file con lo stesso nome di uno già presente, lo script aggiunge un numero progressivo:
- `documento.pdf` (già esistente) → il nuovo diventa `documento_1.pdf`

Nessun file viene mai sovrascritto.

---

## Domande frequenti

**I file vengono cancellati?**
No. I file vengono solo spostati in sottocartelle. L'unica eccezione è la cartella `008__Temporaneo\`: i file con estensione sconosciuta che restano lì per oltre 30 giorni vengono eliminati.

**Posso spostare i file manualmente tra le cartelle?**
Sì, puoi spostare file come preferisci. Lo script non tocca i file che sono già dentro le sottocartelle.

**Lo script rallenta il computer?**
No. Gira per pochi secondi ogni 3 ore e non consuma risorse.

**Funziona se il computer è spento o in sospensione?**
No. Lo script gira solo quando il computer è acceso. Quando lo riaccendi, se un'esecuzione è stata saltata, verrà avviata automaticamente.

**Posso cambiare la frequenza?**
Sì. Apri PowerShell come Amministratore e digita uno di questi comandi:
- Ogni ora:
  ```powershell
  $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 1)
  Set-ScheduledTask -TaskName "OrganizeDownloads" -Trigger $trigger
  ```
- Ogni 6 ore:
  ```powershell
  $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 6)
  Set-ScheduledTask -TaskName "OrganizeDownloads" -Trigger $trigger
  ```

**I download in corso vengono toccati?**
No. I file con estensione `.tmp`, `.crdownload` o `.part` (download non completati) vengono ignorati.

**Come cambio lingua dopo l'installazione?**
Riesegui `.\Install-Windows.ps1` dalla cartella originale e scegli una nuova lingua. Lo script rileva le cartelle esistenti nella lingua precedente e ti chiede se vuoi rinominarle automaticamente.

---

## Contenuto della cartella

| File | Descrizione |
|------|-------------|
| `Organize-Downloads.ps1` | Lo script principale che organizza i file |
| `Install-Windows.ps1` | Lo script di installazione (da eseguire una sola volta) |
| `lang\it.ps1` ... `lang\pt.ps1` | File di lingua (6 lingue supportate) |
| `README.md` | Questa guida (italiano) |
| `README.en.md` | Questa guida (inglese) |

