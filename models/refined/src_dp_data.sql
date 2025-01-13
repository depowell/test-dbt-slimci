{{ config(
    tags=["refined"]
) }}

with dpdata as (

    select * from {{ ref('src_dpdata')}}
    where field1 = 2
    
)

select * from dpdata
