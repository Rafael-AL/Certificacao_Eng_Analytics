/*1º CET, salesorderreason_adw, tabela de motivos por venda/ordem da Adventure_Works*/

with salesorderreason_adw as (
    select *
    from {{ source('sap_adw', 'salesorderheadersalesreason') }}
),

/*2º CET, csalesreason_adw, tabela com as chaves primárias de cada motivo de venda da Adventure_Works*/
salesreason_adw as (
    select *   
    from {{ source('sap_adw', 'salesreason') }}
),

/*3º CET, join_orderreason_salesreason, união das CTEs supracitadas para conclusão da DIM_MOTIVO_VENDA*/
join_orderreason_salesreason as (
    select 
        A.SALESORDERID AS PK_ID_PEDIDO_VENDA,
        A.SALESREASONID AS PK_ID_MOTIVO_VENDA,
        B.NAME AS DESCRICAO_MOTIVO,
        B.REASONTYPE AS TIPO_MOTIVO
    from salesorderreason_adw  a
    left join salesreason_adw b on a.SALESREASONID = b.SALESREASONID
)

/*4º resultado final, DIM_MOTIVO_VENDA*/
select 
    *
from join_orderreason_salesreason