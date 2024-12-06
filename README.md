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