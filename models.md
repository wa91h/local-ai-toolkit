# Configured Models

All 37 models below are pre-configured in `config/litellm_config.yaml` and served via the LiteLLM gateway. They run on [Ollama Cloud](https://ollama.com/search?c=cloud) infrastructure — no local GPU required.

Models are grouped by provider. The **Model name** column is the identifier to use in API calls and the name shown in Open WebUI.

---

## DeepSeek

| Model name | Size | Description |
|---|---|---|
| `deepseek-v3.1:671b-cloud` | 671B | Hybrid model supporting both thinking and non-thinking modes. Improved language consistency, enhanced agent capabilities, and smarter tool calling through post-training optimisation. |
| `deepseek-v3.2:cloud` | — | Harmonises high computational efficiency with superior reasoning and agent performance. Efficient attention mechanism, scalable reinforcement learning, and agentic task synthesis. 160K context window. |
| `deepseek-v4-flash:cloud` | 284B (13B active) | MoE model built for efficient reasoning across a 1M-token context window. Three thinking modes: no thinking for quick answers, thinking for logical analysis, max thinking for complex problem-solving. |

---

## Alibaba / Qwen

| Model name | Size | Description |
|---|---|---|
| `qwen3-coder:480b-cloud` | 480B | Performant long-context model for agentic and coding tasks. 256K context (expandable to 1M), trained on 7.5T tokens with 70% code ratio. Exceptional performance on software engineering tasks. |
| `qwen3-next:80b-cloud` | 80B | First in the Qwen3-Next series. Hybrid attention mechanisms, high-sparsity MoE layers, multi-token prediction. 256K context window. |
| `qwen3-vl:235b-cloud` | 235B | Vision-language model excelling at visual reasoning, text generation, and spatial understanding. Processes long-context documents and videos. OCR across 32 languages. |
| `qwen3-vl:235b-instruct-cloud` | 235B | Instruction-tuned variant of Qwen3-VL. Optimised for visual agent functions, code generation from images, and structured instruction following. |
| `qwen3.5:397b-cloud` | 397B | Multimodal model supporting 201 languages and dialects. Vision + language capabilities, 256K context window, optimised for different compute requirements. |
| `qwen3-coder-next:cloud` | 80B (3B active) | Coding-focused MoE model built on Qwen3-Next-80B. Trained on 800K executable tasks with reinforcement learning. Integrates with coding agents, 256K context window. |

---

## Google

| Model name | Size | Description |
|---|---|---|
| `gemma3:4b-cloud` | 4B | Lightweight model built on Gemini technology. Multimodal (text + image), 128K context, supports 140+ languages. Suitable for resource-constrained environments. |
| `gemma3:12b-cloud` | 12B | Mid-tier Gemma 3 model balancing performance and efficiency. Designed for question answering, summarisation, and reasoning. 128K context, 140+ languages. |
| `gemma3:27b-cloud` | 27B | Flagship open Gemma 3 model. Strong reasoning and multimodal capabilities. 128K context, suitable for complex instruction-following tasks. |
| `gemma4:31b-cloud` | 31B | Next generation Gemma model designed for frontier-level reasoning and multimodal tasks. |
| `gemini-3-flash-preview:cloud` | — | Frontier intelligence model built for speed. Advanced reasoning on PhD-level benchmarks, 1M context window. 90.4% on GPQA Diamond, 81.2% on MMMU Pro. |

---

## OpenAI

| Model name | Size | Description |
|---|---|---|
| `gpt-oss:20b-cloud` | 20B | Open-weight model engineered for reasoning and agentic tasks. Native function calling, chain-of-thought transparency, configurable reasoning effort. MXFP4 quantisation. |
| `gpt-oss:120b-cloud` | 120B | Larger variant of OpenAI's open-weight release. Stronger reasoning and developer use-cases. Same architecture as the 20B with greater capacity. |

---

## Mistral

| Model name | Size | Description |
|---|---|---|
| `mistral-large-3:675b-cloud` | 675B | General-purpose multimodal MoE model for production-grade and enterprise workloads. Vision, multilingual (dozens of languages), native function calling, 256K context. Apache 2.0 licence. |
| `devstral-small-2:24b-cloud` | 24B | Specialist model for agentic software engineering. Excels at multi-file codebase navigation, editing, and powering coding agents. 384K context, Apache 2.0 licence. |
| `ministral-3:3b-cloud` | 3B | Ultra-lightweight edge model with vision and multilingual support. 256K context window. Designed for on-device and constrained deployments. |
| `ministral-3:8b-cloud` | 8B | Mid-sized edge model balancing capability and efficiency. Vision, multilingual, agentic functions. 256K context. |
| `ministral-3:14b-cloud` | 14B | Largest in the Ministral edge family. Strong general-purpose performance with vision and multilingual support. 256K context. |

---

## Moonshot AI / Kimi

| Model name | Size | Description |
|---|---|---|
| `kimi-k2:1t-cloud` | 1T (32B active) | MoE model with significant improvements in coding agent tasks and public benchmarks. Efficient inference at 1T parameter scale via sparse activation. |
| `kimi-k2-thinking:cloud` | — | Thinking variant of Kimi K2. Reasons step-by-step while using tools, supports 200–300 sequential tool calls. Strong at agentic search, coding, and writing. 256K context. |
| `kimi-k2.5:cloud` | — | Native multimodal agentic model integrating vision and language. Instant and thinking modes, 256K context, code generation from visual specs, agent swarm support. |
| `kimi-k2.6:cloud` | — | Advances long-horizon coding, coding-driven design, and proactive autonomous execution. Supports up to 300 coordinated sub-agents for parallel task execution. 256K context. |

---

## MiniMax

| Model name | Size | Description |
|---|---|---|
| `minimax-m2:cloud` | 230B (10B active) | High-efficiency LLM for coding and agentic workflows. Multi-file edits, coding-run-fix loops, complex toolchain execution. 200K context. Ranked #1 open-source model on Artificial Analysis benchmarks. |
| `minimax-m2.1:cloud` | 230B (10B active) | Optimised for multilingual coding across Rust, Java, Go, C++, Kotlin, TypeScript, and more. Interleaved thinking for complex problem-solving. Enhanced general assistant capabilities. |
| `minimax-m2.5:cloud` | — | Designed for real-world productivity and coding. Excels at 10+ programming languages and agentic workflows. 198K context, 80.2% on SWE-Bench Verified. |
| `minimax-m2.7:cloud` | — | Professional software engineering and complex work environments. Built for agent systems and multi-step coding tasks. 200K context. |

---

## Zhipu AI / Z.ai (GLM)

| Model name | Size | Description |
|---|---|---|
| `glm-4.6:cloud` | — | Advanced agentic, reasoning, and coding model. 200K context (up from 128K). Competitive with DeepSeek-V3.1 and Claude Sonnet 4 on agent and coding benchmarks. |
| `glm-4.7:cloud` | — | Coding-focused update to GLM-4. Improved multilingual agentic coding, UI generation (web/slides), tool usage, and mathematical reasoning. "Think before acting" for complex tasks. 198K context. |
| `glm-5:cloud` | 744B (40B active) | Strong reasoning and agentic model for complex systems engineering and long-horizon tasks. MoE with DeepSeek Sparse Attention. Mathematical problem-solving, code generation, autonomous agents. English and Chinese. |
| `glm-5.1:cloud` | — | Next-generation flagship for agentic engineering. Stronger coding than GLM-5, handles complex tasks across hundreds of rounds and thousands of tool calls. 198K context. |

---

## NVIDIA

| Model name | Size | Description |
|---|---|---|
| `nemotron-3-nano:30b-cloud` | 30B | Efficient agentic model with 1M context window. Unified model for both reasoning and non-reasoning tasks. Generates reasoning traces before final responses. Hybrid Mamba-2/MoE/Attention architecture. |
| `nemotron-3-super:cloud` | 120B (12B active) | Open MoE model for agentic and multi-agent workflows. Maximum compute efficiency for complex applications. 256K context, 7 languages (EN, FR, DE, IT, JA, ES, ZH). |

---

## Cogito

| Model name | Size | Description |
|---|---|---|
| `cogito-2.1:671b-cloud` | 671B | Instruction-tuned model under MIT licence. Competitive with frontier closed and open models. 160K context, 30+ languages. Strong in reasoning, instruction following, coding, and creative tasks. |

---

## Essential AI

| Model name | Size | Description |
|---|---|---|
| `rnj-1:8b-cloud` | 8B | Dense open-weight model optimised for code and STEM. Strong in code generation across multiple languages, mathematical problem-solving, scientific reasoning, and agentic coding tasks. |
