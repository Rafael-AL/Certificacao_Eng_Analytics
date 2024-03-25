/*Criação da staging: stg_sap_adw__creditcard.sql*/
/*1º CET, creditcard_adw, tabela com a relação dos cartões de credito e suas chaves*/

with creditcard_adw as (
    select 
        CREDITCARDID AS PK_ID_CARTAO_CREDITO,
        CARDTYPE AS CARTAO_CREDITO,
        CARDNUMBER AS NUM_CARTAO_CRED,
        EXPMONTH AS VALIDADE_MES,
        EXPYEAR AS VALIDADE_ANO
        
    from {{ source('sap_adw', 'creditcard') }}
)

/*2º resultado final, creditcard_adw*/
select 
    *
from creditcard_adw