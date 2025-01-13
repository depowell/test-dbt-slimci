{{ config(
    tags=["refined"]
) }}

with dpdata as (

    select * from {{ ref('src_dpdata')}}
    where field1 = 1
    -- comment testing
    
)

select * from dpdata
