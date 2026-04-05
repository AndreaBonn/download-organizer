**🇬🇧 [English](SECURITY.md) | 🇮🇹 [Italiano](SECURITY.it.md) | 📄 [License](LICENSE.md)**

---

# Politica di Sicurezza

## Panoramica

Download Organizer è progettato con sicurezza e privacy come principi fondamentali. Gli script vengono eseguiti interamente in locale sulla tua macchina, senza connessioni esterne, raccolta dati o servizi cloud.

---

## Caratteristiche di Sicurezza

### 1. Esecuzione Solo Locale

- **Nessuna connessione di rete**: Gli script non si connettono mai a internet o servizi esterni
- **Nessuna trasmissione dati**: I tuoi file e metadati non lasciano mai il tuo computer
- **Nessuna telemetria**: Non vengono raccolte statistiche d'uso o analytics
- **Nessuna dipendenza esterna**: Gli script usano solo comandi di sistema integrati

### 2. Sicurezza dei File

- **Nessuna eliminazione di file** (eccetto cartella temporanea dopo 30 giorni)
- **Protezione duplicati**: I file con lo stesso nome ricevono un suffisso numerico invece di essere sovrascritti
- **Download in corso ignorati**: I file `.part`, `.crdownload` e `.download` non vengono mai toccati
- **Operazioni di sola lettura**: Gli script leggono solo i metadati dei file (nome, estensione, data di modifica)
- **Nessuna ispezione del contenuto**: Gli script non aprono mai né leggono il contenuto dei tuoi file

### 3. Modello dei Permessi

#### Linux
- Gli script vengono eseguiti con **permessi a livello utente** solamente
- Non è richiesto `sudo` o accesso root
- Il cron job viene eseguito con il tuo account utente
- Gli script non possono accedere a file fuori dalla tua home directory senza permesso esplicito

#### macOS
- Gli script vengono eseguiti con **permessi a livello utente** solamente
- Non sono richiesti privilegi di amministratore
- Richiede **Accesso completo al disco** per cron (requisito di sicurezza standard di macOS)
- Questo permesso viene richiesto esplicitamente durante l'installazione e può essere revocato in qualsiasi momento

#### Windows
- Gli script vengono eseguiti con **permessi dell'utente corrente** solamente
- Non sono richiesti diritti di amministratore
- L'Utilità di pianificazione viene eseguita con il tuo account utente
- La policy di esecuzione di PowerShell potrebbe richiedere un aggiustamento (documentato nella guida di installazione)

### 4. Trasparenza del Codice

- **Open source**: Tutto il codice è pubblicamente disponibile per l'ispezione
- **Nessuna offuscazione**: Gli script sono scritti in testo semplice con commenti
- **Nessun binario compilato**: Tutto viene eseguito come script interpretati
- **Verificabile**: Puoi rivedere ogni riga prima dell'installazione

### 5. Sicurezza dell'Installazione

- **Installazione manuale**: Controlli ogni passaggio del processo
- **Nessun download automatico**: Scarichi i file direttamente da GitHub
- **Nessun eseguibile di installazione**: L'installazione usa script shell (Linux/macOS) o script PowerShell (Windows)
- **Modalità test**: Testa il comportamento dello script senza spostare file (`DRY_RUN=true`)

### 6. Logging e Monitoraggio

- **Log dettagliati**: Ogni operazione viene registrata in `~/.download_organizer.log`
- **Operazioni trasparenti**: Puoi vedere esattamente cosa fa lo script
- **Nessun dato sensibile nei log**: I log contengono solo nomi di file e timestamp
- **Archiviazione locale dei log**: I log non lasciano mai la tua macchina

### 7. Sicurezza della Migrazione Cartelle

- **Rinominazione automatica**: Quando cambi lingua, le cartelle esistenti vengono rinominate (non eliminate)
- **Nessuna perdita di dati**: I file rimangono al loro posto durante la migrazione delle cartelle
- **Reversibile**: Puoi cambiare lingua più volte senza perdere file

---

## Cosa gli Script NON Fanno

- ❌ Accedere a internet o servizi esterni
- ❌ Raccogliere o trasmettere dati personali
- ❌ Modificare il contenuto dei file
- ❌ Accedere a file fuori dalla cartella Download
- ❌ Richiedere privilegi di amministratore/root
- ❌ Installare software o dipendenze aggiuntive
- ❌ Creare backdoor o processi persistenti (solo task pianificati)
- ❌ Accedere a file di sistema o configurazioni (eccetto cron/Utilità di pianificazione per l'automazione)

---

## Rischi Potenziali e Mitigazioni

### Rischio: Spostamento Accidentale di File

**Scenario**: Un file potrebbe essere spostato in una categoria inaspettata

**Mitigazione**:
- Usa prima la modalità test (`DRY_RUN=true` negli script)
- Controlla il file di log per vedere cosa è stato spostato
- I file non vengono mai eliminati (eccetto dalla cartella temporanea dopo 30 giorni)
- Puoi spostare manualmente i file indietro in qualsiasi momento

### Rischio: Eliminazione Automatica Cartella Temporanea

**Scenario**: I tipi di file sconosciuti in `008__Temporaneo/` vengono eliminati dopo 30 giorni

**Mitigazione**:
- Periodo di grazia di 30 giorni per rivedere e spostare file importanti
- Messaggi di avviso nei log prima dell'eliminazione
- Interessa solo file con estensioni non riconosciute
- Puoi disabilitare l'eliminazione automatica modificando lo script

### Rischio: Modifica dello Script

**Scenario**: Qualcuno potrebbe modificare gli script per aggiungere codice malevolo

**Mitigazione**:
- Scarica solo dal repository GitHub ufficiale
- Verifica l'integrità dei file rivedendo il codice prima dell'esecuzione
- Gli script sono abbastanza semplici da verificare manualmente
- Nessun aggiornamento automatico (controlli tu quando aggiornare)

### Rischio: Escalation dei Permessi

**Scenario**: Gli script potrebbero essere modificati per richiedere privilegi elevati

**Mitigazione**:
- Gli script esplicitamente non richiedono accesso root/admin
- Le guide di installazione avvisano di non eseguire con privilegi elevati
- Cron/Utilità di pianificazione viene eseguito solo con account utente

---

## Best Practice

### Prima dell'Installazione

1. **Rivedi il codice**: Leggi gli script per capire cosa fanno
2. **Testa in modalità test**: Imposta `DRY_RUN=true` per vedere le operazioni senza spostare file
3. **Backup dei file importanti**: Fai un backup della cartella Download prima della prima esecuzione
4. **Controlla i permessi**: Assicurati che gli script vengano eseguiti solo con permessi a livello utente

### Dopo l'Installazione

1. **Monitora il file di log**: Controlla periodicamente `~/.download_organizer.log`
2. **Rivedi i file organizzati**: Verifica che i file siano categorizzati correttamente
3. **Controlla la cartella temporanea**: Rivedi `008__Temporaneo/` prima dell'eliminazione a 30 giorni
4. **Mantieni gli script aggiornati**: Controlla GitHub per aggiornamenti di sicurezza (nessun aggiornamento automatico)

### Disinstallazione

Se vuoi rimuovere l'organizzatore:

**Linux/macOS**:
```bash
# Rimuovi il cron job
crontab -l | grep -v "organize_downloads.sh" | crontab -

# Rimuovi gli script (opzionale)
rm -rf ~/.local/share/download_organizer

# Rimuovi il file di log (opzionale)
rm ~/.download_organizer.log
```

**Windows**:
```powershell
# Rimuovi il task pianificato
Unregister-ScheduledTask -TaskName "OrganizeDownloads" -Confirm:$false

# Rimuovi gli script (opzionale)
Remove-Item -Recurse -Force "$env:USERPROFILE\Scripts\download_organizer"

# Rimuovi il file di log (opzionale)
Remove-Item "$env:USERPROFILE\.download_organizer.log"
```

---

## Segnalazione di Problemi di Sicurezza

Se scopri una vulnerabilità di sicurezza, segnalala in modo responsabile:

1. **Non** aprire una issue pubblica su GitHub
2. Contatta il maintainer privatamente (vedi repository per informazioni di contatto)
3. Fornisci informazioni dettagliate sulla vulnerabilità
4. Concedi un tempo ragionevole per una correzione prima della divulgazione pubblica

---

## Checklist di Sicurezza

Prima di eseguire gli script, verifica:

- [ ] Scaricato dal repository GitHub ufficiale
- [ ] Rivisto il codice dello script
- [ ] Testato in modalità test
- [ ] Non sono richiesti privilegi `sudo` o amministratore
- [ ] Gli script accedono solo alla cartella Download
- [ ] Nessuna connessione di rete nel codice
- [ ] La posizione del file di log è nella tua home directory
- [ ] Cron/Utilità di pianificazione viene eseguito con il tuo account utente

---

## Aggiornamenti e Manutenzione

- **Nessun aggiornamento automatico**: Controlli tu quando aggiornare
- **Controlla GitHub**: Visita il repository per nuove versioni
- **Rivedi i changelog**: Leggi cosa è cambiato prima di aggiornare
- **Patch di sicurezza**: Le correzioni di sicurezza critiche saranno chiaramente contrassegnate

---

## Dichiarazione sulla Privacy

Download Organizer:
- Non raccoglie alcuna informazione personale
- Non trasmette alcun dato sulla rete
- Non usa cookie, tracker o analytics
- Non richiede registrazione o account
- Opera interamente offline sulla tua macchina locale

I tuoi file, nomi di file e pattern di utilizzo rimangono completamente privati e non lasciano mai il tuo computer.

---

## Licenza

Questo progetto è rilasciato sotto licenza MIT. Vedi [LICENSE.md](LICENSE.md) per i dettagli.

---

**Ultimo Aggiornamento**: 2024-01-09
