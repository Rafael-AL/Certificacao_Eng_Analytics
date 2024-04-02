-- 1º CET: dim_produto_detalhe, dimensão de pedidos e detalhes dos produtos, construção da FACT_ORDEM_VENDA

WITH dim_produto_detalhe AS (
    SELECT *
    FROM {{ ref('dim_adw_produto_detalhe') }}
),
-- 2º CET: dim_data_detalhes_venda, dimensão de pedidos resumidos e datas de compra, construção da FACT_ORDEM_VENDA

dim_data_detalhes_venda AS (
    SELECT *
    FROM {{ ref('dim_adw_data_detalhes_venda') }}
),
-- 3º CET: dim_clientes, dimensão de clientes, construção da FACT_ORDEM_VENDA

dim_clientes AS (
    SELECT *
    FROM {{ ref('dim_adw_clientes') }}
),
-- 4º CET: dim_vendedores, dimensão de vendedores, construção da FACT_ORDEM_VENDA

dim_vendedores AS (
    SELECT *
    FROM {{ ref('dim_adw_vendedores') }}
),
-- 4º CET: dim_cidades, dimensão de cidades/estados/paises, construção da FACT_ORDEM_VENDA

dim_cidades AS (
    SELECT *
    FROM {{ ref('dim_adw_cidades') }}
),

-- 5º CET: dim_motivo_venda, dimensão de motivos de venda, construção da FACT_ORDEM_VENDA

dim_motivo_venda AS (
    SELECT *
    FROM {{ ref('dim_adw_motivo_venda') }}
),

-- 6º CET: join_ordens_produtos, união das CET 1 e 2 informações das ordens e detalhes dos produtos, construção da FACT_ORDEM_VENDA
join_ordens_produtos AS(
    SELECT 
        A.FK_ID_PEDIDO_VENDA,
        A.PK_ID_DETALHE_PEDIDO,
        A.FK_ID_PRODUTO,
        B.FK_ID_CLIENTE,
        B.FK_ID_REG_PESSOA,
        B.FK_ID_TERRITORIO,
        B.FK_ID_ENDERECO,
        B.FK_ID_END_ENVIO,
        B.FK_ID_CARTAO_CREDITO,
        A.QTD_PEDIDO,
        A.PRECO_UNIT::numeric(18,6) AS PRECO_UNIT,
        A.DESCONTO_UNIT::numeric(18,6) as DESCONTO_UNIT,
        A.PRODUTO,
        A.COD_PRODUTO,
        A.SUBCATEGORIA,
        A.CATEGORIA,
        A.ESTOQUE,
        B.DATA_PEDIDO,
        B.ANO_PEDIDO,
        B.MES_PEDIDO,
        B.STATUS_PEDIDO,
        B.STATUS_DESCRICAO,
        B.CARTAO_CREDITO
    FROM  dim_produto_detalhe A
    left join dim_data_detalhes_venda B ON A.FK_ID_PEDIDO_VENDA = B.PK_ID_PEDIDO_VENDA
),
-- 7º CET: join_ordens_dimensoes, união da CET 6 (detalhes das ordens) com as demais dimensões, construção da FACT_ORDEM_VENDA
join_ordens_dimensoes AS(
    SELECT 
        A.*,
        B.TIPO_PESSOA_DESCRICAO AS DESCRICAO_CLIENTE,
        B.NOME_COMPLETO AS NOME_CLIENTE,
        C.TIPO_PESSOA_DESCRICAO AS DESCRICAO_VENDEDOR,
        C.NOME_COMPLETO AS NOME_VENDEDOR,
        C.CARGO AS CARGO_VENDEDOR,
        --D.DESCRICAO_MOTIVO AS DESC_MOTIVO_VENDA,
        D.TIPO_MOTIVO AS TIPO_MOTIVO_VENDA,
        E.CIDADE,
        E.COD_PROVINCIA_ESTADO,
        E.PROVINCIA_ESTADO,
        E.COD_PAIS,
        E.PAIS

    FROM join_ordens_produtos A
        left join dim_clientes B ON A.FK_ID_CLIENTE = B.PK_ID_CLIENTE
        left join dim_vendedores C ON A.FK_ID_REG_PESSOA = C.PK_ID_REG_PESSOA
        left join dim_motivo_venda D ON A.FK_ID_PEDIDO_VENDA = D.PK_ID_PEDIDO_VENDA
        left join dim_cidades E ON A.FK_ID_ENDERECO = E.PK_ID_ENDERECO
),
-- 8º CET: criação das métricas e chave primária da tabela, construção da FACT_ORDEM_VENDA
metricas_tbl_fato AS(
    SELECT
        {{ dbt_utils.generate_surrogate_key(['FK_ID_PEDIDO_VENDA', 'PK_ID_DETALHE_PEDIDO', 'FK_ID_PRODUTO']) }} as SK_ORDEM_VENDA,
        A.*,
        CASE
            WHEN A.DESCONTO_UNIT > 0 THEN TRUE
            ELSE FALSE
        END as POSSUI_DESCONTO,
        A.PRECO_UNIT::numeric(18,6) * A.QTD_PEDIDO::numeric(18,6) as FATURAMENTO_BRUTO,
        A.PRECO_UNIT * A.QTD_PEDIDO * (1 - A.DESCONTO_UNIT) AS FATURAMENTO_LIQUIDO

    FROM join_ordens_dimensoes A
)

SELECT DISTINCT *
FROM metricas_tbl_fato
--where PK_ID_DETALHE_PEDIDO = '43773'