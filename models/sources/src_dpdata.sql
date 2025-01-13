{{ config(
    tags=["raw_source"]
) }}

with dpdata as (

    select * from {{ source('dp_data','DP_DATA')}}
    
)

select * from dpdata
