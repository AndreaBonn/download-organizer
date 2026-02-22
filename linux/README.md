**🇮🇹 [Italiano](README.md) | 🇬🇧 [English](README.en.md)**

---

# Download Organizer per Linux

Organizzatore automatico della cartella Scaricati (o Download) per sistemi Linux.
Lo script gira in background ogni 3 ore e ordina i file scaricati in sottocartelle organizzate per tipo, senza bisogno di intervento manuale.

---

## Cosa fa

Ogni volta che lo script si attiva (ogni 3 ore), esegue queste operazioni:

1. **Prende i nuovi file** dalla cartella Scaricati e li mette in `001__Recenti/Oggi/`
2. **Sposta i file vecchi di 1 giorno** da `Oggi/` a `Questa-Settimana/`
3. **Dopo 7 giorni**, li smista automaticamente nella cartella giusta in base al tipo (PDF, immagini, video, ecc.)
4. **Elimina i file sconosciuti** rimasti in `008__Temporaneo/` da oltre 30 giorni

In pratica: hai 7 giorni per trovare i file recenti nella cartella `001__Recenti/`, poi vengono archiviati automaticamente.

### Struttura delle cartelle

Dopo l'installazione, la tua cartella Scaricati apparirà così:

```
Scaricati/
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
│   ├── Presentazioni/           ← .ppt, .pptx, .odp
│   ├── Testo/                   ← .txt, .md
│   └── Ebook/                   ← .epub, .mobi
│
├── 004__Media/
│   ├── Immagini/                ← .jpg, .png, .gif, .svg, .webp
│   ├── Video/                   ← .mp4, .avi, .mkv, .mov
│   ├── Audio/                   ← .mp3, .wav, .flac, .ogg
│   └── Diagrammi/               ← .drawio, .puml
│
├── 005__Sviluppo/
│   ├── Codice/                  ← .py, .js, .ts, .java, .cpp
│   ├── Notebooks/               ← .ipynb
│   ├── Config/                  ← .json, .yaml, .toml, .env
│   ├── Repository/              ← .zip/.tar.gz con nomi tipo "v1.0", "main"
│   └── Package/                 ← .whl, .deb, .rpm, .jar
│
├── 006__Software/
│   ├── Installatori/            ← .appimage, .deb, .snap, .flatpak
│   ├── Archivi/                 ← .zip, .rar, .7z, .tar.gz
│   ├── Docker/                  ← Dockerfile, docker-compose.yml
│   └── Scripts/                 ← .sh, .bat, .ps1
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

Le cartelle sono numerate (`001__`, `002__`, ecc.) per apparire sempre nello stesso ordine nel file manager.

---

## Guida all'installazione passo passo

### Requisiti

- Un computer con sistema operativo Linux (Ubuntu, Fedora, Debian, Mint, ecc.)
- Sapere aprire il Terminale (si trova tra le applicazioni, oppure si apre con `Ctrl+Alt+T`)

### Passo 1: Scopri il nome della tua cartella Scaricati

La cartella dove finiscono i file scaricati da internet ha nomi diversi a seconda della lingua del sistema:

- **Italiano**: `Scaricati`
- **Inglese**: `Downloads`
- **Altre lingue**: potrebbe avere un nome diverso

Per scoprire qual è la tua, apri il Terminale e digita:

```bash
ls ~/
```

Premi Invio. Vedrai una lista di cartelle. Cerca quella che usi per i download (es. `Scaricati`, `Downloads`, `Download`).

**Segna il nome esatto** perché ti servirà al Passo 3.

### Passo 2: Scarica i file

Copia i due file (`organize_downloads.sh` e `install.sh`) in una cartella a tua scelta.

Se li hai ricevuti come archivio `.zip`, estraili prima.

### Passo 3: Modifica il percorso della cartella Scaricati

Questo è l'unico passaggio che richiede una modifica manuale.

1. Apri il file `organize_downloads.sh` con un editor di testo (va bene anche il Text Editor di sistema: click destro sul file > "Apri con Editor di testo")

2. Cerca questa riga vicino all'inizio del file (riga 12):

   ```
   DOWNLOAD_DIR="$HOME/Download"
   ```

3. Sostituisci `Download` con il nome della **tua** cartella scaricati. Esempi:

   - Se la tua cartella si chiama **Scaricati**:
     ```
     DOWNLOAD_DIR="$HOME/Scaricati"
     ```
   - Se si chiama **Downloads**:
     ```
     DOWNLOAD_DIR="$HOME/Downloads"
     ```

4. Salva il file e chiudi l'editor.

**Attenzione**: rispetta maiuscole e minuscole. `Scaricati` e `scaricati` sono due cose diverse per Linux.

### Passo 4: Lancia l'installazione

1. Apri il Terminale (`Ctrl+Alt+T`)

2. Spostati nella cartella dove hai messo i file. Per esempio, se li hai messi in `Scaricati`:

   ```bash
   cd ~/Scaricati
   ```

   Oppure, se li hai messi in una cartella specifica:

   ```bash
   cd ~/Documenti/download_organizer/linux
   ```

3. Rendi i file eseguibili:

   ```bash
   chmod +x organize_downloads.sh install.sh
   ```

4. Avvia l'installazione:

   ```bash
   ./install.sh
   ```

5. **Scegli la lingua**: lo script ti chiederà in quale lingua vuoi i nomi delle cartelle.
   Le opzioni sono: Italiano, English, Español, Français, Deutsch, Português.
   Premi il numero corrispondente e poi Invio. Se non scegli nulla, sarà Italiano.

6. Lo script farà queste cose in automatico:
   - Copia il programma nella cartella giusta del sistema (`~/.local/bin/`)
   - Copia i file di lingua in `~/.local/share/download_organizer/lang/`
   - Se rileva cartelle esistenti in un'altra lingua, ti chiede se vuoi rinominarle
   - Fa un primo test di funzionamento
   - Ti chiede: **"Vuoi che io configuri il cron job automaticamente?"**

7. **Rispondi `s`** (e premi Invio) per attivare l'esecuzione automatica ogni 3 ore.

Se tutto è andato bene, vedrai il messaggio: `Installazione completata!`

### Passo 5: Verifica che tutto funzioni

Apri il Terminale e digita:

```bash
crontab -l
```

Dovresti vedere una riga simile a questa:

```
0 */3 * * * /home/TUONOME/.local/bin/organize_downloads.sh >> /home/TUONOME/.download_organizer.log 2>&1
```

(Al posto di `TUONOME` ci sarà il tuo nome utente.)

Poi apri la tua cartella Scaricati: dovresti vedere le nuove sottocartelle numerate (`001__Recenti`, `002__Dati`, ecc.).

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

1. Apri il file dello script installato:
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

1. Apri il terminale e digita:
   ```bash
   crontab -e
   ```
2. Si apre un editor di testo. Cerca la riga che contiene `organize_downloads.sh`
3. Aggiungi il simbolo `#` all'inizio della riga (senza spazi prima):
   ```
   #0 */3 * * * /home/TUONOME/.local/bin/organize_downloads.sh >> ...
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

Le cartelle create nella cartella Scaricati restano: puoi riorganizzarle come preferisci.

---

## Risoluzione problemi

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

### I file non vengono spostati

1. Controlla il log per capire cosa succede:
   ```bash
   tail -n 50 ~/.download_organizer.log
   ```

2. Verifica che il nome della cartella nello script sia corretto:
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

**Lo script rallenta il computer?**
No. Gira per pochi secondi ogni 3 ore e non consuma risorse.

**Funziona se il computer è spento?**
No. Lo script gira solo quando il computer è acceso. Quando lo riaccendi, si attiverà alla prossima ora prevista (ogni 3 ore: alle 0, 3, 6, 9, 12, 15, 18, 21).

**Posso cambiare la frequenza?**
Sì. Apri `crontab -e` e modifica la riga. Alcuni esempi:
- Ogni ora: `0 * * * *`
- Ogni 6 ore: `0 */6 * * *`
- Una volta al giorno a mezzanotte: `0 0 * * *`

**I download in corso vengono toccati?**
No. I file con estensione `.part` o `.crdownload` (download non completati) vengono ignorati.

**Come cambio lingua dopo l'installazione?**
Riesegui `./install.sh` dalla cartella originale e scegli una nuova lingua. Lo script rileva le cartelle esistenti nella lingua precedente e ti chiede se vuoi rinominarle automaticamente.

---

## Contenuto della cartella

| File | Descrizione |
|------|-------------|
| `organize_downloads.sh` | Lo script principale che organizza i file |
| `install.sh` | Lo script di installazione (da eseguire una sola volta) |
| `lang/it.sh` ... `lang/pt.sh` | File di lingua (6 lingue supportate) |
| `README.md` | Questa guida (italiano) |
| `README.en.md` | Questa guida (inglese) |
