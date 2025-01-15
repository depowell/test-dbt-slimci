{{ config(
    tags=["refined"]
) }}

with dpdata as (

    select * from {{ ref('src_dpdata')}}
    where field1 = 1
    -- test comment
    -- and field2 = 'fff'
    -- comment testing
    -- comment 2
    
)

select * from dpdata
