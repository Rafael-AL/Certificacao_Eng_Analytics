-- Criação da staging: stg_sap_adw__product.sql
-- 1º CET: product_adw - Tabela de produtos da Adventure_Works
with product_adw as (
    select 
        PRODUCTID AS PK_ID_PRODUTO,
        PRODUCTSUBCATEGORYID AS FK_ID_SUBCATEGORIA_PRODUTO,
        NAME AS PRODUTO,
        PRODUCTNUMBER AS COD_PRODUTO,
        MAKEFLAG AS BANDEIRA_PRODUTO,
        FINISHEDGOODSFLAG AS BAND_PROD_ACABADO,
        COLOR AS COR,
        SAFETYSTOCKLEVEL AS ESTOQUE,
        REORDERPOINT AS PONTO_REENCOMENDA,
        STANDARDCOST AS CUSTO_PADRAO,
        LISTPRICE AS LISTA_PRECO,
        SIZE AS TAMANHO,
        SIZEUNITMEASURECODE AS COD_TAMANHO,
        WEIGHTUNITMEASURECODE AS COD_MED_PESO,
        WEIGHT AS PESO,
        DAYSTOMANUFACTURE AS DIAS_FABRICACAO,
        PRODUCTLINE AS LINHA_PRODUCAO,
        CLASS AS CLASSE,
        STYLE AS ESTILO,
        PRODUCTMODELID AS MODELO,
        SELLSTARTDATE AS INICIO_VENDAS,
        SELLENDDATE AS FIM_VENDAS,
        DISCONTINUEDDATE AS DTA_DESCONTINUACAO
    from {{ source('sap_adw', 'product') }}
)

-- 2º Resultado final: product_adw
select 
    *
from product_adw
