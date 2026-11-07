# 01 — Installazione di Visual Studio Code e LiteLLM

Questo documento descrive l'installazione degli strumenti della demo su Windows, macOS e Linux.

| Strumento | Windows | macOS | Linux Debian/Ubuntu | Linux openSUSE |
|-----------|---------|-------|---------------------|----------------|
| Visual Studio Code | `winget` | `brew` | `apt` | `zypper` |
| Docker | `winget` (Docker Desktop) | `brew` (Docker Desktop) | `apt` (Docker Engine) | `zypper` |
| uv | `winget` | `brew` | installer ufficiale ([D-009](Decisions.md#d-009)) | installer ufficiale ([D-009](Decisions.md#d-009)) |
| LiteLLM proxy | Docker o `uv tool` | Docker o `uv tool` | Docker o `uv tool` | Docker o `uv tool` |

> **Nota su YaST.** Su openSUSE usiamo `zypper`. Leap 16 non ha più YaST: l'alternativa grafica è Myrlyn. Su Tumbleweed YaST Software è ancora disponibile, ma non riceve più sviluppo ([D-014](Decisions.md#d-014), [S-067](Sources.md#s-067)).

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
| `LITELLM_VERSION` | `1.108.2` | Versione LTS fissata ([D-018](Decisions.md#d-018), [S-119](Sources.md#s-119)). ⚠️ Controlla la LTS corrente prima del talk |
| `LITELLM_IMAGE` | `ghcr.io/berriai/litellm:v1.108.2` | Immagine Docker con tag fisso. Non usare tag mobili ([S-104](Sources.md#s-104)) |
| `LITELLM_MASTER_KEY` | generata | Chiave root del proxy, inizia con `sk-` ([S-020](Sources.md#s-020)) |
| `LITELLM_SALT_KEY` | generata | Solo profilo esteso. Non rigenerarla ([S-020](Sources.md#s-020)) |
| `POSTGRES_PASSWORD` | generata (`openssl rand -hex 24`) | Solo profilo esteso. Solo caratteri `[0-9a-f]`: entra in `DATABASE_URL` |

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

> Senza opzioni `winget` installa la *User setup*: non richiede privilegi di amministratore ([S-010](Sources.md#s-010), [S-012](Sources.md#s-012)).
> Per la *System setup* (tutti gli utenti, in `Program Files`) apri PowerShell come amministratore e aggiungi `--scope machine` (review P-06):
>
> ```powershell
> winget install --id Microsoft.VisualStudioCode -e --scope machine
> ```

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

> Il contenuto del file `vscode.repo` corrisponde al testo di [S-009](Sources.md#s-009) (review P-06).

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

- [ ] Apri PowerShell come amministratore. Il pacchetto `winget` di Docker Desktop ha solo l'installer per tutti gli utenti (`machine`) ([S-066](Sources.md#s-066), review P-06).
- [ ] Installa Docker Desktop:

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

> **Debian:** usa `https://download.docker.com/linux/debian` per la chiave e per `URIs`, e solo `$VERSION_CODENAME` per `Suites`. Su Debian testing e sulle derivate scrivi a mano il codename della release Debian (es. `trixie`) ([S-062](Sources.md#s-062)).

- [ ] Aggiungi l'utente al gruppo `docker` ⚠️ ([S-063](Sources.md#s-063)):

```bash
sudo usermod -aG docker $USER
newgrp docker
```

**Linux openSUSE (`zypper`)** ([S-064](Sources.md#s-064))

- [ ] Installa Docker e Compose. I pacchetti sono diversi per distribuzione ([S-064](Sources.md#s-064), [D-014](Decisions.md#d-014)):

```bash
# Tumbleweed
sudo zypper install docker docker-compose docker-compose-switch

# Leap 16  ⚠️ fonti in conflitto: prova il comando su una VM prima del talk
sudo zypper install docker docker-compose docker-buildx
```

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

> Ubuntu 26.10 ha un pacchetto `uv` (0.11.x), più vecchio della release corrente. Non lo usiamo ([D-009](Decisions.md#d-009), review P-06).

- [ ] Installa `uv` con il comando del tuo sistema.
- [ ] Apri un nuovo terminale.
- [ ] Verifica: `uv --version`.

---

## 4. Chiavi API e file `.env`

- [ ] Crea la cartella di lavoro e copia gli esempi:

```bash
mkdir -p ~/wpc2026-litellm
cp -R examples/litellm/. ~/wpc2026-litellm/     # il "." copia anche i file nascosti (.env.example)
cd ~/wpc2026-litellm
cp .env.example .env
```

```powershell
New-Item -ItemType Directory -Force "$HOME\wpc2026-litellm" | Out-Null
Copy-Item -Recurse -Force examples\litellm\* "$HOME\wpc2026-litellm\"
Set-Location "$HOME\wpc2026-litellm"
Copy-Item .env.example .env
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

- [ ] Limita i permessi di `.env` al solo proprietario ([04 AZ-01](04-Security-Review-OWASP-ISO27001.md#9-azioni)):

```bash
chmod 600 .env
```

```powershell
.\service\Protect-EnvFile.ps1 -Path .env   # rimuove regole ereditate ed esplicite, lascia solo l'utente corrente
```

> Gli script di avvio rifiutano un `.env` leggibile da altri utenti e lo leggono come coppie `CHIAVE=valore`, senza eseguirlo ([`service/load-env.sh`](../examples/litellm/service/load-env.sh)).

> **Sicurezza.** Non fare commit del file `.env`. Il `.gitignore` del repo lo esclude.
> Il token Hugging Face deve essere *fine-grained* con il permesso *Make calls to Inference Providers* ([S-047](Sources.md#s-047)).
> `LITELLM_MASTER_KEY` è anche la password `admin` dell'Admin UI ([S-020](Sources.md#s-020)).

Il file [`examples/litellm/config.yaml`](../examples/litellm/config.yaml) definisce le route verso i cinque provider. Il documento [02-Configurazione-Copilot.md §4](02-Configurazione-Copilot.md#4-github-copilot-con-litellm-come-gateway) lo descrive.

---

## 5. LiteLLM con Docker

### 5.0 Sicurezza della supply chain

Nel 2026 LiteLLM ha avuto due compromissioni della release ([S-104](Sources.md#s-104), [S-105](Sources.md#s-105)):

| Data | Versioni compromesse | Canale |
|------|----------------------|--------|
| 2026-03-24 | `1.82.7`, `1.82.8` | PyPI |
| 2026-10-21 | `1.107.0`; tag `latest`, `main-latest`, `main-stable` | PyPI, Docker Hub, GHCR |

Regole del progetto ([D-018](Decisions.md#d-018)):

- [ ] Usa sempre una versione fissata (`v1.108.2`). Non usare `latest`, `main-latest`, `main-stable`.
- [ ] Per l'uso in team fissa anche il digest e verifica la firma cosign con la chiave del 2026-10-23 ([S-104](Sources.md#s-104), [S-109](Sources.md#s-109)). Lo script controlla l'impronta della chiave, verifica la firma e stampa i digest da copiare in `.env`:

```bash
./scripts/pin-images.sh        # richiede docker e cosign
```

- [ ] Gli esempi usano l'immagine `litellm-non_root` ([S-109](Sources.md#s-109)). ⚠️ Lo script fallisce se il tag `v1.108.2` non esiste per questa immagine: in quel caso usa il tag LTS indicato dalle release note.
- [ ] Se hai installato `1.82.7`, `1.82.8` o `1.107.0`, considera rubate tutte le credenziali dell'host e ruotale ([S-104](Sources.md#s-104)).

### 5.1 Profilo minimo (senza database)

Il profilo minimo usa solo `config.yaml` e la master key. Non ha Admin UI per i modelli, virtual keys e budget ([S-020](Sources.md#s-020)).

**Con `docker run`** ([S-020](Sources.md#s-020)):

```bash
cd ~/wpc2026-litellm
docker run -d --name litellm \
  --env-file .env \
  --security-opt no-new-privileges:true --cap-drop ALL \
  -v "$(pwd)/config.yaml:/app/config.yaml:ro" \
  -p 127.0.0.1:4000:4000 \
  ghcr.io/berriai/litellm-non_root:v1.108.2 \
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

- [ ] Imposta `POSTGRES_PASSWORD` in `.env` con soli caratteri esadecimali. La password entra in `DATABASE_URL` senza codifica URI: caratteri come `#`, `/`, `%`, `@` impediscono la connessione:

```bash
echo "POSTGRES_PASSWORD=$(openssl rand -hex 24)"
```
- [ ] Avvia lo stack:

```bash
docker compose -f compose.extended.yaml up -d
```

- [ ] Crea il primo amministratore. `config.yaml` blocca il login UI con la master key (`disable_env_credential_login: true`), ma l'API accetta sempre la master key ([S-148](Sources.md#s-148)):

```bash
ADMIN_EMAIL=tu@example.com ./scripts/bootstrap-admin.sh
```

- [ ] Apri l'Admin UI: `http://localhost:4000/ui` e accedi con email e password del `proxy_admin`.

> Se rimani senza accesso: con la master key togli `disable_env_credential_login` da `config.yaml`, riavvia, crea l'utente, rimetti l'opzione e riavvia ([S-148](Sources.md#s-148)). Un `proxy_admin` di emergenza può accedere da `/fallback/login`.

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
uv tool install 'litellm[proxy]==1.108.2'
```

> Non usare `pip install` su un Python vecchio: `pip` può installare una release vecchia. LiteLLM ≥ 1.84.0 richiede Python ≥ 3.10; `uv` installa un Python compatibile ([S-021](Sources.md#s-021)).

- [ ] Verifica l'avvio in primo piano. Lo script legge `.env` in modo sicuro e usa `--host 127.0.0.1`:

```bash
cd ~/wpc2026-litellm
./service/start-litellm.sh
```

> Il default di `--host` è `0.0.0.0`: il proxy è raggiungibile da tutta la rete locale. Usa sempre `--host 127.0.0.1` ([S-118](Sources.md#s-118)).

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
systemd-analyze --user security litellm.service   # valuta le direttive di hardening
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
- [ ] Log: `~/Library/Logs/wpc2026-litellm.log` (permessi solo utente).

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

- [ ] Carica nel terminale corrente **solo** la master key. Compose e gli script di avvio leggono `.env` da soli, il terminale no:

```bash
export LITELLM_MASTER_KEY="$(grep -E '^LITELLM_MASTER_KEY=' ~/wpc2026-litellm/.env | cut -d= -f2-)"
```

```powershell
$env:LITELLM_MASTER_KEY = ((Select-String -Path "$HOME\wpc2026-litellm\.env" -Pattern '^LITELLM_MASTER_KEY=').Line -split '=', 2)[1]
```

- [ ] Verifica la liveness. `/health/liveliness` e `/health/readiness` non richiedono chiave; `/health` la richiede ([S-023](Sources.md#s-023), [S-117](Sources.md#s-117)):

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
