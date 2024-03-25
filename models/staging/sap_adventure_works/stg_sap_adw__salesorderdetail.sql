/*Criação da staging: stg_sap_adw__salesorderdetail.sql*/
/*1º CET, salesorderdetail_adw, tabela com os datalhes das vendas e chaves de produtos da Adventure_Works*/

with salesorderdetail_adw as (
    select 
        SALESORDERID AS FK_ID_PEDIDO_VENDA,
        SALESORDERDETAILID AS PK_ID_DETALHE_PEDIDO,
        PRODUCTID AS FK_ID_PRODUTO,
        CARRIERTRACKINGNUMBER AS NUMERO_RASTREIO,
        ORDERQTY AS QTD_PEDIDO,
        SPECIALOFFERID AS FK_ID_OFERTA_ESP,
        UNITPRICE AS PRECO_UNIT,
        UNITPRICEDISCOUNT AS DESCONTO_UNIT,

    from {{ source('sap_adw', 'salesorderdetail') }}
)

/*2º resultado final, salesorderdetail_adw*/
select 
    *
from salesorderdetail_adw