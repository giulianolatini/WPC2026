# 01 — Installazione di Visual Studio Code e LiteLLM

Questo documento descrive l'installazione degli strumenti della demo su Windows, macOS e Linux.

| Strumento | Windows | macOS | Linux Debian/Ubuntu | Linux openSUSE |
|-----------|---------|-------|---------------------|----------------|
| Visual Studio Code | `winget` | `brew` | `apt` | `zypper` |
| Docker | `winget` (Docker Desktop) | `brew` (Docker Desktop) | `apt` (Docker Engine) | `zypper` |
| uv | `winget` | `brew` | installer ufficiale ([D-009](Decisions.md#d-009)) | installer ufficiale ([D-009](Decisions.md#d-009)) |
| LiteLLM proxy | Docker o `uv tool` | Docker o `uv tool` | Docker o `uv tool` | Docker o `uv tool` |

> **Nota su YaST.** Su openSUSE usiamo `zypper`. YaST Software Management installa gli stessi pacchetti in modo grafico ([D-006](Decisions.md#d-006)).

## Indice

1. [Parametri](#1-parametri)
2. [Visual Studio Code](#2-visual-studio-code)
3. [Prerequisiti per LiteLLM: Docker e uv](#3-prerequisiti-per-litellm-docker-e-uv)
4. [Chiavi API e file `.env`](#4-chiavi-api-e-file-env)
5. [LiteLLM con Docker](#5-litellm-con-docker)
6. [LiteLLM come servizio locale con uv](#6-litellm-come-servizio-locale-con-uv)
7. [Verifica finale](#7-verifica-finale)

---

## 1. Parametri

Le procedure usano questi parametri. Registra il valore che usi: il valore serve per le evidenze.

| Parametro | Default | Descrizione |
|-----------|---------|-------------|
| `WPC_DIR` | `~/wpc2026-litellm` (Windows: `$HOME\wpc2026-litellm`) | Cartella di lavoro di LiteLLM |
| `LITELLM_PORT` | `4000` | Porta del proxy ([S-020](Sources.md#s-020)) |
| `LITELLM_IMAGE` | `ghcr.io/berriai/litellm:v1.90.2` | Immagine Docker con tag fisso ⚠️ verifica l'ultimo tag stabile ([S-023](Sources.md#s-023)) |
| `LITELLM_MASTER_KEY` | generata | Chiave root del proxy, inizia con `sk-` ([S-020](Sources.md#s-020)) |
| `LITELLM_SALT_KEY` | generata | Solo profilo esteso. Non rigenerarla ([S-020](Sources.md#s-020)) |
| `POSTGRES_PASSWORD` | generata | Solo profilo esteso |

---

## 2. Visual Studio Code

### 2.1 Windows (`winget`)

- [ ] Apri PowerShell.
- [ ] Installa VS Code ([S-012](Sources.md#s-012), [S-013](Sources.md#s-013)):

```powershell
winget install --id Microsoft.VisualStudioCode -e
```

- [ ] Chiudi e apri di nuovo il terminale.
- [ ] Verifica la versione:

```powershell
code --version
```

> Il pacchetto `winget` installa la *User setup*: non richiede privilegi di amministratore ([S-010](Sources.md#s-010)).
> Per la *System setup* (tutti gli utenti) usa il programma d'installazione dal sito ([S-010](Sources.md#s-010)). ⚠️ Lo scope `--scope machine` di `winget` per questo pacchetto non è verificato.

### 2.2 macOS (`brew`)

- [ ] Installa VS Code ([S-014](Sources.md#s-014)):

```bash
brew install --cask visual-studio-code
```

- [ ] Apri VS Code.
- [ ] Apri la Command Palette (`Cmd+Shift+P`).
- [ ] Esegui **Shell Command: Install 'code' command in PATH** ([S-011](Sources.md#s-011)).
- [ ] Apri un nuovo terminale e verifica:

```bash
code --version
```

### 2.3 Linux Debian/Ubuntu (`apt`)

- [ ] Installa la chiave di firma Microsoft ([S-009](Sources.md#s-009)):

```bash
sudo apt install wget gpg &&
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
```

- [ ] Crea il file `/etc/apt/sources.list.d/vscode.sources`:

```bash
sudo tee /etc/apt/sources.list.d/vscode.sources > /dev/null <<'EOF'
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF
```

- [ ] Aggiorna la cache e installa:

```bash
sudo apt update &&
sudo apt install code
```

- [ ] Verifica: `code --version`.

### 2.4 Linux openSUSE (`zypper`)

- [ ] Importa la chiave e crea il file di repository ([S-009](Sources.md#s-009)):

```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/zypp/repos.d/vscode.repo > /dev/null
```

- [ ] Installa:

```bash
sudo zypper refresh &&
sudo zypper install code
```

- [ ] Verifica: `code --version`.

> ⚠️ La riga `echo -e` riproduce la struttura del file descritta in [S-009](Sources.md#s-009) (sezione `[code]`, `baseurl`, `gpgcheck=1`, `gpgkey`). Le chiavi `enabled`, `autorefresh` e `type` sono da confrontare con il testo esatto della pagina.

### 2.5 Accesso a GitHub Copilot

- [ ] Apri VS Code.
- [ ] Apri la Chat view (`Ctrl+Alt+I` su Windows/Linux, `Ctrl+Cmd+I` su macOS).
- [ ] Esegui l'accesso con l'account GitHub che ha il piano Copilot.

> Il BYOK funziona anche **senza** accesso GitHub nelle sessioni *Local*. In questo caso imposta i modelli di utilità (`chat.utilityModel`, `chat.utilitySmallModel`) su un modello BYOK ([S-001](Sources.md#s-001)). Il documento [02-Configurazione-Copilot.md](02-Configurazione-Copilot.md) descrive questo caso.

---

## 3. Prerequisiti per LiteLLM: Docker e uv

Scegli il percorso:

- **Percorso A — Docker:** installa Docker (3.1). `uv` non è necessario.
- **Percorso B — servizio locale:** installa `uv` (3.2). Docker non è necessario.

### 3.1 Docker

**Windows**

- [ ] Installa Docker Desktop ⚠️ ([S-066](Sources.md#s-066)):

```powershell
winget install --id Docker.DockerDesktop -e
```

- [ ] Riavvia la sessione Windows, se Docker Desktop lo chiede.
- [ ] Avvia Docker Desktop.

**macOS**

- [ ] Installa Docker Desktop ([S-065](Sources.md#s-065)):

```bash
brew install --cask docker-desktop
```

- [ ] Avvia Docker Desktop dalla cartella Applicazioni.

**Linux Ubuntu (`apt`)** ([S-061](Sources.md#s-061))

- [ ] Aggiungi la chiave del repository Docker:

```bash
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

- [ ] Aggiungi il repository:

```bash
sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
```

- [ ] Installa i pacchetti:

```bash
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

> **Debian:** usa `https://download.docker.com/linux/debian` per la chiave e per `URIs`, e `VERSION_CODENAME` per `Suites` ⚠️ ([S-062](Sources.md#s-062)).

- [ ] Aggiungi l'utente al gruppo `docker` ⚠️ ([S-063](Sources.md#s-063)):

```bash
sudo usermod -aG docker $USER
newgrp docker
```

**Linux openSUSE (`zypper`)** ([S-064](Sources.md#s-064))

- [ ] Installa Docker e Compose:

```bash
sudo zypper install docker docker-compose docker-compose-switch
```

> Il pacchetto `docker-compose` è disponibile su Tumbleweed ([S-064](Sources.md#s-064)).

- [ ] Abilita e avvia il servizio:

```bash
sudo systemctl enable --now docker
```

- [ ] Aggiungi l'utente al gruppo `docker`:

```bash
sudo usermod -G docker -a $USER
newgrp docker
```

**Verifica (tutti i sistemi)**

```bash
docker version
docker compose version
```

### 3.2 uv

| Sistema | Comando | Fonte |
|---------|---------|-------|
| Windows | `winget install --id=astral-sh.uv -e` | [S-060](Sources.md#s-060) |
| macOS | `brew install uv` | [S-060](Sources.md#s-060) |
| Linux (tutte) | `curl -LsSf https://astral.sh/uv/install.sh \| sh` | [S-060](Sources.md#s-060), [D-009](Decisions.md#d-009) |

- [ ] Installa `uv` con il comando del tuo sistema.
- [ ] Apri un nuovo terminale.
- [ ] Verifica: `uv --version`.

---

## 4. Chiavi API e file `.env`

- [ ] Crea la cartella di lavoro e copia gli esempi:

```bash
mkdir -p ~/wpc2026-litellm
cp -r examples/litellm/* ~/wpc2026-litellm/
cd ~/wpc2026-litellm
cp .env.example .env
```

- [ ] Genera la master key e la salt key ([S-020](Sources.md#s-020)):

```bash
echo "LITELLM_MASTER_KEY=sk-$(openssl rand -hex 32)"
echo "LITELLM_SALT_KEY=sk-$(openssl rand -hex 32)"
```

Su Windows PowerShell 7 (generatore crittografico .NET):

```powershell
function New-SkKey { 'sk-' + -join ([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32) | ForEach-Object { $_.ToString('x2') }) }
"LITELLM_MASTER_KEY=$(New-SkKey)"
"LITELLM_SALT_KEY=$(New-SkKey)"
```

- [ ] Scrivi in `.env` le chiavi generate e le chiavi dei provider:

```dotenv
LITELLM_MASTER_KEY=sk-...
LITELLM_SALT_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
GEMINI_API_KEY=...
OPENROUTER_API_KEY=sk-or-...
HF_TOKEN=hf_...
```

> **Sicurezza.** Non fare commit del file `.env`. Il `.gitignore` del repo lo esclude.
> Il token Hugging Face deve essere *fine-grained* con il permesso *Make calls to Inference Providers* ([S-047](Sources.md#s-047)).
> `LITELLM_MASTER_KEY` è anche la password `admin` dell'Admin UI ([S-020](Sources.md#s-020)).

Il file [`examples/litellm/config.yaml`](../examples/litellm/config.yaml) definisce le route verso i cinque provider. Il documento [02-Configurazione-Copilot.md §4](02-Configurazione-Copilot.md#4-github-copilot-con-litellm-come-gateway) lo descrive.

---

## 5. LiteLLM con Docker

### 5.1 Profilo minimo (senza database)

Il profilo minimo usa solo `config.yaml` e la master key. Non ha Admin UI per i modelli, virtual keys e budget ([S-020](Sources.md#s-020)).

**Con `docker run`** ([S-020](Sources.md#s-020)):

```bash
cd ~/wpc2026-litellm
docker run -d --name litellm \
  --env-file .env \
  -v "$(pwd)/config.yaml:/app/config.yaml:ro" \
  -p 127.0.0.1:4000:4000 \
  ghcr.io/berriai/litellm:v1.90.2 \
  --config /app/config.yaml
```

> La porta è pubblicata solo su `127.0.0.1`: il proxy non è raggiungibile dalla rete locale.
> In PowerShell sostituisci `$(pwd)` con `${PWD}` e `\` con `` ` ``.

**Con Docker Compose:**

```bash
docker compose -f compose.minimal.yaml up -d
```

File: [`examples/litellm/compose.minimal.yaml`](../examples/litellm/compose.minimal.yaml).

### 5.2 Profilo esteso (PostgreSQL + Admin UI + virtual keys)

Il profilo esteso aggiunge PostgreSQL. PostgreSQL contiene modelli, chiavi e spend log ([S-020](Sources.md#s-020)).

- [ ] Imposta `POSTGRES_PASSWORD` in `.env`.
- [ ] Avvia lo stack:

```bash
docker compose -f compose.extended.yaml up -d
```

- [ ] Apri l'Admin UI: `http://localhost:4000/ui` (utente `admin`, password = `LITELLM_MASTER_KEY`) ([S-020](Sources.md#s-020)).

File: [`examples/litellm/compose.extended.yaml`](../examples/litellm/compose.extended.yaml).

> **Alternativa ufficiale.** LiteLLM pubblica `docker-compose.quickstart.yml` con gateway e PostgreSQL ([S-020](Sources.md#s-020)):
>
> ```bash
> curl -sSLO https://github.com/BerriAI/litellm/raw/main/docker/docker-compose.quickstart.yml
> ```

### 5.3 Arresto

```bash
docker compose -f compose.minimal.yaml down      # oppure compose.extended.yaml
docker rm -f litellm                             # se hai usato docker run
```

---

## 6. LiteLLM come servizio locale con uv

### 6.1 Installazione

- [ ] Installa LiteLLM proxy come tool isolato ([S-021](Sources.md#s-021)):

```bash
uv tool install 'litellm[proxy]'
```

> Non usare `pip install` su un Python vecchio: `pip` può installare una release vecchia. LiteLLM ≥ 1.84.0 richiede Python ≥ 3.10; `uv` installa un Python compatibile ([S-021](Sources.md#s-021)).

- [ ] Verifica l'avvio in primo piano:

```bash
cd ~/wpc2026-litellm
set -a; . ./.env; set +a
litellm --config config.yaml --port 4000
```

- [ ] Premi `Ctrl+C` per arrestare.

> Il profilo esteso con `uv` richiede un PostgreSQL esterno e la variabile `DATABASE_URL=postgresql://user:password@host:5432/litellm` ([S-022](Sources.md#s-022), [S-023](Sources.md#s-023)).

### 6.2 Servizio su Linux (systemd, utente)

La documentazione LiteLLM non descrive un servizio systemd ([S-023](Sources.md#s-023)). Questa unit è una proposta del progetto.

- [ ] Copia la unit:

```bash
mkdir -p ~/.config/systemd/user
cp ~/wpc2026-litellm/service/litellm.service ~/.config/systemd/user/
```

- [ ] Abilita e avvia:

```bash
systemctl --user daemon-reload
systemctl --user enable --now litellm.service
systemctl --user status litellm.service
```

- [ ] (Opzionale) Avvia il servizio anche senza login: `sudo loginctl enable-linger $USER`.

File: [`examples/litellm/service/litellm.service`](../examples/litellm/service/litellm.service).

### 6.3 Servizio su macOS (launchd, LaunchAgent)

- [ ] Modifica in [`com.wpc2026.litellm.plist`](../examples/litellm/service/com.wpc2026.litellm.plist) il nome utente nei percorsi.
- [ ] Copia e carica l'agente:

```bash
cp ~/wpc2026-litellm/service/com.wpc2026.litellm.plist ~/Library/LaunchAgents/
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.wpc2026.litellm.plist
launchctl print gui/$(id -u)/com.wpc2026.litellm | head -20
```

- [ ] Per arrestare: `launchctl bootout gui/$(id -u)/com.wpc2026.litellm`.

### 6.4 Servizio su Windows (Task Scheduler)

- [ ] Esegui in PowerShell lo script di registrazione:

```powershell
cd $HOME\wpc2026-litellm
.\service\Register-LiteLLMTask.ps1
```

- [ ] Verifica: `Get-ScheduledTask -TaskName WPC2026-LiteLLM`.
- [ ] Per arrestare: `Stop-ScheduledTask -TaskName WPC2026-LiteLLM`.

File: [`examples/litellm/service/Register-LiteLLMTask.ps1`](../examples/litellm/service/Register-LiteLLMTask.ps1).

> Il task si avvia al login dell'utente. Un servizio Windows vero (avvio senza login) richiede un wrapper come NSSM: fuori scopo per la demo.

---

## 7. Verifica finale

- [ ] Verifica la liveness ([S-023](Sources.md#s-023)):

```bash
curl -s http://localhost:4000/health/liveliness
```

- [ ] Verifica l'elenco dei modelli:

```bash
curl -s http://localhost:4000/v1/models -H "Authorization: Bearer $LITELLM_MASTER_KEY"
```

- [ ] Invia una richiesta di prova ([S-020](Sources.md#s-020)):

```bash
curl http://localhost:4000/v1/chat/completions \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model": "claude-sonnet", "messages": [{"role": "user", "content": "Say hello in five words."}]}'
```

| Risultato | Azione |
|-----------|--------|
| `401` | Controlla `LITELLM_MASTER_KEY` nel terminale e in `.env`. |
| Il modello non è nell'elenco | Controlla `model_name` in `config.yaml` e riavvia il proxy. |
| Errore del provider | Controlla la chiave API del provider in `.env`. Avvia con `--detailed_debug` ([S-021](Sources.md#s-021)). |
