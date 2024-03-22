/*Criação da staging: stg_sap_adw__employee.sql*/
/*1º CET, employee_adw, tabela com registros de funcionarios da Adventure_Works*/
with employee_adw as (
    select 
        BUSINESSENTITYID AS PK_ID_REG_PESSOA,
        NATIONALIDNUMBER AS DOCUMENTO,
        JOBTITLE AS CARGO,
        BIRTHDATE AS DATA_NASCIMENTO,
        MARITALSTATUS AS ESTADO_CIVIL,
        GENDER AS GENERO
        
    from {{ source('sap_adw', 'employee') }}
)

/*2º resultado final, employee_adw*/
select 
    *
from employee_adw