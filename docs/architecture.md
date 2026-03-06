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
