-- 1º CET: stg_product, Relação de produtos da Adventure_Works, para construção da DIM_PRODUTO_DETALHE
with stg_product as (
    select *
    from {{ ref('stg_sap_adw__product') }}
),

-- 2º CET: dim_subcategoria_produto, Relação de subcategorias de produtos, para construção da DIM_PRODUTO_DETALHE
dim_subcategoria_produto as (
    select 
        FK_ID_CATEGORIA_PRODUTO,
        PK_ID_SUBCATEGORIA_PRODUTO,
        SUBCATEGORIA
    from {{ ref('dim_adw_subcategoria_produto') }}
),

-- 3º CET: join_stg_product_dim_subcategoria_produto, União dos produtos com as respectivas subcategorias, para construção da DIM_PRODUTO_DETALHE
join_stg_product_dim_subcategoria_produto as (
    select 
        A.*,
        B.FK_ID_CATEGORIA_PRODUTO,
        B.SUBCATEGORIA
    from stg_product A
    left join dim_subcategoria_produto B on A.FK_ID_SUBCATEGORIA_PRODUTO = B.PK_ID_SUBCATEGORIA_PRODUTO
),

-- 4º CET: dim_adw_categoria_produto, Lista de categorias dos produtos, para construção da DIM_PRODUTO_DETALHE
dim_categoria_produto as (
    select 
        PK_ID_CATEGORIA_PRODUTO,
        CATEGORIA
    from {{ ref('dim_adw_categoria_produto') }}
),

-- 5º CET: join_CET3_dim_categoria_produto, União dos produtos com subcategorias com suas respectivas categorias, para construção da DIM_PRODUTO_DETALHE
join_CET3_dim_categoria_produto AS (
    select
        A.*,
        B.CATEGORIA
    from join_stg_product_dim_subcategoria_produto A
    left join dim_categoria_produto B on A.FK_ID_CATEGORIA_PRODUTO = B.PK_ID_CATEGORIA_PRODUTO
),

-- 6º CET: stg_salesorderdetail, Relação das vendas por produto da Adventure_Works, para construção da DIM_PRODUTO_DETALHE
stg_salesorderdetail as (
    select *
    from {{ ref('stg_sap_adw__salesorderdetail') }}
),

-- 7º CET: join_CET5_stg_salesorderdetail, união da lista de produtos/subcategorias/categorias com os pedidos de venda, para construção da DIM_PRODUTO_DETALHE
join_CET5_stg_salesorderdetail as (
    select
        A.FK_ID_PEDIDO_VENDA,
        A.PK_ID_DETALHE_PEDIDO,
        A.FK_ID_PRODUTO,
        B.FK_ID_SUBCATEGORIA_PRODUTO,
        B.FK_ID_CATEGORIA_PRODUTO,
        A.NUMERO_RASTREIO,
        A.QTD_PEDIDO,
        A.FK_ID_OFERTA_ESP,
        A.PRECO_UNIT,
        A.DESCONTO_UNIT,
        B.PRODUTO,
        B.COD_PRODUTO,
        B.SUBCATEGORIA,
        B.CATEGORIA,
        B.BANDEIRA_PRODUTO,
        B.BAND_PROD_ACABADO,
        B.COR,
        B.ESTOQUE,
        B.PONTO_REENCOMENDA,
        B.CUSTO_PADRAO,
        B.LISTA_PRECO,
        B.TAMANHO,
        B.COD_TAMANHO,
        B.COD_MED_PESO,
        B.PESO,
        B.DIAS_FABRICACAO,
        B.LINHA_PRODUCAO,
        B.CLASSE,
        B.ESTILO,
        B.MODELO,
        B.INICIO_VENDAS,
        B.FIM_VENDAS,
        B.DTA_DESCONTINUACAO
    from stg_salesorderdetail A
    left join join_CET3_dim_categoria_produto B on A.FK_ID_PRODUTO = B.PK_ID_PRODUTO
)

-- 8º Resultado final: DIM_PRODUTO_DETALHE
select * from join_CET5_stg_salesorderdetail