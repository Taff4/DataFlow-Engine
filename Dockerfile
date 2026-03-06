# Usamos a versão oficial, leve (slim) e estável do Python
FROM python:3.12-slim

# Evita que o Python grave arquivos .pyc (lixo) no disco e força os logs a irem direto pro terminal
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# (Apenas preparando o terreno. Amanhã instalaremos dependências aqui)

# Mantém o contêiner rodando em loop infinito para podermos entrar nele e executar comandos
CMD ["tail", "-f", "/dev/null"]