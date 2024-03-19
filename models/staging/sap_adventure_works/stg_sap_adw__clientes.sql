/*1º CET, person_adw, tabela com registros de pessoas da Adventure_Works*/

with person_adw as (
    select *
    from {{ source('sap_adw', 'person') }}
),

/*2º CET, customer_adw, tabela com as chaves primárias e estrangeiras pertinentes aos clientes das da Adventure_Works*/
customer_adw as (
    select 
        CUSTOMERID as PK_ID_CLIENTE,
        PERSONID as FK_ID_REG_PESSOA,
        STOREID as FK_ID_LOJA,
        TERRITORYID as FK_ID_TERRITORIO
    from {{ source('sap_adw', 'customer') }}
),

/*3º CET, join_person_customer, união das CTEs supracitadas para conclusão da DIM_CLIENTES*/
join_person_customer as (
    select 
        A.BUSINESSENTITYID AS PK_ID_REG_PESSOA,
        b.PK_ID_CLIENTE,
        --FK_ID_REG_PESSOA, --chave estrangeira, igual a PK_ID_REG_PESSOA
        b.FK_ID_LOJA,
        b.FK_ID_TERRITORIO,
        A.PERSONTYPE AS TIPO_PESSOA,
        A.TITLE AS TITULO,
        A.FIRSTNAME AS PRIMEIRO_NOME,
        A.MIDDLENAME AS MEDIO_NOME,
        A.LASTNAME AS ULTIMO_NOME,
        A.SUFFIX AS SUFIXO_NOME,
        CONCAT_WS(' ', COALESCE(A.FIRSTNAME, ''), COALESCE(A.MIDDLENAME, ''), COALESCE(A.LASTNAME, ''), COALESCE(A.SUFFIX, '')) AS NOME_COMPLETO -- junção dos nomes de cliente
    from person_adw a
    left join customer_adw b on a.BUSINESSENTITYID = b.FK_ID_REG_PESSOA
)

/*4º resultado final, DIM_CLIENTES*/
select 
    *
from join_person_customer