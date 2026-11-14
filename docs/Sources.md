# Sources — Fonti documentali

Questo file contiene l'elenco delle fonti documentali del repository.
Ogni fonte ha un identificativo stabile (`S-NNN`) e un'ancora.
Gli altri documenti puntano alla fonte con un link del tipo `Sources.md#s-001`.

**Regole d'uso**

- Usa sempre il link all'ancora, non l'URL diretto, nei documenti in `docs/`.
- Non cambia l'identificativo di una fonte. Se una fonte non è più valida, segna lo stato `Obsoleta` e aggiungi una nuova fonte.
- La colonna **Verifica** indica la data di consultazione. Il simbolo ⚠️ indica un contenuto non verificato completamente.

**Tag di tipologia**: `[PRIMARY]` documentazione ufficiale del prodotto; `[VENDOR-DOC]` documentazione di vendor di terze parti; `[OPINION]` articolo secondario.

**Verifica**: data di consultazione diretta. `P-NN` indica una fonte trovata dalla review Perplexity ([Review-Perplexity.md](Review-Perplexity.md)) e non riletta dall'assistente.

---

## Visual Studio Code e GitHub Copilot

| ID | Titolo | Tipo | Verifica |
|----|--------|------|----------|
| <a id="s-001"></a>S-001 | [VS Code — Bring your own language model key (Language models)](https://code.visualstudio.com/docs/copilot/customization/language-models) | PRIMARY | 2026-11-07 |
| <a id="s-002"></a>S-002 | [VS Code — Customize AI in Visual Studio Code (overview)](https://code.visualstudio.com/docs/copilot/customization/overview) | PRIMARY | 2026-11-07 |
| <a id="s-003"></a>S-003 | [VS Code — Custom instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions) | PRIMARY | 2026-11-07 |
| <a id="s-004"></a>S-004 | [VS Code — Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills) | PRIMARY | 2026-11-07 |
| <a id="s-005"></a>S-005 | [VS Code — MCP servers](https://code.visualstudio.com/docs/copilot/customization/mcp-servers) | PRIMARY | 2026-11-07 |
| <a id="s-006"></a>S-006 | [VS Code — Hooks](https://code.visualstudio.com/docs/copilot/customization/hooks) | PRIMARY | 2026-11-07 |
| <a id="s-007"></a>S-007 | [VS Code — Custom agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents) | PRIMARY | 2026-11-07 |
| <a id="s-008"></a>S-008 | [VS Code — Agents overview](https://code.visualstudio.com/docs/copilot/agents/overview) | PRIMARY | 2026-11-07 |
| <a id="s-009"></a>S-009 | [VS Code — Visual Studio Code on Linux](https://code.visualstudio.com/docs/setup/linux) | PRIMARY | 2026-11-07 |
| <a id="s-010"></a>S-010 | [VS Code — Visual Studio Code on Windows](https://code.visualstudio.com/docs/setup/windows) | PRIMARY | 2026-11-07 |
| <a id="s-011"></a>S-011 | [VS Code — Visual Studio Code on macOS](https://code.visualstudio.com/docs/setup/mac) | PRIMARY | 2026-11-07 |
| <a id="s-012"></a>S-012 | [Microsoft Learn — install command (winget)](https://learn.microsoft.com/windows/package-manager/winget/install) | PRIMARY | 2026-11-07 |
| <a id="s-013"></a>S-013 | [Microsoft Learn — Set up your Python development environment on Windows (`winget install Microsoft.VisualStudioCode`)](https://learn.microsoft.com/windows/dev-environment/python) | PRIMARY | 2026-11-07 |
| <a id="s-014"></a>S-014 | [Homebrew Formulae — cask `visual-studio-code`](https://formulae.brew.sh/cask/visual-studio-code) | VENDOR-DOC | 2026-11-07 |
| <a id="s-015"></a>S-015 | [GitHub Docs — Bring your own key (BYOK)](https://docs.github.com/en/copilot/concepts/models/bring-your-own-key) | PRIMARY | 2026-11-07 |
| <a id="s-016"></a>S-016 | [GitHub Docs — Managing policies and features for GitHub Copilot in your organization](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-organization/manage-policies) | PRIMARY | 2026-11-07 |
| <a id="s-017"></a>S-017 | [GitHub Docs — GitHub flow](https://docs.github.com/en/get-started/using-github/github-flow) | PRIMARY | 2026-11-07 ⚠️ |
| <a id="s-018"></a>S-018 | [GitHub Changelog — Bring your own language model key in VS Code now available (2026-04-22)](https://github.blog/changelog/2026-04-22-bring-your-own-language-model-key-in-vs-code-now-available/) | PRIMARY | 2026-11-07 |
| <a id="s-019"></a>S-019 | [GitHub Docs — Enabling custom models for GitHub Copilot in your enterprise](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/enable-custom-models) | PRIMARY | P-02 |
| <a id="s-068"></a>S-068 | [VS Code — Choose an agent harness](https://code.visualstudio.com/docs/agents/run/agent-harnesses) | PRIMARY | 2026-11-07 |
| <a id="s-069"></a>S-069 | [VS Code — Custom instructions reference](https://code.visualstudio.com/docs/agents/reference/custom-instructions-reference) | PRIMARY | 2026-11-07 |
| <a id="s-070"></a>S-070 | [VS Code — Release notes 1.122 (Custom Endpoint in Stable, provider built-in)](https://code.visualstudio.com/updates/v1_122) | PRIMARY | P-01 |
| <a id="s-071"></a>S-071 | [VS Code — AI language models (nuovo percorso agent-customization)](https://code.visualstudio.com/docs/agent-customization/language-models) | PRIMARY | 2026-11-07 |
| <a id="s-072"></a>S-072 | [VS Code — Custom agent file reference](https://code.visualstudio.com/docs/agents/reference/custom-agent-file-reference) | PRIMARY | P-03 |
| <a id="s-073"></a>S-073 | [GitHub Docs — GitHub Copilot hooks reference](https://docs.github.com/en/copilot/reference/hooks-reference) | PRIMARY | P-03 |
| <a id="s-074"></a>S-074 | [microsoft/vscode issue #329089 — percorso di `chatLanguageModels.json` e profili](https://github.com/microsoft/vscode/issues/329089) | PRIMARY | P-01 |
| <a id="s-075"></a>S-075 | [microsoft/vscode issue #342875 — formato `vendor/id` dei modelli di utilità](https://github.com/microsoft/vscode/issues/342875) | PRIMARY | P-01 |
| <a id="s-076"></a>S-076 | [microsoft/vscode issue #326797 — Plan/Agent con `customendpoint`](https://github.com/microsoft/vscode/issues/326797) | PRIMARY | P-08 |
| <a id="s-077"></a>S-077 | [microsoft/vscode issue #332085 — BYOK custom endpoint non selezionabile (WSL/SSH/Dev Container)](https://github.com/microsoft/vscode/issues/332085) | PRIMARY | P-08 |
| <a id="s-100"></a>S-100 | [GitHub Changelog — Updates to GitHub Copilot billing and plans (2026-06-01)](https://github.blog/changelog/2026-06-01-updates-to-github-copilot-billing-and-plans/) | PRIMARY | P-02 |
| <a id="s-101"></a>S-101 | [GitHub Docs — Supported surfaces for GitHub Copilot policies](https://docs.github.com/en/copilot/reference/supported-surfaces-for-policies) | PRIMARY | P-02 |

## LiteLLM

| ID | Titolo | Tipo | Verifica |
|----|--------|------|----------|
| <a id="s-020"></a>S-020 | [LiteLLM — Docker quick start](https://docs.litellm.ai/docs/proxy/docker_quick_start) | PRIMARY | 2026-11-07 |
| <a id="s-021"></a>S-021 | [LiteLLM — CLI quick start (uv tool install)](https://docs.litellm.ai/docs/proxy/quick_start) | PRIMARY | 2026-11-07 |
| <a id="s-022"></a>S-022 | [LiteLLM — Proxy config.yaml](https://docs.litellm.ai/docs/proxy/configs) | PRIMARY | 2026-11-07 |
| <a id="s-023"></a>S-023 | [LiteLLM — Production deployment (image, health, DATABASE_URL)](https://docs.litellm.ai/docs/proxy/deploy) | PRIMARY | 2026-11-07 |
| <a id="s-024"></a>S-024 | [LiteLLM — Provider Anthropic](https://docs.litellm.ai/docs/providers/anthropic) | PRIMARY | 2026-11-07 |
| <a id="s-025"></a>S-025 | [LiteLLM — Provider Gemini (Google AI Studio)](https://docs.litellm.ai/docs/providers/gemini) | PRIMARY | 2026-11-07 |
| <a id="s-026"></a>S-026 | [LiteLLM — Provider OpenRouter](https://docs.litellm.ai/docs/providers/openrouter) | PRIMARY | 2026-11-07 |
| <a id="s-027"></a>S-027 | [LiteLLM — Provider Hugging Face](https://docs.litellm.ai/docs/providers/huggingface) | PRIMARY | 2026-11-07 |
| <a id="s-028"></a>S-028 | [LiteLLM — `/v1/messages` (Anthropic unified format)](https://docs.litellm.ai/docs/anthropic_unified) | PRIMARY | 2026-11-07 |
| <a id="s-029"></a>S-029 | [LiteLLM — `/v1/responses` (OpenAI Responses API)](https://docs.litellm.ai/docs/response_api) | PRIMARY | 2026-11-07 |
| <a id="s-030"></a>S-030 | [LiteLLM — Production checklist](https://docs.litellm.ai/docs/proxy/prod) | PRIMARY | ⚠️ non consultata |
| <a id="s-104"></a>S-104 | [LiteLLM — Incident: release v1.107.0 (2026-10-21)](https://docs.litellm.ai/blog/security-incident-oct-21-2026) | PRIMARY | 2026-11-07 |
| <a id="s-105"></a>S-105 | [LiteLLM — Security Update: supply chain incident (marzo 2026, 1.82.7/1.82.8)](https://docs.litellm.ai/blog/security-update-march-2026) | PRIMARY | P-04 |
| <a id="s-106"></a>S-106 | [NVD — CVE-2026-114612 (LiteLLM, CVSS 9.9)](https://nvd.nist.gov/vuln/detail/CVE-2026-114612) | PRIMARY | P-08 |
| <a id="s-107"></a>S-107 | [Check Point Research — When LLM Gateways Go Wrong: Findings from LiteLLM](https://research.checkpoint.com/2026/when-llm-gateways-go-wrong-findings-from-litellm/) | OPINION | P-08 |
| <a id="s-108"></a>S-108 | [LiteLLM — Security Best Practices](https://docs.litellm.ai/docs/proxy/security_best_practices) | PRIMARY | P-08 |
| <a id="s-109"></a>S-109 | [LiteLLM — Docker Image Security Guide (cosign)](https://docs.litellm.ai/docs/proxy/docker_image_security) | PRIMARY | P-04 |
| <a id="s-110"></a>S-110 | [LiteLLM — Thinking / Reasoning Content](https://docs.litellm.ai/docs/reasoning_content) | PRIMARY | 2026-11-07 |
| <a id="s-111"></a>S-111 | [BerriAI/litellm issue #35775 — incompatibilità con la discovery dei modelli di VS Code](https://github.com/BerriAI/litellm/issues/35775) | PRIMARY | P-08 |
| <a id="s-117"></a>S-117 | [LiteLLM — Health Checks](https://docs.litellm.ai/docs/proxy/health) | PRIMARY | P-04 |
| <a id="s-118"></a>S-118 | [LiteLLM — CLI Arguments (`--host`, `--port`)](https://docs.litellm.ai/docs/proxy/cli) | PRIMARY | P-04 |
| <a id="s-119"></a>S-119 | [LiteLLM — Release notes v1.108.2 (LTS)](https://docs.litellm.ai/release_notes/v1.108.2/v1-108-2) | PRIMARY | P-04 |
| <a id="s-120"></a>S-120 | [LiteLLM — OpenAI Responses API provider (`openai/responses/`)](https://docs.litellm.ai/docs/providers/openai/responses_api) | PRIMARY | P-05 |
| <a id="s-031"></a>S-031 | [LiteLLM — Virtual keys](https://docs.litellm.ai/docs/proxy/virtual_keys) | PRIMARY | ⚠️ non consultata |
| <a id="s-182"></a>S-182 | [LiteLLM — Getting started (SDK, Proxy, feature del gateway)](https://docs.litellm.ai/docs/) | PRIMARY | 2026-11-14 |
| <a id="s-183"></a>S-183 | [LiteLLM — Enterprise features](https://docs.litellm.ai/docs/proxy/enterprise) | PRIMARY | 2026-11-14 |
| <a id="s-184"></a>S-184 | [LiteLLM — LTS pilot (linea 1.108, tag `lts`)](https://docs.litellm.ai/docs/enterprise/lts_pilot) | PRIMARY | 2026-11-14 |
| <a id="s-185"></a>S-185 | [LiteLLM — Release cycle](https://docs.litellm.ai/docs/proxy/release_cycle) | PRIMARY | 2026-11-14 ⚠️ (letto solo l'estratto della ricerca) |
| <a id="s-186"></a>S-186 | [LiteLLM — Release versioning is changing (nomi dalla 1.84.0, tag `latest`)](https://docs.litellm.ai/blog/cleaner-release-versions) | PRIMARY | 2026-11-14 ⚠️ (letto solo l'estratto della ricerca) |
| <a id="s-187"></a>S-187 | [LiteLLM — Release cadence changes and an LTS version pilot](https://docs.litellm.ai/blog/release-cadence-and-lts-pilot) | PRIMARY | 2026-11-14 ⚠️ (letto solo l'estratto della ricerca) |

## Provider LLM

| ID | Titolo | Tipo | Verifica |
|----|--------|------|----------|
| <a id="s-040"></a>S-040 | [Anthropic — Models overview](https://platform.claude.com/docs/en/about-claude/models/overview) | PRIMARY | 2026-11-07 |
| <a id="s-041"></a>S-041 | [Anthropic — Messages API reference](https://platform.claude.com/docs/en/api/messages) | PRIMARY | P-05 |
| <a id="s-116"></a>S-116 | [Anthropic — API versions (`2026-10-21`)](https://platform.claude.com/docs/en/api/versioning) | PRIMARY | 2026-11-07 |
| <a id="s-042"></a>S-042 | [OpenAI — Codex models (redirect da developers.openai.com/codex/models)](https://learn.chatgpt.com/docs/models) | PRIMARY | 2026-11-07 ⚠️ |
| <a id="s-043"></a>S-043 | [OpenAI — Responses API reference](https://developers.openai.com/api/reference/resources/responses) | PRIMARY | P-05 |
| <a id="s-102"></a>S-102 | [OpenAI — All models (stato dei modelli Codex)](https://developers.openai.com/api/docs/models/all) | PRIMARY | P-05 |
| <a id="s-044"></a>S-044 | [Google — Gemini API models](https://ai.google.dev/gemini-api/docs/models) | PRIMARY | 2026-11-07 |
| <a id="s-103"></a>S-103 | [Google — Gemini 4 Argon](https://ai.google.dev/gemini-api/docs/models/gemini-4-argon) | PRIMARY | 2026-11-07 |
| <a id="s-045"></a>S-045 | [Google — Gemini API OpenAI compatibility](https://ai.google.dev/gemini-api/docs/openai) | PRIMARY | 2026-11-07 |
| <a id="s-046"></a>S-046 | [OpenRouter — Quickstart](https://openrouter.ai/docs/quickstart) | PRIMARY | P-05 |
| <a id="s-121"></a>S-121 | [OpenRouter — App Attribution (`HTTP-Referer`, `X-OpenRouter-Title`)](https://openrouter.ai/docs/app-attribution) | PRIMARY | P-05 |
| <a id="s-047"></a>S-047 | [Hugging Face — Inference Providers (router OpenAI-compatible)](https://huggingface.co/docs/inference-providers/index) | PRIMARY | 2026-11-07 |
| <a id="s-048"></a>S-048 | [Hugging Face — Use Inference Providers with GitHub Copilot Chat in VS Code](https://huggingface.co/docs/inference-providers/guides/vscode) | PRIMARY | 2026-11-07 |
| <a id="s-049"></a>S-049 | [Hugging Face — repository `huggingface-vscode-chat`](https://github.com/huggingface/huggingface-vscode-chat) | PRIMARY | 2026-11-07 |

## Strumenti di base (uv, Docker)

| ID | Titolo | Tipo | Verifica |
|----|--------|------|----------|
| <a id="s-060"></a>S-060 | [Astral — Installing uv](https://docs.astral.sh/uv/getting-started/installation/) | PRIMARY | 2026-11-07 |
| <a id="s-061"></a>S-061 | [Docker — Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/) | PRIMARY | 2026-11-07 |
| <a id="s-062"></a>S-062 | [Docker — Install Docker Engine on Debian](https://docs.docker.com/engine/install/debian/) | PRIMARY | P-06 |
| <a id="s-063"></a>S-063 | [Docker — Linux post-installation steps](https://docs.docker.com/engine/install/linux-postinstall/) | PRIMARY | ⚠️ non consultata |
| <a id="s-064"></a>S-064 | [openSUSE Wiki — Docker](https://en.opensuse.org/Docker) | PRIMARY | 2026-11-07 |
| <a id="s-065"></a>S-065 | [Homebrew Formulae — cask `docker-desktop`](https://formulae.brew.sh/cask/docker-desktop) | VENDOR-DOC | 2026-11-07 |
| <a id="s-066"></a>S-066 | [Docker — Install Docker Desktop on Windows](https://docs.docker.com/desktop/setup/install/windows-install/) | PRIMARY | P-06 |
| <a id="s-067"></a>S-067 | [openSUSE News — Leap 16 Enters Beta (YaST → Agama, Cockpit, Myrlyn)](https://news.opensuse.org/2025/04/30/leap-16-enters-beta/) | PRIMARY | P-06 |
| <a id="s-122"></a>S-122 | [Homebrew Formulae — formula `uv`](https://formulae.brew.sh/formula/uv) | VENDOR-DOC | P-06 |
| <a id="s-190"></a>S-190 | [Microsoft Learn — Install PowerShell 7 on macOS](https://learn.microsoft.com/en-us/powershell/scripting/install/install-powershell-on-macos) | PRIMARY | 2026-11-14 |
| <a id="s-191"></a>S-191 | [Microsoft Learn — Alternate ways to install PowerShell (Homebrew, .NET global tool)](https://learn.microsoft.com/powershell/scripting/install/alternate-install-methods) | PRIMARY | 2026-11-14 |
| <a id="s-192"></a>S-192 | [Microsoft Learn — Install PowerShell 7 on Ubuntu](https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu) | PRIMARY | 2026-11-14 |
| <a id="s-193"></a>S-193 | [Microsoft Learn — Install PowerShell 7 on Debian](https://learn.microsoft.com/en-us/powershell/scripting/install/install-debian) | PRIMARY | 2026-11-14 |
| <a id="s-194"></a>S-194 | [Microsoft Learn — Community support for PowerShell on Linux (SLES e openSUSE)](https://learn.microsoft.com/powershell/scripting/install/community-support) | PRIMARY | 2026-11-14 |

## GitHub Spec Kit

| ID | Titolo | Tipo | Verifica |
|----|--------|------|----------|
| <a id="s-080"></a>S-080 | [GitHub — Spec Kit (repository)](https://github.com/github/spec-kit) | PRIMARY | 2026-11-07 |
| <a id="s-081"></a>S-081 | [GitHub — Spec Kit Installation](https://github.github.io/spec-kit/installation.html) | PRIMARY | 2026-11-07 |
| <a id="s-082"></a>S-082 | [GitHub — Spec Kit integrations CLI reference](https://github.github.io/spec-kit/integrations/cli.html) | PRIMARY | P-07 |
| <a id="s-083"></a>S-083 | [GitHub — Spec Kit: integrazione GitHub Copilot (layout skills/commands)](https://github.github.io/spec-kit/integrations/copilot.html) | PRIMARY | 2026-11-07 |
| <a id="s-084"></a>S-084 | [GitHub — Spec Kit Core Commands (`specify check`)](https://github.github.com/spec-kit/reference/core.html) | PRIMARY | 2026-11-07 (`github.github.com` è il dominio Pages di GitHub; verificato) |
| <a id="s-085"></a>S-085 | [GitHub — Spec Kit Releases (v1.3.2 per P-07; v1.4.0 per P-13)](https://github.com/github/spec-kit/releases) | PRIMARY | P-07, P-13; 2026-11-14 ⚠️ rilettura diretta non conclusiva |

## Gateway alternativi

| ID | Titolo | Tipo | Verifica |
|----|--------|------|----------|
| <a id="s-112"></a>S-112 | [Portkey — Universal API](https://portkey.ai/docs/product/ai-gateway/universal-api) | VENDOR-DOC | P-08 |
| <a id="s-113"></a>S-113 | [Cloudflare AI Gateway — REST API](https://developers.cloudflare.com/ai-gateway/usage/rest-api/) | VENDOR-DOC | P-08 |
| <a id="s-114"></a>S-114 | [Microsoft — GitHub-Copilot-BYOK-with-APIM (APIM + Foundry)](https://github.com/microsoft/GitHub-Copilot-BYOK-with-APIM) | VENDOR-DOC | P-08 |
| <a id="s-115"></a>S-115 | [OpenRouter — Guardrails (budget, allowlist, ZDR)](https://openrouter.ai/docs/guides/features/guardrails) | VENDOR-DOC | P-08 |

## Security

| ID | Titolo | Tipo | Verifica |
|----|--------|------|----------|
| <a id="s-130"></a>S-130 | [VS Code — Security considerations for AI in VS Code](https://code.visualstudio.com/docs/copilot/security) | PRIMARY | 2026-11-07 |
| <a id="s-131"></a>S-131 | [VS Code — Manage AI settings in enterprise environments](https://code.visualstudio.com/docs/enterprise/manage-ai-settings) | PRIMARY | 2026-11-07 |
| <a id="s-132"></a>S-132 | [VS Code — Enterprise policy reference](https://code.visualstudio.com/docs/enterprise/policies) | PRIMARY | ⚠️ non consultata |
| <a id="s-133"></a>S-133 | [VS Code — Workspace Trust](https://code.visualstudio.com/docs/editing/workspaces/workspace-trust) | PRIMARY | 2026-11-07 |
| <a id="s-134"></a>S-134 | [GitHub Docs — Excluding content from GitHub Copilot](https://docs.github.com/en/copilot/how-tos/configure-content-exclusion/exclude-content-from-copilot) | PRIMARY | 2026-11-07 |
| <a id="s-137"></a>S-137 | [OWASP — Top 10 for LLM Applications 2025 (edizione precedente)](https://genai.owasp.org/llm-top-10/) | PRIMARY | 2026-11-07 |
| <a id="s-138"></a>S-138 | [OWASP — Top 10 for Agentic Applications for 2026](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/) | PRIMARY | P-10 (titoli dal PDF ufficiale) |
| <a id="s-139"></a>S-139 | [OWASP — MCP Top 10](https://owasp.org/www-project-mcp-top-10/) | PRIMARY | ⚠️ non consultata |
| <a id="s-140"></a>S-140 | [ISO — ISO/IEC 27001:2022 Information security management systems — Requirements](https://www.iso.org/standard/27001) | PRIMARY | 2026-11-07 (solo scheda; testo della norma non riprodotto) |
| <a id="s-141"></a>S-141 | [ISO — ISO/IEC 27001:2022/Amd 1:2024 (Climate action changes)](https://www.iso.org/standard/88435.html) | PRIMARY | ⚠️ non consultata |
| <a id="s-142"></a>S-142 | [VS Code — Extension runtime security](https://code.visualstudio.com/docs/configure/extensions/extension-runtime-security) | PRIMARY | ⚠️ non consultata |
| <a id="s-144"></a>S-144 | [freedesktop.org — systemd.exec (sandboxing options)](https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html) | PRIMARY | ⚠️ non consultata |
| <a id="s-145"></a>S-145 | [VS Code — Sandbox Copilot agent sessions](https://code.visualstudio.com/docs/agents/run/agent-sandboxing) | PRIMARY | 2026-11-07 |
| <a id="s-146"></a>S-146 | [OWASP — GenAI LLM Top 10 2026 (2026-08-03)](https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/) | PRIMARY | 2026-11-07 |
| <a id="s-147"></a>S-147 | [OWASP — repository GenAI-LLM-Top10 (elenco 2026)](https://github.com/GenAI-Security-Project/GenAI-LLM-Top10) | PRIMARY | 2026-11-07 |
| <a id="s-148"></a>S-148 | [LiteLLM — Admin UI Quick Start (primo proxy_admin, break-glass)](https://docs.litellm.ai/docs/proxy/ui) | PRIMARY | 2026-11-07 |
| <a id="s-149"></a>S-149 | [ISO — ISO/IEC 42001:2023 AI management systems](https://www.iso.org/standard/42001) | PRIMARY | P-10 |
| <a id="s-150"></a>S-150 | [ISO — ISO/IEC 27000:2026](https://www.iso.org/standard/27000) | PRIMARY | P-10 |
| <a id="s-151"></a>S-151 | [OpenRouter — Provider routing (`provider.data_collection`, `allow_fallbacks`)](https://openrouter.ai/docs/guides/routing/provider-selection) | PRIMARY | ⚠️ non consultata |

## Sito offline (runbook, font, evidenze)

| ID | Titolo | Tipo | Verifica |
|----|--------|------|----------|
| <a id="s-152"></a>S-152 | [Nerd Fonts — release (zip delle famiglie)](https://github.com/ryanoasis/nerd-fonts/releases) | PRIMARY | 2026-11-07 (download diretto da provare sul Mac del PO) |
| <a id="s-153"></a>S-153 | [Nerd Fonts — repository e cartella `patched-fonts/` (licenze per famiglia)](https://github.com/ryanoasis/nerd-fonts) | PRIMARY | 2026-11-07 |
| <a id="s-154"></a>S-154 | [highlight.js 11.12.0 — CDN assets (file locali del sito)](https://github.com/highlightjs/cdn-release) | PRIMARY | 2026-11-07 |
| <a id="s-155"></a>S-155 | [Python-Markdown — documentazione ed estensioni](https://python-markdown.github.io/) | PRIMARY | 2026-11-07 |
| <a id="s-156"></a>S-156 | [fontTools — conversione in WOFF2 (`flavor="woff2"`)](https://fonttools.readthedocs.io/en/latest/ttLib/woff2.html) | PRIMARY | 2026-11-07 |
| <a id="s-157"></a>S-157 | [MDN — Window.localStorage](https://developer.mozilla.org/docs/Web/API/Window/localStorage) | VENDOR-DOC | 2026-11-07 |
| <a id="s-158"></a>S-158 | [PostgreSQL — Download per Windows (installer EDB)](https://www.postgresql.org/download/windows/) | PRIMARY | 2026-11-07 (ID winget `PostgreSQL.PostgreSQL.<NN>` ⚠️ da verificare con `winget search`) |
| <a id="s-159"></a>S-159 | [PostgreSQL — Download per macOS (Homebrew `postgresql@NN`)](https://www.postgresql.org/download/macosx/) | PRIMARY | 2026-11-07 |
| <a id="s-160"></a>S-160 | [PostgreSQL — Download per Ubuntu e Debian (repository PGDG, script `apt.postgresql.org.sh`)](https://www.postgresql.org/download/linux/ubuntu/) | PRIMARY | 2026-11-07 |
| <a id="s-161"></a>S-161 | [PostgreSQL — Download per SUSE / openSUSE](https://www.postgresql.org/download/linux/suse/) e [openSUSE — SDB:PostgreSQL](https://en.opensuse.org/SDB:PostgreSQL) | PRIMARY | 2026-11-07 (inizializzazione ⚠️ da provare) |
| <a id="s-162"></a>S-162 | [PostgreSQL — Connections and Authentication (`listen_addresses`) e ALTER SYSTEM](https://www.postgresql.org/docs/current/runtime-config-connection.html) | PRIMARY | 2026-11-07 |
| <a id="s-163"></a>S-163 | [PostgreSQL — The pg_hba.conf File (`scram-sha-256`)](https://www.postgresql.org/docs/current/auth-pg-hba-conf.html) | PRIMARY | 2026-11-07 |
| <a id="s-164"></a>S-164 | [Mermaid — documentazione e API `mermaid.run`, `securityLevel`](https://mermaid.js.org/config/usage.html) | PRIMARY | 2026-11-07 (pacchetto npm `mermaid@12.3.0`, MIT) |

## Team di agenti

| ID | Titolo | Tipo | Verifica |
|----|--------|------|----------|
| <a id="s-165"></a>S-165 | [VS Code — Subagents (contesto isolato, modelli, nesting, coordinatore e worker)](https://code.visualstudio.com/docs/copilot/agents/subagents) | PRIMARY | 2026-11-14 |
| <a id="s-166"></a>S-166 | [OpenRouter — Best AI Models for Coding (classifica per uso, prezzi)](https://openrouter.ai/collections/programming) | VENDOR-DOC | 2026-11-14 ⚠️ (letto solo l'estratto della ricerca; prezzi variabili) |
| <a id="s-167"></a>S-167 | [V. Driessen — A successful Git branching model (GitFlow)](https://nvie.com/posts/a-successful-git-branching-model/) | PRIMARY | 2026-11-14 (trovata da P-13) |
| <a id="s-168"></a>S-168 | [NUnit — Documentation](https://docs.nunit.org/) | PRIMARY | P-13 (2026-11-14) |
| <a id="s-169"></a>S-169 | [Pester — Documentation](https://pester.dev/docs/quick-start) | PRIMARY | P-13 (2026-11-14) |
| <a id="s-170"></a>S-170 | [Scrum Guide 2020 — Commitment: Definition of Done](https://www.scrumguides.org/scrum-guide.html) | PRIMARY | 2026-11-14 ⚠️ (letto solo l'estratto della ricerca) |
| <a id="s-171"></a>S-171 | [GitHub Docs — About rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets) | PRIMARY | 2026-11-14 (trovata da P-13) |
| <a id="s-172"></a>S-172 | [GitHub Docs — Available rules for rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets) | PRIMARY | 2026-11-14 (trovata da P-13) |
| <a id="s-173"></a>S-173 | [GitHub Docs — About code owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners) | PRIMARY | 2026-11-14 (trovata da P-13) |
| <a id="s-174"></a>S-174 | [GitHub Docs — REST API endpoints for rules (ruleset di repository)](https://docs.github.com/en/rest/repos/rules) | PRIMARY | 2026-11-14 (trovata da P-13) |
| <a id="s-175"></a>S-175 | [GitHub CLI — `gh pr merge` (opzione `--admin`)](https://cli.github.com/manual/gh_pr_merge) | PRIMARY | 2026-11-14 (trovata da P-13) |
| <a id="s-176"></a>S-176 | [GitHub Docs — Troubleshooting required status checks](https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/troubleshooting-required-status-checks) | PRIMARY | 2026-11-14 (trovata da P-13) |
| <a id="s-177"></a>S-177 | [GitHub Docs — Generating an installation access token for a GitHub App](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/generating-an-installation-access-token-for-a-github-app) | PRIMARY | 2026-11-14 (trovata da P-13) |
| <a id="s-178"></a>S-178 | [Microsoft Learn — Best practices for exceptions (.NET)](https://learn.microsoft.com/en-us/dotnet/standard/exceptions/best-practices-for-exceptions) | PRIMARY | 2026-11-14 (trovata da P-13) |
| <a id="s-179"></a>S-179 | [Microsoft Learn — System.AppDomain.UnhandledException event](https://learn.microsoft.com/en-us/dotnet/fundamentals/runtime-libraries/system-appdomain-unhandledexception) | PRIMARY | 2026-11-14 (trovata da P-13) |
| <a id="s-180"></a>S-180 | [Pester — Migrating from Pester v5 to v6](https://pester.dev/docs/migrations/v5-to-v6) | PRIMARY | 2026-11-14 (trovata da P-13) |
| <a id="s-181"></a>S-181 | [NUnit — Framework release notes](https://docs.nunit.org/articles/nunit/release-notes/framework.html) | PRIMARY | 2026-11-14 (trovata da P-13) |
| <a id="s-188"></a>S-188 | [MicrosoftDocs — Microsoft Learn MCP Server (endpoint, plugin `microsoftdocs/mcp`)](https://github.com/MicrosoftDocs/mcp) | PRIMARY | 2026-11-14 ⚠️ (letto solo l'estratto della ricerca) |
| <a id="s-189"></a>S-189 | [GitHub Docs — About GitHub's plans](https://docs.github.com/en/get-started/learning-about-github/githubs-plans) | PRIMARY | 2026-11-14 ⚠️ (letto solo l'estratto della ricerca) |

## Metodo (decisioni e scrittura)

| ID | Titolo | Tipo | Verifica |
|----|--------|------|----------|
| <a id="s-090"></a>S-090 | [M. Nygard — Documenting Architecture Decisions (2011)](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) | PRIMARY | 2026-11-07 |
| <a id="s-091"></a>S-091 | [Microsoft Learn — Maintain an architecture decision record (ADR)](https://learn.microsoft.com/azure/well-architected/architect-role/architecture-decision-record) | VENDOR-DOC | 2026-11-07 |
| <a id="s-092"></a>S-092 | [ASD-STE100 Simplified Technical English — sito ufficiale](https://www.asd-ste100.org/) | PRIMARY | ⚠️ riferimento all'indice dello standard, testo non riprodotto |
