/*1º CET, stg_salesorderreason, tabela de motivos por venda/ordem, chaves primarias, da Adventure_Works, construção da DIM_MOTIVO_VENDA*/

with stg_salesorderreason as (
    select 
        PK_ID_PEDIDO_VENDA,
        PK_ID_MOTIVO_VENDA

    from {{ ref('stg_sap_adw__salesorderreason') }}
),

/*2º CET, stg_salesreason, tabela com as chaves primárias e descrições de cada motivo de venda da Adventure_Works, construção da DIM_MOTIVO_VENDA*/

stg_salesreason as (
    select 
        PK_ID_MOTIVO_VENDA,
        DESCRICAO_MOTIVO,
        TIPO_MOTIVO
 
    from {{ ref('stg_sap_adw__salesreason') }}
),

/*3º CET, Join_salesorderreason_stgsalesreason junção das stg_salesorderreason e stg_salesreason, construção da DIM_MOTIVO_VENDA*/

Join_salesorderreason_stgsalesreason as (
    select 
        A.PK_ID_PEDIDO_VENDA,
        A.PK_ID_MOTIVO_VENDA,
        B.DESCRICAO_MOTIVO,
        B.TIPO_MOTIVO       
    from stg_salesorderreason A
    left join stg_salesreason B on A.PK_ID_MOTIVO_VENDA = B.PK_ID_MOTIVO_VENDA
)

/*4º resultado final, DIM_MOTIVO_VENDAS*/
select 
    *
from Join_salesorderreason_stgsalesreason