/*Criação da staging: stg_sap_adw__stateprovince.sql*/
/*1º CET, stateprovince_adw, tabela com as chaves primárias das provincias/regioes e abreveaturas de país*/

with stateprovince_adw as (
    select 
        STATEPROVINCEID AS PK_ID_PROVINCIA_ESTADO,
        TERRITORYID AS FK_ID_TERRITORIO,
        STATEPROVINCECODE AS COD_PROVINCIA_ESTADO,
        NAME AS PROVINCIA_ESTADO,
        COUNTRYREGIONCODE AS COD_PAIS
        
    from {{ source('sap_adw', 'stateprovince') }}
)

/*2º resultado final, stateprovince_adw*/
select 
    *
from stateprovince_adw