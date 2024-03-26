 /*1º CET, stg_productsubcategory, Relação de subcategorias de produtos, construção da DIM_SUBCATEGORIA_PRODUTO*/   

with stg_productsubcategory as (
    select *

    from {{ ref('stg_sap_adw__productsubcategory') }}
)

/*4º resultado final, DIM_SUBCATEGORIA_PRODUTO*/
select * from stg_productsubcategory