---
title: Runbook WPC2026 — GitHub Copilot in VS Code con LLM via API (nativo e LiteLLM)
version: 1.1.0
---

# Runbook WPC2026

Questo runbook guida l'installazione e la configurazione descritte in [01-Installazione](../01-Installazione.md) e [02-Configurazione-Copilot](../02-Configurazione-Copilot.md), e la prova del team di agenti di [05-Team-Agenti](../05-Team-Agenti.md) (fase F9).
Il sito offline in `site/` si genera da questo file con `tools/update-site.sh` (o `tools/update-site.ps1`).

**Regole di scrittura del file** (il generatore le legge):

- `## F<n> — <titolo>` apre una fase.
- `### S-<nnn> — <titolo>` apre un passo. La riga successiva `<!-- step: os=… path=… profile=… evidence=… -->` dà i filtri.
  - `os`: `all`, oppure una lista tra `windows`, `macos`, `debian`, `opensuse`.
  - `path`: `all`, `docker`, `uv`. `profile`: `all`, `minimal`, `extended`.
  - `evidence=no-output`: il sito non salva l'output di quel passo (es. generazione di segreti).
- Un blocco di codice con `os=` nell'intestazione (es. ` ```bash os=macos `) appare solo per quei sistemi.
- `{{NOME}}` nei comandi è un parametro della tabella **Parametri**. Il sito lo sostituisce con il valore inserito.
- La colonna **Tipo** della tabella limita i valori: `path` (percorso), `port` (1–65535), `major` (numero), `version` (lettere, cifre, `.`, `_`, `-`), `name` (lettere, cifre, `.`, `_`, `-`), `email`. Un URL con un parametro sta tra virgolette doppie.
- Nei comandi bash e PowerShell un parametro che contiene un percorso o un testo libero sta sempre tra virgolette doppie (es. `"{{WPC_DIR}}"`): così un percorso con spazi resta un solo argomento. Per la home usa `$HOME`, non `~`: tra virgolette `~` non si espande. Per un `path` il sito rifiuta virgolette, parentesi, backtick, `$` (salvo `$HOME` all'inizio), `; | & < >`, un `-` iniziale e un `\` finale.
- Nessun segreto nei comandi: le chiavi stanno solo in `.env` e nel secret storage di VS Code.

## Parametri

| Nome | Tipo | Default | Default Windows | Descrizione |
|------|------|---------|-----------------|-------------|
| WPC_DIR | path | $HOME/wpc2026-litellm | $HOME\wpc2026-litellm | Cartella di lavoro di LiteLLM |
| REPO_DIR | path | $HOME/Sviluppo/GITHUB/WPC2026 | $HOME\Sviluppo\GITHUB\WPC2026 | Clone locale del repository WPC2026 |
| LITELLM_PORT | port | 4000 | 4000 | Porta del proxy LiteLLM (solo `127.0.0.1`) |
| LITELLM_VERSION | version | 1.108.2 | 1.108.2 | Versione LTS di LiteLLM ([D-018](../Decisions.md#d-018)) |
| ADMIN_ID | name | wpc-admin | wpc-admin | Utente `proxy_admin` (profilo esteso) |
| ADMIN_EMAIL | email | tu@example.com | tu@example.com | Email del `proxy_admin` (profilo esteso) |
| SPECKIT_VERSION | version | 1.4.0 | 1.4.0 | Versione di Spec Kit ⚠️ da controllare ([S-085](../Sources.md#s-085), [D-042](../Decisions.md#d-042)) |
| SPECKIT_PROJECT | name | wpc-speckit-demo | wpc-speckit-demo | Cartella del progetto di prova Spec Kit |
| PG_MAJOR | major | 16 | 16 | Versione principale di PostgreSQL del profilo esteso: immagine Docker (S-301) e installazione con uv (S-402) ([D-030](../Decisions.md#d-030)) |
| TEAM_PROJECT | path | $HOME/Sviluppo/GITHUB/team-demo | $HOME\Sviluppo\GITHUB\team-demo | Clone locale del repository di prova del team di agenti (fase F9) |
| GH_OWNER | name | contoso | contoso | Organizzazione o utente GitHub del repository di prova |
| GH_REPO | name | team-demo | team-demo | Nome del repository di prova |
| PO_USER | name | release-approver | release-approver | Utente GitHub del Product Owner, unico *code owner* |

## F1 — Prerequisiti

### S-101 — Installa Visual Studio Code
<!-- step: os=all path=all profile=all -->

Installa VS Code con il package manager del sistema ([S-012](../Sources.md#s-012), [S-014](../Sources.md#s-014), [S-009](../Sources.md#s-009)).

```powershell os=windows
winget install --id Microsoft.VisualStudioCode -e
```

```bash os=macos
brew install --cask visual-studio-code
```

```bash os=debian
sudo apt install wget gpg &&
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
sudo tee /etc/apt/sources.list.d/vscode.sources > /dev/null <<'EOF'
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF
sudo apt update && sudo apt install code
```

```bash os=opensuse
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/zypp/repos.d/vscode.repo > /dev/null
sudo zypper refresh && sudo zypper install code
```

**Esito atteso:** `code --version` mostra la versione di VS Code.

### S-102 — Installa PowerShell 7
<!-- step: os=windows path=all profile=all -->

Il servizio Windows e gli script `.ps1` usano PowerShell 7 ([01 §3.2](../01-Installazione.md#32-powershell-7-solo-windows)).

```powershell os=windows
winget install --id Microsoft.PowerShell -e
pwsh -Version
```

**Esito atteso:** `pwsh -Version` mostra la versione 7.x.

### S-103 — Installa Docker
<!-- step: os=all path=docker profile=all -->

Installa Docker Desktop (Windows, macOS) o Docker Engine (Linux) ([S-065](../Sources.md#s-065), [S-061](../Sources.md#s-061), [S-064](../Sources.md#s-064)).

```powershell os=windows
# PowerShell come amministratore: il pacchetto ha solo l'installer per tutti gli utenti
winget install --id Docker.DockerDesktop -e
```

```bash os=macos
brew install --cask docker-desktop
```

```bash os=debian
sudo apt update && sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER && newgrp docker
```

```bash os=opensuse
# Tumbleweed. Leap 16: sudo zypper install docker docker-compose docker-buildx (⚠️ da provare)
sudo zypper install docker docker-compose docker-compose-switch
sudo systemctl enable --now docker
sudo usermod -G docker -a $USER && newgrp docker
```

> Su Debian sostituisci `linux/ubuntu` con `linux/debian` e usa solo `$VERSION_CODENAME` ([S-062](../Sources.md#s-062)).

**Esito atteso:** `docker version` e `docker compose version` rispondono senza errori.

### S-104 — Installa uv
<!-- step: os=all path=all profile=all -->

`uv` serve per LiteLLM come servizio locale e per Spec Kit ([S-060](../Sources.md#s-060), [D-009](../Decisions.md#d-009)).

```powershell os=windows
winget install --id=astral-sh.uv -e
uv tool update-shell
```

```bash os=macos
brew install uv
uv tool update-shell
```

```bash os=debian,opensuse
curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool update-shell
```

`uv tool update-shell` aggiunge al `PATH` la cartella dei comandi installati con `uv tool install` (`litellm`, `specify`): con `winget` e `brew` non succede da solo ([S-060](../Sources.md#s-060)).

**Esito atteso:** in un nuovo terminale `uv --version` mostra la versione.

### S-105 — Accedi a GitHub Copilot
<!-- step: os=all path=all profile=all -->

- [ ] Apri VS Code e la Chat view (`Ctrl+Alt+I`; macOS `Ctrl+Cmd+I`).
- [ ] Accedi con l'account GitHub del piano Copilot.
- [ ] Business/Enterprise: se il model picker non mostra **Manage Language Models**, chiedi all'amministratore di controllare la policy *Bring Your Own Language Model Key in VS Code* ([D-013](../Decisions.md#d-013)).

**Esito atteso:** la Chat view risponde e il model picker mostra **Manage Language Models**.

### S-106 — Applica la baseline di sicurezza di VS Code
<!-- step: os=all path=all profile=all -->

Copia [`settings.secure.jsonc`](../../examples/vscode/settings.secure.jsonc) nelle **impostazioni utente** (*Preferences: Open User Settings (JSON)*), non in `.vscode/settings.json` ([03 §7](../03-Security-Best-Practices.md#7-baseline-di-configurazione)).

- [ ] Workspace Trust con `startupPrompt: once`.
- [ ] Nessuna auto-approvazione globale.
- [ ] Sandbox dell'agente: `chat.agent.sandbox.enabled: "on"` (default `off`).

**Esito atteso:** aprendo una cartella nuova, VS Code chiede la fiducia; in chat `/sandbox policy` mostra la sandbox attiva.

## F2 — Cartella di lavoro e segreti di LiteLLM

### S-201 — Copia gli esempi nella cartella di lavoro
<!-- step: os=all path=all profile=all -->

```bash os=macos,debian,opensuse
mkdir -p "{{WPC_DIR}}"
cp -R "{{REPO_DIR}}/examples/litellm/." "{{WPC_DIR}}/"
cd "{{WPC_DIR}}" && { [ -e .env ] || cp .env.example .env; }   # non sovrascrive un .env esistente
```

```powershell os=windows
New-Item -ItemType Directory -Force "{{WPC_DIR}}" | Out-Null
Copy-Item -Recurse -Force "{{REPO_DIR}}\examples\litellm\*" "{{WPC_DIR}}\"
# .env.example in modo esplicito: un file che inizia con "." può essere nascosto al carattere jolly
Copy-Item -Force "{{REPO_DIR}}\examples\litellm\.env.example" "{{WPC_DIR}}\"
Set-Location "{{WPC_DIR}}"; if (-not (Test-Path .env)) { Copy-Item .env.example .env }   # non sovrascrive un .env esistente
```

**Esito atteso:** la cartella contiene `.env`, `config.yaml`, `compose.*.yaml`, `scripts/`, `service/`. Se ripeti il passo, il `.env` esistente resta invariato.

### S-202 — Genera master key, salt key e password del database
<!-- step: os=all path=all profile=all evidence=no-output -->

Il sito **non salva** l'output di questo passo: contiene segreti. Copia i valori direttamente in `.env`.

```bash os=macos,debian,opensuse
echo "LITELLM_MASTER_KEY=sk-$(openssl rand -hex 32)"
echo "LITELLM_SALT_KEY=sk-$(openssl rand -hex 32)"
echo "POSTGRES_PASSWORD=$(openssl rand -hex 24)"
```

```powershell os=windows
function New-Hex([int]$n) { -join ([System.Security.Cryptography.RandomNumberGenerator]::GetBytes($n) | ForEach-Object { $_.ToString('x2') }) }
"LITELLM_MASTER_KEY=sk-$(New-Hex 32)"
"LITELLM_SALT_KEY=sk-$(New-Hex 32)"
"POSTGRES_PASSWORD=$(New-Hex 24)"
```

**Esito atteso:** tre righe `CHIAVE=valore`. `LITELLM_SALT_KEY` non si rigenera più ([S-020](../Sources.md#s-020)).

### S-203 — Compila .env con le chiavi dei provider
<!-- step: os=all path=all profile=all evidence=no-output -->

- [ ] Scrivi in `.env` i valori di S-202.
- [ ] Scrivi le chiavi dei provider: `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, `GEMINI_API_KEY`, `OPENROUTER_API_KEY`, `HF_TOKEN` (fine-grained, *Make calls to Inference Providers*) ([S-047](../Sources.md#s-047)).
- [ ] Se usi una porta diversa da 4000: `LITELLM_PORT={{LITELLM_PORT}}`.
- [ ] Imposta limiti di spesa nelle console dei provider ([03 §6](../03-Security-Best-Practices.md#6-chiavi-api-dei-provider)).

**Esito atteso:** nessuna variabile obbligatoria vuota (`LITELLM_MASTER_KEY`, `LITELLM_SALT_KEY`).

### S-204 — Limita i permessi di .env
<!-- step: os=all path=all profile=all -->

```bash os=macos,debian,opensuse
chmod 600 "{{WPC_DIR}}/.env" && ls -l "{{WPC_DIR}}/.env"
```

```powershell os=windows
& "{{WPC_DIR}}\service\Protect-EnvFile.ps1" -Path "{{WPC_DIR}}\.env"
(Get-Acl "{{WPC_DIR}}\.env").Access | Format-Table IdentityReference, FileSystemRights
```

**Esito atteso:** solo l'utente corrente ha accesso (`-rw-------`, oppure un'unica regola ACL).

## F3 — LiteLLM con Docker

### S-301 — Verifica la firma e fissa i digest delle immagini
<!-- step: os=macos,debian,opensuse path=docker profile=all -->

Richiede `cosign`. Lo script verifica l'impronta della chiave, scarica l'immagine e verifica la firma sul digest ([03 §5.1](../03-Security-Best-Practices.md#51-release-e-immagini)).

```bash os=macos,debian,opensuse
cd "{{WPC_DIR}}" && LITELLM_TAG="v{{LITELLM_VERSION}}" POSTGRES_TAG="{{PG_MAJOR}}" ./scripts/pin-images.sh
```

- [ ] Copia in `.env` le righe `LITELLM_IMAGE=…@sha256:…` e `POSTGRES_IMAGE=…@sha256:…`.

**Esito atteso:** lo script stampa `Firma verificata` e i due digest. ⚠️ Se il tag non esiste per `litellm-non_root`, usa il tag LTS delle release note.

### S-302 — Avvia il profilo minimo
<!-- step: os=all path=docker profile=minimal -->

```bash os=macos,debian,opensuse
cd "{{WPC_DIR}}" && docker compose -f compose.minimal.yaml up -d && docker compose -f compose.minimal.yaml ps
```

```powershell os=windows
Set-Location "{{WPC_DIR}}"; docker compose -f compose.minimal.yaml up -d; docker compose -f compose.minimal.yaml ps
```

**Esito atteso:** il servizio `litellm` è `running`. Se Compose segnala `set LITELLM_MASTER_KEY in .env`, completa S-203.

### S-303 — Avvia il profilo esteso
<!-- step: os=all path=docker profile=extended -->

```bash os=macos,debian,opensuse
cd "{{WPC_DIR}}" && docker compose -f compose.extended.yaml up -d && docker compose -f compose.extended.yaml ps
```

```powershell os=windows
Set-Location "{{WPC_DIR}}"; docker compose -f compose.extended.yaml up -d; docker compose -f compose.extended.yaml ps
```

**Esito atteso:** `db` è `healthy` e `litellm` è `running`.

## F4 — LiteLLM come servizio locale con uv

### S-401 — Installa LiteLLM con uv
<!-- step: os=all path=uv profile=all -->

```bash os=all
uv tool install "litellm[proxy]=={{LITELLM_VERSION}}"
```

**Esito atteso:** `litellm --version` mostra `{{LITELLM_VERSION}}`. Non usare le versioni `1.82.7`, `1.82.8`, `1.107.0` ([S-104](../Sources.md#s-104)).

### S-402 — Profilo esteso: installa PostgreSQL
<!-- step: os=all path=uv profile=extended -->

Con `uv` il profilo esteso usa un PostgreSQL esterno al proxy ([01 §6](../01-Installazione.md#6-litellm-come-servizio-locale-con-uv), [S-022](../Sources.md#s-022)). Questo passo lo installa sulla stessa macchina, con la versione `{{PG_MAJOR}}` del profilo Docker ([D-030](../Decisions.md#d-030)). Se usi un database della tua organizzazione, segna il passo come **Non applicabile** e vai a S-404.

```powershell os=windows
# PowerShell come amministratore. Installer EDB in modo interattivo: imposta la password del superutente "postgres" (S-158)
winget search PostgreSQL.PostgreSQL
winget install --id "PostgreSQL.PostgreSQL.{{PG_MAJOR}}" -e --interactive
Get-Service "postgresql-x64-{{PG_MAJOR}}"
```

```bash os=macos
brew install "postgresql@{{PG_MAJOR}}"
brew services start "postgresql@{{PG_MAJOR}}"
"$(brew --prefix "postgresql@{{PG_MAJOR}}")/bin/psql" -d postgres -tAc 'SELECT version()'
```

```bash os=debian
# Repository PGDG: la versione {{PG_MAJOR}} non è nei pacchetti di ogni release (S-160)
sudo apt install -y postgresql-common
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y
sudo apt update && sudo apt install -y "postgresql-{{PG_MAJOR}}"
sudo -iu postgres psql -tAc 'SELECT version()'
```

```bash os=opensuse
# ⚠️ da provare: nome del pacchetto e inizializzazione automatica della cartella dati al primo avvio (S-161)
sudo zypper install "postgresql{{PG_MAJOR}}-server" "postgresql{{PG_MAJOR}}"
sudo systemctl enable --now postgresql
sudo -iu postgres psql -tAc 'SELECT version()'
```

**Esito atteso:** il servizio è attivo e `SELECT version()` mostra `PostgreSQL {{PG_MAJOR}}.x`.

### S-403 — Profilo esteso: limita PostgreSQL a localhost e alle password
<!-- step: os=all path=uv profile=extended -->

Il server ascolta solo su `localhost` e le connessioni TCP usano `scram-sha-256` ([S-162](../Sources.md#s-162), [S-163](../Sources.md#s-163)). L'installer EDB per Windows ascolta su tutte le interfacce; Homebrew accetta le connessioni locali senza password (`trust`).

```powershell os=windows
# PowerShell come amministratore (Restart-Service). Ogni comando psql chiede la password di "postgres".
$psql = "C:\Program Files\PostgreSQL\{{PG_MAJOR}}\bin\psql.exe"
& $psql -U postgres -c "ALTER SYSTEM SET listen_addresses = 'localhost';"
$hba = & $psql -U postgres -tAc "SHOW hba_file;"
(Get-Content $hba) -replace '^(host\s.*\s)(trust|ident|md5|password)\s*$', '${1}scram-sha-256' | Set-Content -Encoding utf8 $hba
Restart-Service "postgresql-x64-{{PG_MAJOR}}"
& $psql -U postgres -tAc "SHOW listen_addresses;"
Select-String -Path $hba -Pattern '^host'
```

```bash os=macos
PGBIN="$(brew --prefix "postgresql@{{PG_MAJOR}}")/bin"
HBA="$("$PGBIN/psql" -d postgres -tAc 'SHOW hba_file')"
sed -i '' -E 's/^(host[[:space:]].*[[:space:]])(trust|ident|md5|password)[[:space:]]*$/\1scram-sha-256/' "$HBA"
"$PGBIN/psql" -d postgres -c "ALTER SYSTEM SET listen_addresses = 'localhost'"
brew services restart "postgresql@{{PG_MAJOR}}"
"$PGBIN/psql" -d postgres -tAc 'SHOW listen_addresses'; grep -E '^host' "$HBA"
```

```bash os=debian,opensuse
HBA="$(sudo -iu postgres psql -tAc 'SHOW hba_file')"
sudo sed -i -E 's/^(host[[:space:]].*[[:space:]])(trust|ident|md5|password)[[:space:]]*$/\1scram-sha-256/' "$HBA"
sudo -iu postgres psql -c "ALTER SYSTEM SET listen_addresses = 'localhost'"
sudo systemctl restart postgresql
sudo -iu postgres psql -tAc 'SHOW listen_addresses'; sudo grep -E '^host' "$HBA"
```

**Esito atteso:** `listen_addresses` vale `localhost`; ogni riga `host` termina con `scram-sha-256`. ⚠️ macOS: le connessioni dal socket locale (righe `local`) restano `trust` per il tuo utente, che è il superutente del database.

### S-404 — Profilo esteso: crea utente e database e scrivi DATABASE_URL
<!-- step: os=all path=uv profile=extended -->

L'utente `litellm` usa `POSTGRES_PASSWORD` di `.env` (S-202: solo caratteri `[0-9a-f]`, quindi entra nell'URL senza codifica). La password passa a `psql` da standard input: non compare nella lista dei processi né nell'output. Con un database della tua organizzazione, chiedi utente e database all'amministratore e scrivi solo la riga `DATABASE_URL`.

```powershell os=windows
Set-Location "{{WPC_DIR}}"
$pg = "C:\Program Files\PostgreSQL\{{PG_MAJOR}}\bin"
$pw = ((Select-String -Path .env -Pattern '^POSTGRES_PASSWORD=').Line -split '=', 2)[1]
if ($pw -match '^[0-9a-f]{16,}$') {
    "CREATE ROLE litellm LOGIN PASSWORD '$pw';" | & "$pg\psql.exe" -U postgres -d postgres -v ON_ERROR_STOP=1
    & "$pg\createdb.exe" -U postgres -O litellm litellm
    if (-not (Select-String -Path .env -Pattern '^DATABASE_URL=' -Quiet)) { Add-Content .env "DATABASE_URL=postgresql://litellm:$pw@127.0.0.1:5432/litellm" }
    if (-not (Select-String -Path .env -Pattern '^STORE_MODEL_IN_DB=' -Quiet)) { Add-Content .env 'STORE_MODEL_IN_DB=True' }
    $env:PGPASSWORD = $pw; & "$pg\psql.exe" -h 127.0.0.1 -U litellm -d litellm -tAc 'SELECT current_user'; Remove-Item Env:PGPASSWORD
} else { Write-Error 'POSTGRES_PASSWORD in .env manca o non è esadecimale (S-202)' }
Remove-Variable pw
```

```bash os=macos
cd "{{WPC_DIR}}"
PGBIN="$(brew --prefix "postgresql@{{PG_MAJOR}}")/bin"
pw="$(grep -E '^POSTGRES_PASSWORD=' .env | cut -d= -f2-)"
if [[ "$pw" =~ ^[0-9a-f]{16,}$ ]]; then
  printf "CREATE ROLE litellm LOGIN PASSWORD '%s';\n" "$pw" | "$PGBIN/psql" -d postgres -v ON_ERROR_STOP=1
  "$PGBIN/createdb" -O litellm litellm
  grep -q '^DATABASE_URL=' .env || printf 'DATABASE_URL=postgresql://litellm:%s@127.0.0.1:5432/litellm\n' "$pw" >> .env
  grep -q '^STORE_MODEL_IN_DB=' .env || echo 'STORE_MODEL_IN_DB=True' >> .env
  PGPASSWORD="$pw" "$PGBIN/psql" -h 127.0.0.1 -U litellm -d litellm -tAc 'SELECT current_user'
else
  echo "POSTGRES_PASSWORD in .env manca o non è esadecimale (S-202)" >&2
fi
unset pw
```

```bash os=debian,opensuse
cd "{{WPC_DIR}}"
pw="$(grep -E '^POSTGRES_PASSWORD=' .env | cut -d= -f2-)"
if [[ "$pw" =~ ^[0-9a-f]{16,}$ ]]; then
  printf "CREATE ROLE litellm LOGIN PASSWORD '%s';\n" "$pw" | sudo -iu postgres psql -d postgres -v ON_ERROR_STOP=1
  sudo -iu postgres createdb -O litellm litellm
  grep -q '^DATABASE_URL=' .env || printf 'DATABASE_URL=postgresql://litellm:%s@127.0.0.1:5432/litellm\n' "$pw" >> .env
  grep -q '^STORE_MODEL_IN_DB=' .env || echo 'STORE_MODEL_IN_DB=True' >> .env
  PGPASSWORD="$pw" psql -h 127.0.0.1 -U litellm -d litellm -tAc 'SELECT current_user'
else
  echo "POSTGRES_PASSWORD in .env manca o non è esadecimale (S-202)" >&2
fi
unset pw
```

- [ ] Controlla che `.env` contenga anche `LITELLM_SALT_KEY` (S-203).

`STORE_MODEL_IN_DB=True` è lo stesso valore di `compose.extended.yaml`: i modelli si gestiscono anche dall'Admin UI.

**Esito atteso:** l'ultimo comando stampa `litellm`. In S-405 il proxy si avvia senza errori di connessione al database. ⚠️ Da provare: percorso uv + profilo esteso.

### S-405 — Prova l'avvio in primo piano
<!-- step: os=all path=uv profile=all -->

```bash os=macos,debian,opensuse
cd "{{WPC_DIR}}" && WPC_DIR="{{WPC_DIR}}" ./service/start-litellm.sh
```

```powershell os=windows
& "{{WPC_DIR}}\service\Start-LiteLLM.ps1" -WpcDir "{{WPC_DIR}}"
```

**Esito atteso:** il proxy ascolta su `127.0.0.1:{{LITELLM_PORT}}`. Ferma con `Ctrl+C`.

### S-406 — Registra il servizio
<!-- step: os=all path=uv profile=all -->

La unit systemd e il LaunchAgent usano il percorso `~/wpc2026-litellm`. Se `WPC_DIR` è diverso, cambia il percorso nei file copiati prima di attivarli.

```bash os=debian,opensuse
mkdir -p ~/.config/systemd/user
cp "{{WPC_DIR}}/service/litellm.service" ~/.config/systemd/user/
systemctl --user daemon-reload && systemctl --user enable --now litellm.service
systemctl --user status litellm.service --no-pager
systemd-analyze --user security litellm.service
```

```bash os=macos
mkdir -p ~/Library/LaunchAgents
sed "s/USERNAME/$(whoami)/g" "{{WPC_DIR}}/service/com.wpc2026.litellm.plist" > ~/Library/LaunchAgents/com.wpc2026.litellm.plist
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.wpc2026.litellm.plist
launchctl print gui/$(id -u)/com.wpc2026.litellm | head -20
```

```powershell os=windows
& "{{WPC_DIR}}\service\Register-LiteLLMTask.ps1" -WpcDir "{{WPC_DIR}}"
Get-ScheduledTask -TaskName WPC2026-LiteLLM
```

Profilo esteso: esegui prima S-405. Al primo avvio con `DATABASE_URL` LiteLLM prepara il client Prisma, che scrive nella cartella dello strumento `uv` e nella cache dell'utente. La unit systemd ha `ProtectHome=read-only` e può scrivere solo in `{{WPC_DIR}}`.

**Esito atteso:** il servizio è attivo. ⚠️ systemd: verifica l'avvio con `ProtectHome=read-only`. ⚠️ Profilo esteso: se la unit si ferma con errori di Prisma o di permessi in `~/.local/share/uv` o `~/.cache`, aggiungi quelle cartelle con `systemctl --user edit litellm.service` (`[Service]` → `ReadWritePaths=-%h/.local/share/uv/tools/litellm -%h/.cache/prisma-python`) e annota l'esito nelle evidenze.

## F5 — Verifica del gateway

### S-501 — Carica solo la master key nel terminale
<!-- step: os=all path=all profile=all evidence=no-output -->

```bash os=macos,debian,opensuse
export LITELLM_MASTER_KEY="$(grep -E '^LITELLM_MASTER_KEY=' "{{WPC_DIR}}/.env" | cut -d= -f2-)"
```

```powershell os=windows
$env:LITELLM_MASTER_KEY = ((Select-String -Path "{{WPC_DIR}}\.env" -Pattern '^LITELLM_MASTER_KEY=').Line -split '=', 2)[1]
```

**Esito atteso:** nessun output. La variabile vale solo per questo terminale.

### S-502 — Verifica la liveness
<!-- step: os=all path=all profile=all -->

```bash os=all
curl -s "http://localhost:{{LITELLM_PORT}}/health/liveliness"
```

**Esito atteso:** risposta positiva senza chiave ([S-117](../Sources.md#s-117)).

### S-503 — Elenca i modelli
<!-- step: os=all path=all profile=all -->

```bash os=macos,debian,opensuse
printf 'Authorization: Bearer %s\n' "$LITELLM_MASTER_KEY" | curl -s "http://localhost:{{LITELLM_PORT}}/v1/models" -H @-
```

```powershell os=windows
Invoke-RestMethod -Uri "http://localhost:{{LITELLM_PORT}}/v1/models" -Headers @{ Authorization = "Bearer $env:LITELLM_MASTER_KEY" } | ConvertTo-Json -Depth 5
```

**Esito atteso:** gli alias `claude-opus`, `claude-sonnet`, `codex`, `gemini`, `gemini-pro`, `openrouter-gpt-oss`, `openrouter-qwen35-review`, `hf-gpt-oss`.

### S-504 — Invia una richiesta di prova
<!-- step: os=all path=all profile=all -->

```bash os=macos,debian,opensuse
printf 'Authorization: Bearer %s\n' "$LITELLM_MASTER_KEY" \
  | curl -s "http://localhost:{{LITELLM_PORT}}/v1/chat/completions" -H @- \
  -H "Content-Type: application/json" \
  -d '{"model": "claude-sonnet", "messages": [{"role": "user", "content": "Say hello in five words."}]}'
```

```powershell os=windows
$body = @{ model = 'claude-sonnet'; messages = @(@{ role = 'user'; content = 'Say hello in five words.' }) } | ConvertTo-Json -Depth 5
Invoke-RestMethod -Method Post -Uri "http://localhost:{{LITELLM_PORT}}/v1/chat/completions" -Headers @{ Authorization = "Bearer $env:LITELLM_MASTER_KEY" } -ContentType 'application/json' -Body $body
```

**Esito atteso:** una risposta del modello. `401`: controlla la master key. Errore del provider: controlla la chiave del provider in `.env`.

### S-505 — Crea il primo proxy_admin
<!-- step: os=all path=all profile=extended -->

Il proxy deve essere attivo (S-502): lo script chiama le API `/user/new` e `/user/update`. La password è chiesta in modo interattivo: almeno 12 caratteri con maiuscole, minuscole, cifre e simboli ([S-148](../Sources.md#s-148)).

```bash os=macos,debian,opensuse
cd "{{WPC_DIR}}" && WPC_DIR="{{WPC_DIR}}" ADMIN_ID="{{ADMIN_ID}}" ADMIN_EMAIL="{{ADMIN_EMAIL}}" ./scripts/bootstrap-admin.sh
```

```powershell os=windows
& "{{WPC_DIR}}\scripts\Bootstrap-Admin.ps1" -WpcDir "{{WPC_DIR}}" -AdminId "{{ADMIN_ID}}" -AdminEmail "{{ADMIN_EMAIL}}"
```

**Esito atteso:** `proxy_admin '{{ADMIN_ID}}' pronto`. Login su `http://localhost:{{LITELLM_PORT}}/ui` con email e password. In caso di errore dopo la creazione: ripeti con `RESUME=1` o `-Resume`.

## F6 — Copilot con BYOK nativo

### S-601 — Aggiungi Claude (Anthropic)
<!-- step: os=all path=all profile=all -->

- [ ] **Chat: Manage Language Models** → **Add Models** → **Anthropic** → incolla la chiave.
- [ ] Seleziona `claude-sonnet-5-5` nel model picker ([02 §3.1](../02-Configurazione-Copilot.md#31-claudeai-anthropic-api)).

**Esito atteso:** il modello risponde in chat e appare tra i modelli per gli agenti.

### S-602 — Aggiungi Codex (OpenAI)
<!-- step: os=all path=all profile=all -->

- [ ] **Add Models** → **OpenAI** → chiave → modello `gpt-6.1-sol` ([D-015](../Decisions.md#d-015)).

**Esito atteso:** il modello risponde in chat.

### S-603 — Aggiungi Gemini
<!-- step: os=all path=all profile=all -->

- [ ] **Add Models** → **Gemini** → chiave AI Studio → `gemini-4-argon` e `gemini-3.1-pro-preview` ([D-016](../Decisions.md#d-016)).

**Esito atteso:** entrambi i modelli rispondono. `gemini-4-argon` richiede il tier a pagamento.

### S-604 — Aggiungi OpenRouter
<!-- step: os=all path=all profile=all -->

- [ ] **Add Models** → **OpenRouter** → chiave → `openai/gpt-oss-120b` ([02 §3.4](../02-Configurazione-Copilot.md#34-openrouter-provider-built-in-o-custom-endpoint)).

**Esito atteso:** il modello risponde in chat.

### S-605 — Aggiungi Hugging Face
<!-- step: os=all path=all profile=all -->

- [ ] Installa l'estensione *Hugging Face Provider for GitHub Copilot Chat*.
- [ ] **Manage Models…** → **Hugging Face** → token fine-grained → modelli ([D-008](../Decisions.md#d-008)).

**Esito atteso:** i modelli HF compaiono nel model picker e rispondono.

## F7 — Copilot via LiteLLM

### S-701 — Configura il Custom Endpoint LiteLLM
<!-- step: os=all path=all profile=all -->

- [ ] **Add Models** → **Custom Endpoint**.
- [ ] Copia in `chatLanguageModels.json` il contenuto di [`chatLanguageModels.litellm.json`](../../examples/vscode/chatLanguageModels.litellm.json). Se la porta non è 4000, sostituisci `4000` con `{{LITELLM_PORT}}`.
- [ ] Al prompt `litellmKey` inserisci la master key (profilo minimo) o una virtual key (profilo esteso).

**Esito atteso:** i modelli `LiteLLM · …` compaiono nel model picker.

### S-702 — Prova i modelli via LiteLLM
<!-- step: os=all path=all profile=all -->

- [ ] Chiedi la stessa cosa a `LiteLLM · Claude Sonnet (messages)`, `LiteLLM · Codex`, `LiteLLM · Gemini 4 Argon`.
- [ ] Confronta con le risposte dei modelli nativi (F6).
- [ ] ⚠️ Annota se `Authorization: Bearer ${apiKey}` funziona verso `/v1/messages`.

**Esito atteso:** tutti i modelli rispondono; nessun `401`.

### S-703 — Crea una virtual key per utente
<!-- step: os=all path=all profile=extended -->

```bash os=macos,debian,opensuse
printf 'Authorization: Bearer %s\n' "$LITELLM_MASTER_KEY" \
  | curl -s "http://localhost:{{LITELLM_PORT}}/key/generate" -H @- \
  -H "Content-Type: application/json" \
  -d '{"models": ["claude-sonnet", "gemini-pro"], "max_budget": 5, "metadata": {"user": "demo-wpc"}}'
```

```powershell os=windows
$body = @{ models = @('claude-sonnet','gemini-pro'); max_budget = 5; metadata = @{ user = 'demo-wpc' } } | ConvertTo-Json
Invoke-RestMethod -Method Post -Uri "http://localhost:{{LITELLM_PORT}}/key/generate" -Headers @{ Authorization = "Bearer $env:LITELLM_MASTER_KEY" } -ContentType 'application/json' -Body $body
```

**Esito atteso:** la risposta contiene `key`. ⚠️ Non incollare la chiave nelle evidenze: il sito oscura i valori `sk-…`.

## F8 — GitHub Spec Kit

### S-801 — Installa la CLI specify
<!-- step: os=all path=all profile=all -->

```bash os=all
uv tool install "specify-cli=={{SPECKIT_VERSION}}"
specify version
specify check
```

**Esito atteso:** `specify version` mostra `{{SPECKIT_VERSION}}` ([S-085](../Sources.md#s-085)).

### S-802 — Crea il progetto di prova con Copilot
<!-- step: os=all path=all profile=all -->

```bash os=all
specify init "{{SPECKIT_PROJECT}}" --integration copilot
cd "{{SPECKIT_PROJECT}}"
git status --short
```

**Esito atteso:** cartelle `.specify/` e `.github/skills/speckit-*/` ([S-083](../Sources.md#s-083)).

### S-803 — Controlla i file generati
<!-- step: os=all path=all profile=all -->

- [ ] Leggi gli script in `.specify/scripts/` e le skill in `.github/skills/` prima del primo commit ([04 AZ-10](../04-Security-Review-OWASP-ISO27001.md#9-azioni)).
- [ ] Apri la cartella in VS Code e concedi la fiducia solo dopo il controllo.

**Esito atteso:** nessun file inatteso.

### S-804 — Esegui il flusso spec-driven
<!-- step: os=all path=all profile=all -->

- [ ] Seleziona un modello BYOK con tool calling (nativo o `LiteLLM · …`).
- [ ] In chat: `/speckit-constitution`, `/speckit-specify`, `/speckit-plan`, `/speckit-tasks`, `/speckit-implement`.

**Esito atteso:** gli artefatti di specifica, piano e task sono creati nel progetto.

## F9 — Team di agenti

Questa fase installa e prova il team di agenti di [05-Team-Agenti](../05-Team-Agenti.md) in un repository **di prova**. È facoltativa.
⚠️ Ruleset, `CODEOWNERS`, CI e script non sono stati provati su GitHub ([D-039](../Decisions.md#d-039)): usa un repository di laboratorio.

### S-911 — Controlla i requisiti del team
<!-- step: os=all path=all profile=all -->

```bash os=all
git --version
gh --version
gh auth status
dotnet --version
pwsh --version
specify version
```

**Esito atteso:** .NET SDK 10, PowerShell 7.4 o successivo (su macOS e Linux installalo: il passo S-102 lo installa solo su Windows), Spec Kit `{{SPECKIT_VERSION}}`; `gh` ha un accesso valido ([05 §6](../05-Team-Agenti.md#6-installazione-del-team-in-un-repository)).

### S-912 — Crea il repository di prova con i rami GitFlow
<!-- step: os=all path=all profile=all -->

- [ ] Crea su GitHub il repository `{{GH_OWNER}}/{{GH_REPO}}` con un primo commit su `main`. Un'organizzazione permette il team di emergenza; con un account personale usa l'opzione `-WithoutEmergencyTeam` (passo S-918). Con il piano Free il repository deve essere pubblico.
- [ ] Clona il repository e crea i rami:

```bash os=all
gh repo clone "{{GH_OWNER}}/{{GH_REPO}}" "{{TEAM_PROJECT}}"
cd "{{TEAM_PROJECT}}"
git switch -c develop
git push -u origin develop
git switch -c feature/000-team-agenti
```

**Esito atteso:** `git branch --show-current` mostra `feature/000-team-agenti`; `develop` esiste su GitHub ([gitflow.md](../../examples/agents/docs/team/gitflow.md)).

### S-913 — Inizializza Spec Kit e l'estensione git
<!-- step: os=all path=all profile=all -->

```bash os=all
cd "{{TEAM_PROJECT}}"
specify init --here --force --integration copilot
specify extension add git
```

- [ ] Leggi gli script in `.specify/` prima del commit ([04 AZ-10](../04-Security-Review-OWASP-ISO27001.md#9-azioni)).

- [ ] Annota la versione di `specify version`: va nella ADR-001 del progetto (passo S-914).

**Esito atteso:** esistono `.specify/` e `.specify/extensions/git/git-config.yml`. ⚠️ Comando `specify extension add git` da provare ([D-040](../Decisions.md#d-040)).

### S-914 — Copia il template del team
<!-- step: os=all path=all profile=all -->

```bash os=macos,debian,opensuse
cp -R "{{REPO_DIR}}/examples/agents/." "{{TEAM_PROJECT}}/"
cd "{{TEAM_PROJECT}}"
grep -n 'branch_prefix' .specify/extensions/git/git-config.yml
ls .github/agents
```

```powershell os=windows
Copy-Item -Recurse -Force "{{REPO_DIR}}\examples\agents\*" "{{TEAM_PROJECT}}\"
Copy-Item -Recurse -Force "{{REPO_DIR}}\examples\agents\.github" "{{TEAM_PROJECT}}\"
Copy-Item -Recurse -Force "{{REPO_DIR}}\examples\agents\.specify" "{{TEAM_PROJECT}}\"
Copy-Item -Recurse -Force "{{REPO_DIR}}\examples\agents\.vscode" "{{TEAM_PROJECT}}\"
Copy-Item -Force "{{REPO_DIR}}\examples\agents\.mcp.json" "{{TEAM_PROJECT}}\"
Copy-Item -Force "{{REPO_DIR}}\examples\agents\.gitignore" "{{TEAM_PROJECT}}\"
Set-Location "{{TEAM_PROJECT}}"
Select-String -Path .specify\extensions\git\git-config.yml -Pattern 'branch_prefix'
Get-ChildItem .github\agents
```

- [ ] Apri `.github/CODEOWNERS` e sostituisci `@release-approver` con `@{{PO_USER}}`.
- [ ] Copia `docs/team/templates/decisions.md` in `docs/backlog/decisions.md` e scrivi nella ADR-001 la versione di Spec Kit ([D-044](../Decisions.md#d-044)).

**Esito atteso:** `branch_prefix: "feature"`; 10 file `.agent.md`; `.mcp.json` e `.vscode/mcp.json` esistono; `CODEOWNERS` contiene solo `* @{{PO_USER}}`; `docs/backlog/decisions.md` ha la ADR-001.

### S-915 — Configura VS Code per il team
<!-- step: os=all path=all profile=all -->

- [ ] Aggiungi nel Language Models editor i modelli del team ([05 §4](../05-Team-Agenti.md#4-modelli-e-costi)): Anthropic, OpenAI, OpenRouter.
- [ ] Attiva `chat.agentHost.byokModels.enabled` e `github.copilot.chat.cli.customAgents.enabled` ([05 §5](../05-Team-Agenti.md#5-vincoli-tecnici-di-vs-code)). Riavvia VS Code.
- [ ] Leggi `.mcp.json` (harness Copilot) e `.vscode/mcp.json` (harness Local). Attiva `chat.mcp.workspaceRootConfig.enabled`, poi avvia il server MCP `microsoft-learn` per il Cercatore. In Copilot CLI: `/plugin install microsoftdocs/mcp` ([S-188](../Sources.md#s-188)).
- [ ] Per ogni file in `.github/agents/` controlla il campo `model`: accetta l'ID che il completamento propone.
- [ ] Scegli per la sessione un modello BYOK, non **Auto**.

**Esito atteso:** il selettore degli agenti mostra **Organizzatore** e **Pianificatore**; le altre 8 figure non compaiono; il server `microsoft-learn` è avviato.

### S-916 — Crea la soluzione minima per la CI
<!-- step: os=all path=all profile=all -->

`ci.yml` richiede una soluzione .NET nella radice e almeno un test Pester in `tests/`. Salta questo passo se il repository li contiene già. Esegui i comandi in PowerShell 7 (`pwsh`) su ogni sistema; `Invoke-Pester` richiede il modulo Pester 6.

```powershell os=all
cd "{{TEAM_PROJECT}}"
dotnet new sln -n TeamDemo
dotnet new classlib -o src/TeamDemo
dotnet new nunit -o tests/TeamDemo.Tests
dotnet sln add src/TeamDemo tests/TeamDemo.Tests
dotnet add tests/TeamDemo.Tests reference src/TeamDemo
Set-Content -Path tests/Smoke.Tests.ps1 -Value 'Describe "Smoke" { It "runs" { $true | Should -BeTrue } }'
dotnet build
dotnet test
Invoke-Pester -Path tests
```

**Esito atteso:** `dotnet build` senza errori; `dotnet test` e `Invoke-Pester` senza test falliti. ⚠️ Da provare: il template `dotnet new nunit` con NUnit 5 e gli argomenti di `dotnet test` in `ci.yml` ([S-181](../Sources.md#s-181)).

### S-917 — Unisci il template in develop e porta la CI su main
<!-- step: os=all path=all profile=all -->

```bash os=all
cd "{{TEAM_PROJECT}}"
git add -A
git commit -m "chore: add the agent team template"
git push -u origin feature/000-team-agenti
gh pr create --base develop --title "chore: add the agent team template" --body "Template del team di agenti"
gh pr checks --watch
```

- [ ] Unisci la PR in `develop` con un merge commit. Apri una PR `develop` → `main` e uniscila.
- [ ] Aggiorna il clone locale:

```bash os=all
cd "{{TEAM_PROJECT}}"
git switch develop
git pull --ff-only
```

**Esito atteso:** i controlli `build`, `test-dotnet` e `test-powershell` hanno un'esecuzione verde su `develop` e su `main`. La soluzione del passo S-916 dà alla CI il codice da compilare e i test da eseguire.

### S-918 — Applica i ruleset
<!-- step: os=all path=all profile=all -->

Esegui questo passo con il tuo utente (permesso *Administration*), **mai** con l'identità dell'agente ([S-174](../Sources.md#s-174)).

- [ ] Organizzazione: crea in `{{GH_OWNER}}` il team `release-emergency` con il solo sostituto del PO. Lo script si ferma se il team non esiste.
- [ ] Account personale (piano Free o Pro): non c'è un team. Salta il secondo comando e aggiungi `-WithoutEmergencyTeam` ai due comandi dello script. Con il piano Free il repository deve essere pubblico ([05 §9.2](../05-Team-Agenti.md#92-piani-github-e-configurazione-free)).

```bash os=all
cd "{{TEAM_PROJECT}}"
gh api apps/github-actions --jq .id
gh api "orgs/{{GH_OWNER}}/teams/release-emergency" --jq .slug
pwsh -File ./scripts/Set-Rulesets.ps1 -Repository "{{GH_OWNER}}/{{GH_REPO}}" -WhatIf
pwsh -File ./scripts/Set-Rulesets.ps1 -Repository "{{GH_OWNER}}/{{GH_REPO}}"
gh api "repos/{{GH_OWNER}}/{{GH_REPO}}/rules/branches/main" --jq '.[].type'
gh api "repos/{{GH_OWNER}}/{{GH_REPO}}/rules/branches/develop" --jq '.[].type'
```

**Esito atteso:** il primo comando mostra l'ID usato in `integration_id` (atteso `15368` ⚠️); `main` ha le regole `deletion`, `non_fast_forward`, `pull_request`, `required_status_checks`. Da questo momento ogni PR verso `main` e verso `develop` richiede la tua approvazione. In un'organizzazione il secondo comando mostra `release-emergency`. `develop` ha le stesse quattro regole di `main`.

### S-919 — Configura l'identità dell'agente
<!-- step: os=all path=all profile=all evidence=no-output -->

L'Organizzatore deve usare `git` e `gh` con un'identità diversa dalla tua: GitHub non accetta l'approvazione dell'autore sulla propria PR, quindi con il tuo utente non potresti approvare le PR dell'agente ([gitflow.md](../../examples/agents/docs/team/gitflow.md#identità-dellagente)).

- [ ] Crea l'identità: una GitHub App installata sul repository, oppure un account di servizio aggiunto come collaboratore. Permessi: *Contents* e *Pull requests* in scrittura. Nessun permesso *Administration*, nessun permesso *Workflows*.
- [ ] Genera il token dell'identità. Non scriverlo in un file del repository e non incollarlo nella chat.
- [ ] Apri un terminale nuovo, imposta la variabile `GH_TOKEN` con il token e avvia VS Code da quel terminale: l'agente eredita la variabile.
- [ ] In quel terminale controlla l'identità:

```bash os=all
cd "{{TEAM_PROJECT}}"
gh auth status
gh auth setup-git
gh api "repos/{{GH_OWNER}}/{{GH_REPO}}" --jq .permissions
```

- [ ] Tieni il tuo utente `{{PO_USER}}` nel browser: lo usi per approvare le PR.

**Esito atteso:** `gh auth status` mostra il token di `GH_TOKEN` e non il tuo utente; i permessi mostrano `push: true` e `admin: false`. Il sito non salva l'output di questo passo. ⚠️ Da provare: token di una GitHub App con `gh`, e identità di servizio in un repository di un account personale.

### S-920 — Pianifica con il Pianificatore
<!-- step: os=all path=all profile=all -->

- [ ] Controlla che il ramo corrente sia `develop` aggiornato (`git status -sb`).
- [ ] Seleziona l'agente **Pianificatore** e descrivi una Feature piccola.
- [ ] Il Pianificatore controlla la versione di Spec Kit: se ti chiede di aggiornare, rispondi; con il sì controlla la ADR nuova in `docs/backlog/decisions.md`.
- [ ] Rispondi alle domande; leggi il what-if dell'Avversario (al massimo 2 alternative). Chiedi un fatto tecnico su C#: il Pianificatore chiama il Cercatore, che risponde con fonti di Microsoft Learn.
- [ ] Di' al Pianificatore che le scelte sono complete.
- [ ] Controlla `docs/backlog/`: ogni `epic.md` e `feature.md` apre con l'obiettivo di completamento e ha la tabella **Definition of Done** con tutte le voci standard.
- [ ] Controlla un Task: i criteri di accettazione hanno la forma «Dato…, quando…, allora…» e il campo **Verifica**.

```bash os=macos,debian,opensuse
cd "{{TEAM_PROJECT}}"
git branch --show-current
grep -rn "DoD-F9\|DoD-E8" docs/backlog
```

```powershell os=windows
Set-Location "{{TEAM_PROJECT}}"
git branch --show-current
Get-ChildItem -Recurse -File docs/backlog | Select-String -Pattern 'DoD-F9|DoD-E8'
```

**Esito atteso:** il ramo ha la forma `feature/<NNN>-<slug>`; la ricerca trova le ultime voci standard in ogni `feature.md` ed `epic.md` ([D-038](../Decisions.md#d-038)).

### S-921 — Sviluppa una Feature con l'Organizzatore
<!-- step: os=all path=all profile=all -->

- [ ] Seleziona l'agente **Organizzatore** e chiedi di sviluppare la Feature.
- [ ] Controlla l'ordine: Tester (*red*), Sviluppatore o Operativo (*green*), Scrittore.
- [ ] Controlla che l'Organizzatore compili la colonna **Evidenza** prima di chiamare i Reviewer.
- [ ] Controlla la risposta dei due Reviewer: una riga per ogni voce controllata, da DoD-F1 a DoD-F6.
- [ ] Incolla nell'output del passo la tabella **Definition of Done** di `feature.md`.

```bash os=all
cd "{{TEAM_PROJECT}}"
dotnet test
gh pr list --state all --limit 5
```

- [ ] Approva la PR su GitHub quando l'Organizzatore te la presenta: prima della tua approvazione il merge deve fallire.

**Esito atteso:** test verdi; la PR è unita in `develop` solo con le voci da DoD-F1 a DoD-F7 soddisfatte e con evidenza, dopo la tua approvazione.

### S-922 — Verifica i rifiuti di GitHub
<!-- step: os=all path=all profile=all -->

⚠️ Esegui questo passo solo nel repository di laboratorio.

```bash os=all
cd "{{TEAM_PROJECT}}"
git switch develop
git pull --ff-only
git commit --allow-empty -m "test: direct push must be rejected"
git push origin develop
git reset --hard origin/develop
```

- [ ] Con l'identità dell'agente del passo S-919 prova `gh pr merge <numero> --merge --admin` su una PR verso `main` senza la tua approvazione.

**Esito atteso:** GitHub rifiuta il push diretto con un messaggio che nomina la regola del repository (non un errore *non-fast-forward* di git) e rifiuta il merge con `--admin`; la PR resta aperta ([S-175](../Sources.md#s-175), [esempio](../../examples/speckit-ruleset/README.md)).

## F10 — Chiusura

### S-1001 — Revoca le chiavi della demo
<!-- step: os=all path=all profile=all -->

- [ ] Revoca le chiavi dei provider usate per la demo nelle rispettive console.
- [ ] Profilo esteso: revoca le virtual keys di prova dall'Admin UI.
- [ ] Fase F9: revoca il token dell'identità dell'agente e cancella il repository di laboratorio, se non serve più.
- [ ] Ferma il proxy (`docker compose … down`, `systemctl --user stop litellm`, `launchctl bootout …`, `Stop-ScheduledTask …`).

**Esito atteso:** nessuna chiave della demo resta valida.

### S-1002 — Esporta le evidenze
<!-- step: os=all path=all profile=all -->

- [ ] Nel sito: **Esporta evidenze (Markdown)** e **Esporta sessione (JSON)**.
- [ ] Controlla che le evidenze non contengano segreti.

**Esito atteso:** due file con data, operatore, parametri ed esito di ogni passo.
