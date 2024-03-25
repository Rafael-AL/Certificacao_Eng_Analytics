/*Criação da staging: stg_sap_adw__productcategory.sql*/
/*1º CET, productcategory_adw, tabela de catgorias de produtos da Adventure_Works*/

with salesorderreason_adw as (
    select 
        SALESORDERID AS PK_ID_PEDIDO_VENDA,
        SALESREASONID AS PK_ID_MOTIVO_VENDA

    from {{ source('sap_adw', 'salesorderheadersalesreason') }}
)

/*2º resultado final, salesorderreason_adw*/
select 
    *
from salesorderreason_adw