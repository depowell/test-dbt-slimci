with dpdata as (

    select * from {{ source('dp_data','DP_DATA')}}
    where field1 = 1
    
)

select * from dpdata
where field1 = 1