# Arquitetura e Diagramas do Sistema

## 1. Diagrama de Arquitetura (Hexagonal Flow)
Este diagrama mostra como o nosso Core (Motor) está isolado, podendo ser chamado tanto pelo Terminal (Fase 1) quanto pela Nuvem (Fase 2).

```mermaid
graph TD
    %% Atores
    UserCLI[Usuário Local]
    UserWeb[Usuário Web]
    
    %% Camada de Apresentação (Adapters)
    subgraph "Camada de Transporte / Entrega"
        CLI[Typer CLI]
        API[FastAPI Web]
    end
    
    %% Barreira de Segurança
    subgraph "SecOps & Validação"
        Auth[JWT Auth]
        Rate[Rate Limiting]
        Pydantic[Validação Pydantic / Magic Number]
    end

    %% O Coração (Domain)
    subgraph "DataFlow Core (Módulos)"
        Router[Smart Router]
        Excel[Motor Pandas Excel]
        PDF[Motor pdfplumber]
    end
    
    %% Saída
    subgraph "Infraestrutura (Storage/DB)"
        LocalDisk[Disco Local ./output]
        Postgres[(PostgreSQL - Audit Log)]
    end

    %% Fluxos
    UserCLI --> CLI
    UserWeb --> API
    
    API --> Auth
    Auth --> Rate
    Rate --> Pydantic
    CLI --> Pydantic
    
    Pydantic --> Router
    Router --> Excel
    Router --> PDF
    
    Excel --> LocalDisk
    PDF --> LocalDisk
    
    Excel --> Postgres
    PDF --> Postgres
```

## 2. Diagrama de Entidade-Relacionamento (Banco de Dados)
Modelo básico de como as entidades se relacionam no nosso banco para auditoria.
```mermaid
erDiagram
    USERS ||--o{ JOBS : creates
    JOBS ||--|{ AUDIT_LOGS : generates
    
    USERS {
        uuid id PK
        string email
        string password_hash
        string role "admin, user"
        datetime created_at
    }
    
    JOBS {
        uuid id PK
        uuid user_id FK
        string original_filename
        string file_type "excel, pdf"
        string status "pending, processing, success, error"
        string output_path
        datetime started_at
        datetime finished_at
    }
    
    AUDIT_LOGS {
        uuid id PK
        uuid job_id FK
        string action "file_received, data_cleaned, rows_removed, saved"
        text error_traceback
        datetime timestamp
    }
```
## 3. Diagrama de Classes (Processadores)
Estrutura de herança dos processadores de arquivos do Core.
```mermaid
classDiagram
    class BaseProcessor {
        <<interface>>
        +validate_file(filepath: str) bool
        +process(filepath: str) dict
        +save(data: dict, output_path: str) str
    }

    class ExcelProcessor {
        -dataframe df
        +remove_duplicates()
        +sanitize_dates()
    }

    class PDFProcessor {
        -extracted_text str
        +extract_tables()
        +identify_cnpj()
    }

    BaseProcessor <|-- ExcelProcessor
    BaseProcessor <|-- PDFProcessor

    class SmartRouter {
        +route_file(filepath: str) BaseProcessor
    }
    
    SmartRouter ..> BaseProcessor : Uses
```

## 4. Diagrama de Casos de Uso
Mapeamento das ações que os diferentes perfis de usuários podem executar no DataFlow Engine.

```mermaid
graph LR
    %% Atores
    User((Usuário Comum))
    Admin((Administrador))
    Sys((Sistema Autônomo))

    %% Casos de Uso
    subgraph "DataFlow Engine"
        UC1(Processar Planilha Excel)
        UC2(Extrair Dados de PDF)
        UC3(Rotear Arquivo Automaticamente)
        UC4(Consultar Histórico de Logs)
        UC5(Configurar Regras de Limpeza)
    end

    %% Relações
    User --> UC1
    User --> UC2
    Sys --> UC3
    Admin --> UC4
    Admin --> UC5
    Admin --> UC1
    Admin --> UC2
```

## 5. 5. Diagrama de Sequência (Fluxo de Processamento de Arquivo)
A linha do tempo exata de como um arquivo entra sujo e sai limpo.

```mermaid
sequenceDiagram
    actor U as Usuário
    participant CLI as Typer CLI / Web API
    participant V as Validador (Pydantic)
    participant R as Smart Router
    participant P as Processor (Pandas/PDF)
    participant S as Storage (Disco)
    participant DB as PostgreSQL (Log)

    U->>CLI: Envia Arquivo (ex: nota_fiscal.pdf)
    CLI->>V: Checa Magic Number e Formato
    
    alt Arquivo Inválido / Vírus
        V-->>CLI: Erro de Validação
        CLI-->>U: Retorna Erro 400 / Mensagem no Terminal
    else Arquivo Válido
        V->>R: Arquivo Aprovado
        R->>R: Analisa Cabeçalho (Descobre tipo/cliente)
        R->>P: Instancia o Processador Correto
        
        Note over P: Inicia Processamento em RAM
        P->>P: Limpa Dados / Extrai Texto
        
        P->>S: Salva Arquivo Limpo no /output
        S-->>P: Confirma Gravação
        
        P->>DB: Registra Log de Sucesso (Auditoria)
        P-->>CLI: Retorna Status OK
        CLI-->>U: "Processamento Concluído com Sucesso!"
    end
```