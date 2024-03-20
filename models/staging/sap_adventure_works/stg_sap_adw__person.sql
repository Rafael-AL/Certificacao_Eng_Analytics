/*Criação da staging: stg_sap_adw__person.sql*/
/*1º CET, person_adw, tabela com registros de pessoas da Adventure_Works*/
with person_adw as (
    select 
        BUSINESSENTITYID AS PK_ID_REG_PESSOA,
        PERSONTYPE AS TIPO_PESSOA,
        TITLE AS TITULO,
        FIRSTNAME AS PRIMEIRO_NOME,
        MIDDLENAME AS MEDIO_NOME,
        LASTNAME AS ULTIMO_NOME,
        SUFFIX AS SUFIXO_NOME

    from {{ source('sap_adw', 'person') }}
)

/*2º resultado final, person_adw*/
select 
    *
from person_adw