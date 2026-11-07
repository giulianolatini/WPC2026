# Sources — Fonti documentali

Questo file contiene l'elenco delle fonti documentali del repository.
Ogni fonte ha un identificativo stabile (`S-NNN`) e un'ancora.
Gli altri documenti puntano alla fonte con un link del tipo `Sources.md#s-001`.

**Regole d'uso**

- Usa sempre il link all'ancora, non l'URL diretto, nei documenti in `docs/`.
- Non cambia l'identificativo di una fonte. Se una fonte non è più valida, segna lo stato `Obsoleta` e aggiungi una nuova fonte.
- La colonna **Verifica** indica la data di consultazione. Il simbolo ⚠️ indica un contenuto non verificato completamente.

**Tag di tipologia**: `[PRIMARY]` documentazione ufficiale del prodotto; `[VENDOR-DOC]` documentazione di vendor di terze parti; `[OPINION]` articolo secondario.

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
| <a id="s-031"></a>S-031 | [LiteLLM — Virtual keys](https://docs.litellm.ai/docs/proxy/virtual_keys) | PRIMARY | ⚠️ non consultata |

## Provider LLM

| ID | Titolo | Tipo | Verifica |
|----|--------|------|----------|
| <a id="s-040"></a>S-040 | [Anthropic — Models overview](https://platform.claude.com/docs/en/about-claude/models/overview) | PRIMARY | 2026-11-07 |
| <a id="s-041"></a>S-041 | [Anthropic — Messages API reference](https://platform.claude.com/docs/en/api/messages) | PRIMARY | ⚠️ non consultata |
| <a id="s-042"></a>S-042 | [OpenAI — Codex models (redirect da developers.openai.com/codex/models)](https://learn.chatgpt.com/docs/models) | PRIMARY | 2026-11-07 ⚠️ |
| <a id="s-043"></a>S-043 | [OpenAI — Responses API reference](https://platform.openai.com/docs/api-reference/responses) | PRIMARY | ⚠️ non consultata |
| <a id="s-044"></a>S-044 | [Google — Gemini API models](https://ai.google.dev/gemini-api/docs/models) | PRIMARY | 2026-11-07 |
| <a id="s-045"></a>S-045 | [Google — Gemini API OpenAI compatibility](https://ai.google.dev/gemini-api/docs/openai) | PRIMARY | 2026-11-07 |
| <a id="s-046"></a>S-046 | [OpenRouter — API reference overview](https://openrouter.ai/docs/api-reference/overview) | PRIMARY | ⚠️ non consultata |
| <a id="s-047"></a>S-047 | [Hugging Face — Inference Providers (router OpenAI-compatible)](https://huggingface.co/docs/inference-providers/index) | PRIMARY | 2026-11-07 |
| <a id="s-048"></a>S-048 | [Hugging Face — Use Inference Providers with GitHub Copilot Chat in VS Code](https://huggingface.co/docs/inference-providers/guides/vscode) | PRIMARY | 2026-11-07 |
| <a id="s-049"></a>S-049 | [Hugging Face — repository `huggingface-vscode-chat`](https://github.com/huggingface/huggingface-vscode-chat) | PRIMARY | 2026-11-07 |

## Strumenti di base (uv, Docker)

| ID | Titolo | Tipo | Verifica |
|----|--------|------|----------|
| <a id="s-060"></a>S-060 | [Astral — Installing uv](https://docs.astral.sh/uv/getting-started/installation/) | PRIMARY | 2026-11-07 |
| <a id="s-061"></a>S-061 | [Docker — Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/) | PRIMARY | 2026-11-07 |
| <a id="s-062"></a>S-062 | [Docker — Install Docker Engine on Debian](https://docs.docker.com/engine/install/debian/) | PRIMARY | ⚠️ non consultata |
| <a id="s-063"></a>S-063 | [Docker — Linux post-installation steps](https://docs.docker.com/engine/install/linux-postinstall/) | PRIMARY | ⚠️ non consultata |
| <a id="s-064"></a>S-064 | [openSUSE Wiki — Docker](https://en.opensuse.org/Docker) | PRIMARY | 2026-11-07 |
| <a id="s-065"></a>S-065 | [Homebrew Formulae — cask `docker-desktop`](https://formulae.brew.sh/cask/docker-desktop) | VENDOR-DOC | 2026-11-07 |
| <a id="s-066"></a>S-066 | [Docker — Install Docker Desktop on Windows](https://docs.docker.com/desktop/setup/install/windows-install/) | PRIMARY | ⚠️ non consultata |

## GitHub Spec Kit

| ID | Titolo | Tipo | Verifica |
|----|--------|------|----------|
| <a id="s-080"></a>S-080 | [GitHub — Spec Kit (repository)](https://github.com/github/spec-kit) | PRIMARY | 2026-11-07 |
| <a id="s-081"></a>S-081 | [GitHub — Spec Kit Installation](https://github.github.io/spec-kit/installation.html) | PRIMARY | 2026-11-07 |
| <a id="s-082"></a>S-082 | [GitHub — Spec Kit integrations CLI reference](https://github.github.io/spec-kit/integrations/cli.html) | PRIMARY | ⚠️ non consultata |

## Metodo (decisioni e scrittura)

| ID | Titolo | Tipo | Verifica |
|----|--------|------|----------|
| <a id="s-090"></a>S-090 | [M. Nygard — Documenting Architecture Decisions (2011)](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) | PRIMARY | 2026-11-07 |
| <a id="s-091"></a>S-091 | [Microsoft Learn — Maintain an architecture decision record (ADR)](https://learn.microsoft.com/azure/well-architected/architect-role/architecture-decision-record) | VENDOR-DOC | 2026-11-07 |
| <a id="s-092"></a>S-092 | [ASD-STE100 Simplified Technical English — sito ufficiale](https://www.asd-ste100.org/) | PRIMARY | ⚠️ riferimento all'indice dello standard, testo non riprodotto |
