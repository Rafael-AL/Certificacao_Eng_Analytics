-- 1º CET: stg_salesorderheader - Tabela de resumo de pedidos com chaves primárias e estrangeiras da Adventure_Works, para construção da DIM_DATA_DETALHES
with stg_salesorderheader as (
    select *
    from {{ ref('stg_sap_adw__salesorderheader') }}
),

-- 2º CET: stg_creditcard - Tabela com as chaves e nomes dos cartões de crédito, para construção da DIM_DATA_DETALHES
stg_creditcard as (
    select 
        PK_ID_CARTAO_CREDITO,
        CARTAO_CREDITO,
        NUM_CARTAO_CRED,
        VALIDADE_MES,
        VALIDADE_ANO
    from {{ ref('stg_sap_adw__creditcard') }}
),

-- 3º CET: Join_stgsalesorderheader_stgcreditcard - Junção das tabelas stg_salesorderheader e stg_creditcard, para construção da DIM_DATA_DETALHES
Join_stgsalesorderheader_stgcreditcard as (
    select 
        A.PK_ID_PEDIDO_VENDA,
        A.FK_ID_CLIENTE,
        A.FK_ID_REG_PESSOA,
        A.FK_ID_TERRITORIO,
        A.FK_ID_ENDERECO,
        A.FK_ID_END_ENVIO,
        A.FK_ID_METODO_ENVIO,
        A.FK_ID_CARTAO_CREDITO,
        A.NUM_REVISAO,
        A.DATA_PEDIDO,
        EXTRACT(YEAR FROM CAST(A.DATA_PEDIDO AS DATE)) AS ANO_PEDIDO,
        EXTRACT(MONTH FROM CAST(A.DATA_PEDIDO AS DATE)) AS MES_PEDIDO,
        A.DATA_VENCIMENTO,
        A.DATA_ENVIO,
        A.STATUS_PEDIDO,
        CASE 
            WHEN A.STATUS_PEDIDO = '1' THEN 'Em processamento'
            WHEN A.STATUS_PEDIDO = '2' THEN 'Aprovado'
            WHEN A.STATUS_PEDIDO = '3' THEN 'Em espera'
            WHEN A.STATUS_PEDIDO = '4' THEN 'Rejeitado'
            WHEN A.STATUS_PEDIDO = '5' THEN 'Enviado'
            WHEN A.STATUS_PEDIDO = '6' THEN 'Cancelado'
            ELSE 'Em processamento'
        END AS STATUS_DESCRICAO,
        A.BANDEIRA_PEDIDO,
        A.NUM_PEDIDO_COMPRA,
        A.NUMERO_CONTA,
        A.COD_APROVACAO_CARTAO,
        A.FK_ID_TAXA_MOEDA,
        A.SUBTOTAL_VENDAS,
        A.TAXA_MT,
        A.FRETE,
        A.VALOR_FINAL,
        B.CARTAO_CREDITO,
        B.NUM_CARTAO_CRED,
        B.VALIDADE_MES,
        B.VALIDADE_ANO,
        A.COMENTARIOS
    from stg_salesorderheader A
    left join stg_creditcard B on A.FK_ID_CARTAO_CREDITO = B.PK_ID_CARTAO_CREDITO
)

-- 4º Resultado final: DIM_DATA_DETALHES
select 
    *
from Join_stgsalesorderheader_stgcreditcard