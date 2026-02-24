# Sistema de Gerenciamento de Vacinação – SQL Server

Este projeto consiste na modelagem e implementação de um **Banco de Dados para controle de vacinação**, desenvolvido em **SQL Server**.

O sistema simula o gerenciamento de aplicações de vacinas, incluindo pacientes, vacinadores, fabricantes, unidades de saúde e controle de lotes.

---

## Objetivo

Desenvolver um banco de dados relacional aplicando:

- Modelagem de entidades e relacionamentos
- Chaves primárias e estrangeiras
- Constraints
- View
- Stored Procedure
- Trigger
- Tabela Temporária
- Cursor

---

## Modelagem do Sistema

O sistema é composto pelas seguintes entidades:

- **Pessoa**
- **Paciente**
- **Vacinador**
- **Fabricante**
- **Vacina**
- **Unidade_de_Saude**
- **Aplicacao**

### Principais Relacionamentos

- `Paciente` e `Vacinador` herdam de `Pessoa`
- `Vacina` pertence a um `Fabricante`
- `Aplicacao` relaciona:
  - Paciente
  - Vacinador
  - Vacina
  - Unidade de Saúde
