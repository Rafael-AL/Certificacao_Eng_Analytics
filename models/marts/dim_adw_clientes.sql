/*1º CET, stg_person, nomes dos clientes da Adventure Works, construção da DIM_CLIENTE*/

with stg_person as (
    select 
        PK_ID_REG_PESSOA,
        TIPO_PESSOA,
        TITULO,
        PRIMEIRO_NOME,
        MEDIO_NOME,
        ULTIMO_NOME,
        SUFIXO_NOME,
        /*junção dos nomes de cliente, coluna NOME_COMPLETO*/
        CONCAT_WS(' ', COALESCE(PRIMEIRO_NOME, ''), COALESCE(MEDIO_NOME, ''), COALESCE(ULTIMO_NOME, ''), COALESCE(SUFIXO_NOME, '')) AS NOME_COMPLETO
    
    from {{ ref('stg_sap_adw__person') }}
),

/*2º CET, stg_customer, chaves primárias e estrangeiras dos clientes da Adventure Works, construção da DIM_CLIENTE*/
stg_customer as (
    select 
        FK_ID_REG_PESSOA,
        PK_ID_CLIENTE,
        FK_ID_LOJA,
        FK_ID_TERRITORIO
 
    from {{ ref('stg_sap_adw__customer') }}
),

/*3º CET, Join_stgperson_stgcustomer, junção das stg_person e stg_customer, construção da DIM_CLIENTE*/
Join_stgperson_stgcustomer as (
    select 
        A.PK_ID_REG_PESSOA,
        B.PK_ID_CLIENTE,
        B.FK_ID_LOJA,
        B.FK_ID_TERRITORIO,
        A.TIPO_PESSOA,
        A.TITULO,
        A.PRIMEIRO_NOME,
        A.MEDIO_NOME,
        A.ULTIMO_NOME,
        A.SUFIXO_NOME,
        A.NOME_COMPLETO 
    from stg_person A
    left join stg_customer B on A.PK_ID_REG_PESSOA = B.FK_ID_REG_PESSOA
)

/*4º resultado final, DIM_CLIENTES*/
select 
    *
from Join_stgperson_stgcustomer