 /*1º CET, stg_salesorderreason, Relação de Paises, construção da DIM_PAISES*/   

with stg_countryregion as (
    select *

    from {{ ref('stg_sap_adw__countryregion') }}
)

/*4º resultado final, DIM_PAISES*/
select * from stg_countryregion