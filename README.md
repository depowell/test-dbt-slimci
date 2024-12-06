# project: test-dbt-slimci
testing slimci/continuous integration setup in dbt cloud, CI jobs are a special type of dbt cloud job that will aim to only run impacted models (by your changes) on each PR. its an important strategy if you have a fairly large project and don't want to run every model or test on each invokation of dbt.

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

### setup in dbt cloud ui
the best way to get this working on a free/test account with github is to go to your [account settings](https://cloud.getdbt.com/settings/profile) and link github using oauth here 

### ci behavior
when using/setting up ci jobs in dbt cloud we need to run a deploy job first to enable CI jobs since initially it has no runs to compare against unless you do so.
- Triggered by pull requests - This feature is only available for dbt repositories connected through dbt Cloud's native integration with GitHub, Gitlab, or Azure DevOps
- Commands — By default, this includes the `dbt build --select state:modified+` command. This informs dbt Cloud to build only new or changed models and their downstream dependents. Importantly, state comparison can only happen when there is a deferred environment selected to compare state to. Click Add command to add more commands that you want to be invoked when this job runs.
- When CI jobs run The default schema will be overridden as a temporary schema prefixed by `dbt_cloud_pr_` where models will be materialised during the pr merge check
- *Optional Setting* Run on draft pull request (Optionally run CI on draft PRs)
- github will show merge checks on PR which look like: "Some checks haven’t completed yet: 1 pending check @dbt-cloud dbt Cloud Pending — dbt Cloud run pending" click on "details" to jump into the dbt cloud job id
 - merge checks that need to materialise new models do so in `dbt_cloud_pr_` and once a PR is merged the `dbt_cloud_pr_` schema will be dropped
- the CI job will not deploy changes into the environment it will only materialise things in `dbt_cloud_pr_` schema, another job must handle deployment
- if a change was detected but not deployed into the target environment, additional CI checks will materialise the changes into the temp schema


### initial run (triggered manually using normal deploy job in dbt cloud)
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

### second run triggered by PR into default branch (dbt cloud CI job)
```
------------------------------------------------------------
  Invoke dbt Command
------------------------------------------------------------
dbt build --select state:modified+

03:06:48  Running dbt...
03:06:49  Unable to do partial parsing because saved manifest not found. Starting full parse.
03:06:51  Found 2 models, 4 data tests, 468 macros
03:06:51  The selection criterion 'state:modified+' does not match any enabled nodes
03:06:51  The selection criterion 'state:modified+' does not match any enabled nodes
03:06:51  The selection criterion 'state:modified+' does not match any enabled nodes
03:06:51
03:06:51  Nothing to do. Try checking your model configs and model specification args
```

above summary: since dbt has identified no changed models from the repository it has nothing to do, nothing run in snowflake.

### third run triggered by PR into default branch (dbt cloud CI job)
```
03:17:38  Running dbt...
03:17:39  Unable to do partial parsing because saved manifest not found. Starting full parse.
03:17:40  Found 3 models, 4 data tests, 468 macros
03:17:40  
03:17:40
03:17:40  Concurrency: 4 threads (target='default')
03:17:40  
03:17:40  Found 3 models, 4 data tests, 468 macros
03:17:42  1 of 1 START sql table model dbt_cloud_pr_773350_4.my_third_dbt_model .......... [RUN]
03:17:43  1 of 1 OK created sql table model dbt_cloud_pr_773350_4.my_third_dbt_model ..... [[32mSUCCESS 1[0m in 0.94s]
03:17:44  
03:17:44
03:17:44  Finished running 1 table model in 0 hours 0 minutes and 3.39 seconds (3.39s).
03:17:44  
03:17:44
03:17:44  [32mCompleted successfully[0m
03:17:44  
03:17:44
03:17:44  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1
```

above summary: dbt identified a new model was created and materialised it into the temp schema for CI
