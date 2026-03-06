# DataFlow Engine - Master Architecture & Context

## 1. Visão Geral
O **DataFlow Engine** é um backend híbrido (inicia como CLI, escalável para API REST) projetado para ingerir, validar, higienizar, auditar e rotear arquivos desestruturados (PDFs, Notas Fiscais, Planilhas) de forma determinística e segura.

## 2. Segurança e Governança (Security by Design)
- **Zero Data Leakage:** Repositório protegido contra upload de arquivos sensíveis via `.gitignore` estrito (`input/` e `output/` isolados).
- **Processamento Efêmero:** O motor processa dados estritamente em memória RAM e cospe o resultado. Não há persistência de cache de dados sensíveis no contêiner.
- **Offline-First:** O core processa extração de PDFs localmente (`pdfplumber`) sem enviar chamadas para APIs externas (LLMs de terceiros), garantindo conformidade com a LGPD.
- **Validação de I/O:** O `Pydantic` garante que nenhuma entrada maliciosa ou fora de formato seja processada pelo `Pandas`.

## 3. Arquitetura do Backend (Hexagonal Lite)
A regra de ouro é: **A lógica de negócios não conhece a interface.**
- **Módulos de Domínio (`src/modules`):** Onde os motores `pandas` e `pdfplumber` operam. Eles recebem parâmetros puros e devolvem dados limpos.
- **Interface/Transporte (`src/cli`):** O entrypoint via terminal usando `Typer`. Apenas repassa a vontade do usuário para o domínio.
- **Smart Routing:** O backend possui autonomia para analisar cabeçalhos de arquivos e criar dinamicamente árvores de diretórios organizadas por cliente/data no diretório `/output`.

## 4. Stack Tecnológica
- **Linguagem:** Python 3.12 (Tipagem Estática)
- **Infraestrutura:** Docker (Isolamento de Host)
- **Testes:** Pytest (TDD estrito)