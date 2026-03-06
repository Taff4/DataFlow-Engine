# ⚙️ DataFlow Engine

> Motor de processamento híbrido para higienização, auditoria e roteamento inteligente de arquivos desestruturados (PDFs, Notas Fiscais, Planilhas Excel).

Construído sob os princípios de **Engenharia Pragmática (Build Lean / Zero Vibe Code)**: Foco total em determinismo, processamento offline-first (Zero Data Leakage) e arquitetura hexagonal isolada por contêineres.

## 🏗️ Arquitetura e Documentação
Toda a documentação arquitetural, fluxo de dados e SecOps vivem junto com o código. 
Consulte nosso diretório oficial:
-[Contexto Geral e Regras de Negócio](docs/context.md)
-[Diagramas de Arquitetura e Banco de Dados](docs/architecture.md)
- [Decisões Arquiteturais (ADRs)](docs/adr_001_stack_e_arquitetura.md)

## 🚀 Tecnologias (Core)
- **Linguagem:** Python 3.12 (Strict Typing via Pydantic)
- **Manipulação de Dados:** Pandas & Openpyxl
- **Extração de Documentos:** pdfplumber
- **Interface e Roteamento:** Typer (CLI TUI)
- **Infraestrutura:** Docker & Docker Compose (AI Jail Isolation)
- **Qualidade:** Pytest (TDD)

## 🛠️ Como Iniciar (Quick Start)

O DataFlow Engine exige **Docker**. Nenhum pacote Python precisa ser instalado na sua máquina local.

**1. Clone o repositório:**
```bash
git clone https://github.com/Taff4/DataFlow-Engine.git
cd DataFlow-Engine
