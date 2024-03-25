/*Criação da staging: stg_sap_adw__salesorderheader.sql*/
/*1º CET, salesorderheader_adw, tabela com a relação dos cartões de credito e suas chaves*/

with salesorderheader_adw as (
    select 
        SALESORDERID AS PK_ID_PEDIDO_VENDA,
        CUSTOMERID AS FK_ID_CLIENTE,
        SALESPERSONID AS FK_ID_REG_PESSOA,
        TERRITORYID AS FK_ID_TERRITORIO,
        BILLTOADDRESSID AS FK_ID_ENDERECO,
        SHIPTOADDRESSID AS FK_ID_END_ENVIO,
        SHIPMETHODID AS FK_ID_METODO_ENVIO,
        CREDITCARDID AS FK_ID_CARTAO_CREDITO,
        REVISIONNUMBER AS NUM_REVISAO,
        ORDERDATE AS DATA_PEDIDO,
        DUEDATE AS DATA_VENCIMENTO,
        SHIPDATE AS DATA_ENVIO,
        STATUS AS STATUS_PEDIDO,
        ONLINEORDERFLAG AS BANDEIRA_PEDIDO,
        PURCHASEORDERNUMBER AS NUM_PEDIDO_COMPRA,
        ACCOUNTNUMBER AS NUMERO_CONTA,
        CREDITCARDAPPROVALCODE AS COD_APROVACAO_CARTAO,
        CURRENCYRATEID AS FK_ID_TAXA_MOEDA,
        SUBTOTAL AS SUBTOTAL_VENDAS,
        TAXAMT AS TAXA_MT,
        FREIGHT AS FRETE,
        TOTALDUE AS VALOR_FINAL,
        COMMENT AS COMENTARIOS

    from {{ source('sap_adw', 'salesorderheader') }}
)

/*2º resultado final, salesorderheader_adw*/
select 
    *
from salesorderheader_adw