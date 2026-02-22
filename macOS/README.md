# Download Organizer per macOS

Organizzatore automatico della cartella Download per macOS.
Lo script gira in background ogni 3 ore e ordina i file scaricati in sottocartelle organizzate per tipo, senza bisogno di intervento manuale.

---

## Cosa fa

Ogni volta che lo script si attiva (ogni 3 ore), esegue queste operazioni:

1. **Prende i nuovi file** dalla cartella Download e li mette in `001__Recenti/Oggi/`
2. **Sposta i file vecchi di 1 giorno** da `Oggi/` a `Questa-Settimana/`
3. **Dopo 7 giorni**, li smista automaticamente nella cartella giusta in base al tipo (PDF, immagini, video, ecc.)
4. **Elimina i file sconosciuti** rimasti in `008__Temporaneo/` da oltre 30 giorni

In pratica: hai 7 giorni per trovare i file recenti nella cartella `001__Recenti/`, poi vengono archiviati automaticamente.

### Struttura delle cartelle

Dopo l'installazione, la tua cartella Download apparirà così:

```
Downloads/
├── 001__Recenti/
│   ├── Oggi/                    ← file scaricati nelle ultime 24 ore
│   └── Questa-Settimana/        ← file da 1 a 7 giorni
│
├── 002__Dati/
│   ├── CSV/                     ← .csv, .tsv
│   ├── Excel/                   ← .xlsx, .xls, .ods
│   ├── JSON/                    ← .jsonl, .ndjson
│   ├── Database/                ← .sql, .db, .sqlite
│   ├── Parquet/                 ← .parquet, .feather, .arrow
│   └── Altri-Formati/           ← .xml, .avro, .hdf5
│
├── 003__Documenti/
│   ├── PDF/                     ← .pdf
│   ├── Word/                    ← .doc, .docx, .odt
│   ├── Presentazioni/           ← .ppt, .pptx, .odp, .key
│   ├── Testo/                   ← .txt, .md
│   └── Ebook/                   ← .epub, .mobi
│
├── 004__Media/
│   ├── Immagini/                ← .jpg, .png, .gif, .svg, .webp, .heic
│   ├── Video/                   ← .mp4, .avi, .mkv, .mov
│   ├── Audio/                   ← .mp3, .wav, .flac, .ogg
│   └── Diagrammi/               ← .drawio, .puml
│
├── 005__Sviluppo/
│   ├── Codice/                  ← .py, .js, .ts, .swift, .java, .cpp
│   ├── Notebooks/               ← .ipynb
│   ├── Config/                  ← .json, .yaml, .toml, .env
│   ├── Repository/              ← .zip/.tar.gz con nomi tipo "v1.0", "main"
│   └── Package/                 ← .whl, .gem, .jar
│
├── 006__Software/
│   ├── Installatori/            ← .dmg, .pkg, .app
│   ├── Archivi/                 ← .zip, .rar, .7z, .tar.gz
│   ├── Docker/                  ← Dockerfile, docker-compose.yml
│   └── Scripts/                 ← .sh, .zsh, .command
│
├── 007__Lavoro/
│   ├── Fatture/                 ← file con "fattura" o "invoice" nel nome
│   ├── Contratti/               ← file con "contratto" o "contract" nel nome
│   ├── Preventivi/              ← file con "preventivo" o "quote" nel nome
│   └── Altri-Documenti/
│
└── 008__Temporaneo/             ← file con estensione sconosciuta
                                    (eliminati automaticamente dopo 30 giorni)
```

Le cartelle sono numerate (`001__`, `002__`, ecc.) per apparire sempre nello stesso ordine nel Finder.

---

## Guida all'installazione passo passo

### Requisiti

- Un Mac con macOS 10.15 Catalina o successivo
- Sapere aprire il Terminale (spiegato al Passo 3)

### Passo 1: Scopri il nome della tua cartella Download

Su macOS la cartella si chiama quasi sempre `Downloads` e si trova in:

```
/Users/TUONOME/Downloads
```

Per verificare, apri il Finder e guarda nella barra laterale: la cartella "Download" corrisponde alla cartella `Downloads` nel sistema.

Se hai cambiato la lingua del Mac in italiano, la cartella potrebbe apparire come "Download" nel Finder, ma il suo nome reale nel sistema resta `Downloads`.

**Nella maggior parte dei casi non devi cambiare nulla**: il percorso predefinito `Downloads` è già corretto.

### Passo 2: Scarica i file

Copia i due file (`organize_downloads.sh` e `install.sh`) in una cartella a tua scelta.

Se li hai ricevuti come archivio `.zip`, fai doppio click per estrarre.

### Passo 3: Apri il Terminale

1. Apri il **Finder**
2. Vai in **Applicazioni** > **Utility**
3. Fai doppio click su **Terminale**

Oppure, metodo rapido:
1. Premi `Cmd + Spazio` (apre Spotlight)
2. Scrivi `Terminale` e premi Invio

Si aprirà una finestra con del testo. Questo è il terminale.

### Passo 4: Lancia l'installazione

1. Nella finestra del Terminale, spostati nella cartella dove hai messo i file. Digita il percorso corretto e premi Invio.

   Per esempio, se hai messo i file in Download:

   ```bash
   cd ~/Downloads
   ```

   Oppure, se li hai messi in una cartella specifica:

   ```bash
   cd ~/Documents/download_organizer/macOS
   ```

2. Rendi i file eseguibili:

   ```bash
   chmod +x organize_downloads.sh install.sh
   ```

3. Avvia l'installazione:

   ```bash
   ./install.sh
   ```

   **Se compare un errore** tipo "Operation not permitted", vedi la sezione "Permessi macOS" più avanti.

4. Lo script farà queste cose in automatico:
   - Copia il programma nella cartella `~/.local/bin/`
   - Aggiunge la cartella al PATH (se necessario)
   - Fa un primo test di funzionamento
   - Ti chiede: **"Vuoi che io configuri il cron job automaticamente?"**

5. **Rispondi `s`** e premi Invio per attivare l'esecuzione automatica ogni 3 ore.

Se tutto è andato bene, vedrai: `Installazione completata!`

### Passo 5: Configura i permessi macOS (importante!)

macOS ha un sistema di sicurezza che potrebbe impedire allo script di accedere alla cartella Download quando gira in automatico. Per risolvere:

1. Apri **Impostazioni di Sistema** (l'icona dell'ingranaggio)
2. Vai in **Privacy e Sicurezza** > **Accesso completo al disco**
3. Clicca il lucchetto in basso a sinistra e inserisci la password
4. Clicca il pulsante **+** per aggiungere un programma
5. Premi `Cmd + Shift + G` e scrivi `/usr/sbin/cron`, poi premi Invio
6. Seleziona `cron` e clicca "Apri"
7. Assicurati che la spunta accanto a `cron` sia attiva

Questo permette al sistema cron (che esegue lo script ogni 3 ore) di accedere alla cartella Download.

### Passo 6: Verifica che tutto funzioni

Apri il Terminale e digita:

```bash
crontab -l
```

Dovresti vedere una riga simile a questa:

```
0 */3 * * * /Users/TUONOME/.local/bin/organize_downloads.sh >> /Users/TUONOME/.download_organizer.log 2>&1
```

(Al posto di `TUONOME` ci sarà il tuo nome utente.)

Poi apri la cartella Download nel Finder: dovresti vedere le nuove sottocartelle numerate (`001__Recenti`, `002__Dati`, ecc.).

**Fatto!** Da questo momento lo script girerà automaticamente ogni 3 ore. Non devi fare altro.

---

## Come usarlo dopo l'installazione

### Uso normale

Non devi fare niente! Lo script lavora da solo in background. Continua a scaricare file come fai sempre: verranno organizzati automaticamente.

I file appena scaricati li trovi sempre in: `001__Recenti/Oggi/`

### Eseguire lo script manualmente

Se vuoi organizzare subito i file senza aspettare le 3 ore:

```bash
~/.local/bin/organize_downloads.sh
```

### Fare un test senza spostare nulla

Se vuoi vedere cosa farebbe lo script senza toccare i file:

1. Apri il Terminale e digita:
   ```bash
   nano ~/.local/bin/organize_downloads.sh
   ```
2. Cerca la riga `DRY_RUN=false` e cambiala in `DRY_RUN=true`
3. Salva (`Ctrl+O`, poi `Invio`, poi `Ctrl+X` per uscire)
4. Esegui lo script: vedrai cosa sposterebbe, senza spostare nulla
5. **Ricordati di rimettere `DRY_RUN=false`** quando hai finito il test

### Vedere cosa ha fatto lo script

Per controllare il registro delle operazioni:

```bash
tail -n 50 ~/.download_organizer.log
```

Questo mostra le ultime 50 righe del log, dove sono elencati tutti i file spostati.

---

## Disattivazione e rimozione

### Disattivare temporaneamente

Se vuoi mettere in pausa lo script senza rimuoverlo:

1. Apri il Terminale e digita:
   ```bash
   crontab -e
   ```
2. Si apre un editor di testo. Cerca la riga che contiene `organize_downloads.sh`
3. Aggiungi il simbolo `#` all'inizio della riga (senza spazi prima):
   ```
   #0 */3 * * * /Users/TUONOME/.local/bin/organize_downloads.sh >> ...
   ```
4. Salva e chiudi. Lo script non girerà più fino a quando non rimuovi il `#`.

### Riattivare

Stessa procedura: apri `crontab -e`, togli il `#` dalla riga, salva e chiudi.

### Rimuovere completamente

1. Rimuovi il cron job:
   ```bash
   crontab -e
   ```
   Cancella la riga con `organize_downloads.sh`, salva e chiudi.

2. Cancella lo script installato:
   ```bash
   rm ~/.local/bin/organize_downloads.sh
   ```

3. (Opzionale) Cancella il file di log:
   ```bash
   rm ~/.download_organizer.log
   ```

Le cartelle create nella cartella Download restano: puoi riorganizzarle come preferisci.

---

## Risoluzione problemi

### Errore "Operation not permitted"

macOS blocca l'accesso alla cartella Download per motivi di sicurezza. Segui il Passo 5 dell'installazione per concedere l'accesso completo al disco a `cron`.

Se l'errore appare quando esegui lo script manualmente dal Terminale:
1. Vai in **Impostazioni di Sistema** > **Privacy e Sicurezza** > **Accesso completo al disco**
2. Aggiungi **Terminale** (Terminal.app) alla lista

### Lo script non parte automaticamente

1. Verifica che il cron job sia attivo:
   ```bash
   crontab -l
   ```
   Se non vedi nessuna riga con `organize_downloads.sh`, ripeti il Passo 4 dell'installazione.

2. Verifica i permessi del file:
   ```bash
   ls -la ~/.local/bin/organize_downloads.sh
   ```
   Deve mostrare `rwx` (eseguibile). Se non lo è, esegui:
   ```bash
   chmod +x ~/.local/bin/organize_downloads.sh
   ```

3. Verifica che `cron` abbia l'Accesso completo al disco (Passo 5).

### I file non vengono spostati

1. Controlla il log per capire cosa succede:
   ```bash
   tail -n 50 ~/.download_organizer.log
   ```

2. Verifica che il percorso nello script sia corretto:
   ```bash
   head -15 ~/.local/bin/organize_downloads.sh
   ```
   Controlla la riga `DOWNLOAD_DIR=` e assicurati che corrisponda al nome reale della tua cartella.

### I file duplicati

Se scarichi un file con lo stesso nome di uno già presente, lo script aggiunge un numero progressivo:
- `documento.pdf` (già esistente) → il nuovo diventa `documento_1.pdf`

Nessun file viene mai sovrascritto.

---

## Domande frequenti

**I file vengono cancellati?**
No. I file vengono solo spostati in sottocartelle. L'unica eccezione è la cartella `008__Temporaneo/`: i file con estensione sconosciuta che restano lì per oltre 30 giorni vengono eliminati.

**Posso spostare i file manualmente tra le cartelle?**
Sì, puoi spostare file come preferisci. Lo script non tocca i file che sono già dentro le sottocartelle.

**Lo script rallenta il Mac?**
No. Gira per pochi secondi ogni 3 ore e non consuma risorse.

**Funziona se il Mac è in stop o spento?**
No. Lo script gira solo quando il Mac è acceso e non in stop. Quando lo riaccendi, si attiverà alla prossima ora prevista (ogni 3 ore: alle 0, 3, 6, 9, 12, 15, 18, 21).

**Posso cambiare la frequenza?**
Sì. Apri `crontab -e` e modifica la riga. Alcuni esempi:
- Ogni ora: `0 * * * *`
- Ogni 6 ore: `0 */6 * * *`
- Una volta al giorno a mezzanotte: `0 0 * * *`

**I download in corso vengono toccati?**
No. I file con estensione `.part`, `.crdownload` o `.download` (download non completati) vengono ignorati.

**Devo tenere il Terminale aperto?**
No. Il cron job gira in background indipendentemente dal Terminale. Una volta configurato, puoi chiudere il Terminale.

---

## Contenuto della cartella

| File | Descrizione |
|------|-------------|
| `organize_downloads.sh` | Lo script principale che organizza i file |
| `install.sh` | Lo script di installazione (da eseguire una sola volta) |
| `README.md` | Questa guida |

