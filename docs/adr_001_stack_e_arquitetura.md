# ADR 001: Stack, Backend e Segurança

**Data:** 06 de Março de 2026
**Status:** Aceito

## Contexto
O projeto "DataFlow Engine" exige uma base robusta para processamento de arquivos sensíveis. Precisamos definir a arquitetura do backend, as ferramentas de manipulação e as garantias de segurança contra vazamento de dados.

## Decisão
1. **Linguagem e Core:** Python 3.12 atuará como o backend. A escolha baseia-se na maturidade do ecossistema de dados (`pandas`, `pdfplumber`).
2. **Segurança de Dados:** 
   - Arquivos `.gitignore` configurados para bloquear diretórios de I/O.
   - Processamento estritamente local (Offline-first) para evitar envio de dados sensíveis de clientes a APIs de nuvem.
3. **Isolamento de Ambiente:** Uso obrigatório de Docker. O código não deve interagir diretamente com o SO do desenvolvedor ou do usuário final, prevenindo falhas de dependências.
4. **Metodologia de Qualidade:** Adoção de TDD (Test-Driven Development) usando `pytest`. Nenhuma regra de negócio de backend será aprovada sem cobertura de testes.

## Consequências
- **Positivas:** Previsibilidade absoluta no processamento. Garantia de que dados reais não irão parar acidentalmente no GitHub público. O backend nasce preparado para no futuro ser acoplado a um framework web (FastAPI).
- **Negativas:** Exige disciplina da equipe para sempre rodar o ambiente via Docker e escrever testes antes da implementação.