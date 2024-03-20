/*Criação da staging: stg_sap_adw__salesreason.sql*/
/*1º CET, salesreason_adw, tabela com as chaves primárias e descrições de cada motivo de venda da Adventure_Works*/

with salesreason_adw as (
    select 
        SALESREASONID AS PK_ID_MOTIVO_VENDA,
        NAME AS DESCRICAO_MOTIVO,
        REASONTYPE AS TIPO_MOTIVO

    from {{ source('sap_adw', 'salesreason') }}
)

/*2º resultado final, salesreason_adw*/
select 
    *
from salesreason_adw