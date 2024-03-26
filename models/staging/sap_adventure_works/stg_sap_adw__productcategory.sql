/*Criação da staging: stg_sap_adw__productcategory.sql*/
/*1º CET, productcategory_adw, tabela de catgorias de produtos da Adventure_Works*/

with productcategory_adw as (
    select 
        PRODUCTCATEGORYID AS PK_ID_CATEGORIA_PRODUTO,
        NAME AS CATEGORIA,


    from {{ source('sap_adw', 'productcategory') }}
)

/*2º resultado final, productcategory_adw*/
select 
    *
from productcategory_adw