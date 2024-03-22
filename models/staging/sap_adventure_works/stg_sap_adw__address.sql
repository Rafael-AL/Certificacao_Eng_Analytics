/*Criação da staging: stg_sap_adw__address.sql*/
/*1º CET, address_adw, tabela com as chaves primárias dos enedereços e respectivos estados/provincias*/

with address_adw as (
    select 
        ADDRESSID AS PK_ID_ENDERECO,
        STATEPROVINCEID AS FK_ID_PROVINCIA_ESTADO,
        ADDRESSLINE1 AS ENDERECO_1,
        ADDRESSLINE2 AS ENDERECO_2,
        CITY AS CIDADE,
        POSTALCODE AS CODIGO_POSTAL
        
    from {{ source('sap_adw', 'address') }}
)

/*2º resultado final, address_adw*/
select 
    *
from address_adw