/*Criação da staging: stg_sap_adw__productsubcategory.sql*/
/*1º CET, productsubcategory_adw, tabela de SUBcatgorias de produtos da Adventure_Works*/

with productsubcategory_adw as (
    select 
        PRODUCTCATEGORYID AS FK_ID_CATEGORIA_PRODUTO,
        PRODUCTSUBCATEGORYID AS PK_ID_SUBCATEGORIA_PRODUTO,
        NAME AS SUBCATEGORIA

    from {{ source('sap_adw', 'productsubcategory') }}
)

/*2º resultado final, productsubcategory_adw*/
select 
    *
from productsubcategory_adw