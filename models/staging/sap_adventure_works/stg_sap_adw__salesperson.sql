/*Criação da staging: stg_sap_adw__salesperson.sql*/
/*1º CET, salesperson_adw, tabela com resulrtados acumulados por vendedor da Adventure_Works*/
with salesperson_adw as (
    select 
        BUSINESSENTITYID AS PK_ID_REG_PESSOA,
        TERRITORYID AS FK_ID_TERRITORIO,
        SALESQUOTA AS COTA_VENDA,
        BONUS AS BONUS,
        COMMISSIONPCT AS COMISSAO_PCT,
        SALESYTD AS VENDAS_ACUMULADAS,
        SALESLASTYEAR AS VENDA_ANO_ANTERIOR
        
    from {{ source('sap_adw', 'salesperson') }}
)

/*2º resultado final, salesperson_adw*/
select 
    *
from salesperson_adw