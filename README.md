# project: test-dbt-slimci
testing slimci/continuous integration setup in dbt cloud

## dbt cloud features used
- versionless - *we will use* versionless dbt in this project
- *we are testing* "Continuous integration jobs in dbt Cloud". continuous integration (CI) jobs run when a new pull request (PR) is opened. CI jobs run and test only modified models, ensuring efficient use of resources and a faster development process
- note: concurrent ci checks are only available in team or enterprise editions for dbt cloud - we will not use it in this test
- note: we will not be testing sql linting (team or enterprise) or sqlfluff in this test
- [advanced ci](https://docs.getdbt.com/docs/deploy/advanced-ci) will *not be used* in this test (this is only available in enterprise editions). advanced ci enables comparing data changes between environments during ci
  - prerequisites to advanced ci:
    - You have a dbt Cloud Enterprise account.
    - You have Advance CI features enabled.
    - You use a supported data platform: BigQuery, Databricks, Postgres, or Snowflake. Support for additional data platforms coming soon.

## project package management & integrations
 - we will solely use the dbt cloud ide to maintain the project and all integrations
 - remote is github
 - data warehouse is snowflake

## ci job
when using/setting up ci jobs in dbt cloud we need to run a deploy job first since initially it has no runs to compare against unless you do so.
Triggered by pull requests
This feature is only available for dbt repositories connected through dbt Cloud's native integration with GitHub, Gitlab, or Azure DevOps

### initial run
```
02:25:13  Running dbt...
02:25:14  Unable to do partial parsing because saved manifest not found. Starting full parse.
02:25:16  Found 2 models, 4 data tests, 468 macros
02:25:16  
02:25:16
02:25:16  Concurrency: 4 threads (target='default')
02:25:16  
02:25:17  1 of 6 START sql table model DEVELOPMENT.my_first_dbt_model .................... [RUN]
02:25:18  1 of 6 OK created sql table model DEVELOPMENT.my_first_dbt_model ............... [[32mSUCCESS 1[0m in 1.07s]
02:25:18  2 of 6 START test not_null_my_first_dbt_model_id ............................... [RUN]
02:25:18  3 of 6 START test unique_my_first_dbt_model_id ................................. [RUN]
02:25:20  3 of 6 PASS unique_my_first_dbt_model_id ....................................... [[32mPASS[0m in 1.63s]
02:25:20  2 of 6 PASS not_null_my_first_dbt_model_id ..................................... [[32mPASS[0m in 1.70s]
02:25:20  4 of 6 START sql table model DEVELOPMENT.my_second_dbt_model ................... [RUN]
02:25:21  4 of 6 OK created sql table model DEVELOPMENT.my_second_dbt_model .............. [[32mSUCCESS 1[0m in 0.94s]
02:25:21  5 of 6 START test not_null_my_second_dbt_model_id .............................. [RUN]
02:25:21  6 of 6 START test unique_my_second_dbt_model_id ................................ [RUN]
02:25:22  6 of 6 PASS unique_my_second_dbt_model_id ...................................... [[32mPASS[0m in 0.37s]
02:25:22  5 of 6 PASS not_null_my_second_dbt_model_id .................................... [[32mPASS[0m in 0.55s]
02:25:23  
02:25:23
02:25:23  Finished running 2 table models, 4 data tests in 0 hours 0 minutes and 7.43 seconds (7.43s).
02:25:23  
02:25:23
02:25:23  [32mCompleted successfully[0m
02:25:23  
02:25:23
02:25:23  Done. PASS=6 WARN=0 ERROR=0 SKIP=0 TOTAL=6
```