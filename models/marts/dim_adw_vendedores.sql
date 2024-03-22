/*1º CET, stg_person, nomes dos pessoas em geral da Adventure Works, construção da DIM_VENDEDORES*/

with stg_person as (
    select 
        PK_ID_REG_PESSOA,
        TIPO_PESSOA,
        TITULO,
        PRIMEIRO_NOME,
        MEDIO_NOME,
        ULTIMO_NOME,
        SUFIXO_NOME,
        /*junção dos nomes de pessoas, coluna NOME_COMPLETO*/
        CONCAT_WS(' ', COALESCE(PRIMEIRO_NOME, ''), COALESCE(MEDIO_NOME, ''), COALESCE(ULTIMO_NOME, ''), COALESCE(SUFIXO_NOME, '')) AS NOME_COMPLETO,
        /*verificação do tipo de pessoa, coluna NOME_COMPLETO*/
        CASE 
            WHEN TIPO_PESSOA = 'SC' THEN 'Contato da Loja'
            WHEN TIPO_PESSOA = 'IN' THEN 'Pessoa Física (Varejo)'
            WHEN TIPO_PESSOA = 'SP' THEN 'Vendedor'
            WHEN TIPO_PESSOA = 'EM' THEN 'Funcionário (não vendas)'
            WHEN TIPO_PESSOA = 'VC' THEN 'Fornecedor'
            WHEN TIPO_PESSOA = 'GC' THEN 'Contato Geral (outros)'
            ELSE 'Contato Geral (outros)'
        END AS TIPO_PESSOA_DESCRICAO

    from {{ ref('stg_sap_adw__person') }}
),

/*2º CET, stg_employee, registro de funcionarios da Adventure Works, construção da DIM_VENDEDORES*/
stg_employee as (
    select 
        PK_ID_REG_PESSOA,
        DOCUMENTO,
        CARGO,
        DATA_NASCIMENTO,
        ESTADO_CIVIL,
        GENERO
        
    from {{ ref('stg_sap_adw__employee') }}
),

/*3º CET, Join_stgperson_stgemployee, junção das stg_person e stg_employee, construção da DIM_VENDEDORES*/
Join_stgperson_stgemployee as (
    select 
        A.PK_ID_REG_PESSOA,
        A.TIPO_PESSOA,
        A.TITULO,
        A.PRIMEIRO_NOME,
        A.MEDIO_NOME,
        A.ULTIMO_NOME,
        A.SUFIXO_NOME,
        A.NOME_COMPLETO,
        A.TIPO_PESSOA_DESCRICAO,
        B.DOCUMENTO,
        B.CARGO,
        B.DATA_NASCIMENTO,
        B.ESTADO_CIVIL,
        B.GENERO
    from stg_person A
    left join stg_employee B on A.PK_ID_REG_PESSOA = B.PK_ID_REG_PESSOA
),
/*4º CET, stg_salesperson, tabela com resulrtados acumulados por vendedor da Adventure_Works, construção da DIM_VENDEDORES*/
stg_salesperson AS (
    select 
        PK_ID_REG_PESSOA,
        FK_ID_TERRITORIO,
        COTA_VENDA,
        BONUS,
        COMISSAO_PCT,
        VENDAS_ACUMULADAS,
        VENDA_ANO_ANTERIOR
    from {{ ref('stg_sap_adw__salesperson') }} 
),

/*5º CET, Join_stgperson_stgemployee, junção das Join_stgperson_stgemployee e stg_salesperson, construção da DIM_VENDEDORES*/
join_cte3_stgsalesperson AS (
    select
        A.PK_ID_REG_PESSOA,
        B.FK_ID_TERRITORIO,
        A.TIPO_PESSOA,
        A.TITULO,
        A.PRIMEIRO_NOME,
        A.MEDIO_NOME,
        A.ULTIMO_NOME,
        A.SUFIXO_NOME,
        A.NOME_COMPLETO,
        A.TIPO_PESSOA_DESCRICAO,
        A.DOCUMENTO,
        A.CARGO,
        A.DATA_NASCIMENTO,
        A.ESTADO_CIVIL,
        A.GENERO,
        B.COTA_VENDA,
        B.BONUS,
        B.COMISSAO_PCT,
        B.VENDAS_ACUMULADAS,
        B.VENDA_ANO_ANTERIOR
    from Join_stgperson_stgemployee A
    left join stg_salesperson B on A.PK_ID_REG_PESSOA = B.PK_ID_REG_PESSOA
    where TIPO_PESSOA = 'SP' --filtragem de vendedores
)

/*5º resultado final, DIM_VENDEDORES*/
select 
    *
from join_cte3_stgsalesperson