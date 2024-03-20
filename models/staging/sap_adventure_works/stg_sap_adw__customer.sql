/*Criação da staging: stg_sap_adw__customer.sql*/
/*1º CET, customer_adw, tabela com as chaves primárias e estrangeiras pertinentes aos clientes da Adventure_Works*/
with customer_adw as (
    select 
        CUSTOMERID as PK_ID_CLIENTE,
        PERSONID as FK_ID_REG_PESSOA,
        STOREID as FK_ID_LOJA,
        TERRITORYID as FK_ID_TERRITORIO

    from {{ source('sap_adw', 'customer') }}
)

/*2º resultado final, customer_adw*/
select 
    *
from customer_adw