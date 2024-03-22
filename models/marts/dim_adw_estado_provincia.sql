 /*1º CET, stg_stateprovince, Relação de estados/provincias, construção da DIM_ESTADO_PROVINCIA*/   

with stg_stateprovince as (
    select *

    from {{ ref('stg_sap_adw__stateprovince') }}
)

/*4º resultado final, DIM_ESTADO_PROVINCIA*/
select * from stg_stateprovince