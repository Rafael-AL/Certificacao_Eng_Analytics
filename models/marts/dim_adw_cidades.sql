/* 1º CET, stg_address, Relação de endereços de clientes com suas cidades, construção da DIM_CIDADES */   

with stg_address as (
    select 
        PK_ID_ENDERECO,
        FK_ID_PROVINCIA_ESTADO,
        CIDADE,
        CODIGO_POSTAL
    from {{ ref('stg_sap_adw__address') }} 
),

/* 2º CET, dim_estados_provincia, Relação de estados, construção da DIM_CIDADES */   

dim_estados_provincia as (
    select 
        PK_ID_PROVINCIA_ESTADO,
        FK_ID_TERRITORIO,
        COD_PROVINCIA_ESTADO,
        PROVINCIA_ESTADO,
        COD_PAIS
    from {{ ref('dim_adw_estado_provincia') }} 
),

/* 3º CET, join_stgaddress_dim_estado_provincia, união das cidades com respectivos estados, construção da DIM_CIDADES */
join_stgaddress_dim_estado_provincia as (
    select 
        A.PK_ID_ENDERECO,
        A.FK_ID_PROVINCIA_ESTADO,
        B.FK_ID_TERRITORIO,
        A.CIDADE,
        B.COD_PROVINCIA_ESTADO,
        B.PROVINCIA_ESTADO,
        B.COD_PAIS
    from stg_address A
    left join dim_estados_provincia B on A.FK_ID_PROVINCIA_ESTADO = B.PK_ID_PROVINCIA_ESTADO
),

/* 4º CET, dim_paises, lista com os paises, construção da DIM_CIDADES */
dim_paises as (
    select *
    from {{ ref('dim_adw_paises') }}
),

/* 5º CET, join_CET3_dim_paises, união da CET 3 (cidades e estados) com seus paises, construção da DIM_CIDADES */
join_CET3_dim_paises AS (
    select
        A.PK_ID_ENDERECO,
        A.FK_ID_PROVINCIA_ESTADO,
        A.FK_ID_TERRITORIO,
        A.CIDADE,
        A.COD_PROVINCIA_ESTADO,
        A.PROVINCIA_ESTADO,
        A.COD_PAIS,
        B.PAIS
    from join_stgaddress_dim_estado_provincia A
    left join dim_paises B on A.COD_PAIS = B.COD_PAIS
)

/* 6º resultado final, CIDADES */
select * from join_CET3_dim_paises