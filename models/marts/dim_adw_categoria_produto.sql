 /*1º CET, stg_productcategory, Relação de categoria de produtos, construção da DIM_CATEGORIA_PRODUTO*/   

with stg_productcategory as (
    select *

    from {{ ref('stg_sap_adw__productcategory') }}
)

/*4º resultado final, DIM_PAISES*/
select * from stg_productcategory