{{ config(
    tags=["refined"]
) }}

with dpdata as (

    select * from {{ ref('src_dpdata')}}
    
)

select * from dpdata
