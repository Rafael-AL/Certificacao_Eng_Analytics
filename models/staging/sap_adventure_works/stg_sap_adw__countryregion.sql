/*Criação da staging: stg_sap_adw__countryregion.sql*/
/*1º CET, countryregion_adw, tabela com abreveaturas de país*/

with countryregion_adw as (
    select 
        COUNTRYREGIONCODE AS COD_PAIS,
        NAME AS PAIS
        
    from {{ source('sap_adw', 'countryregion') }}
)

/*2º resultado final, countryregion_adw*/
select 
    *
from countryregion_adw