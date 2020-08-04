# 2nd task with answers

Please optimise the pipeline to follow the Continuous Deployment approach.

Things to consider are:

- how would you optimize the build for speed? **[I assume the question is broader, covering also
  testing]**

  - First, for the part with paraller runs (build, tests, lint, Sonarqube), identify the longest one
    to run and start optimizing it first (the current bottleneck). As for the other parallel jobs,
    which are not currently a bottleneck, it still makes some sense to optimize building speed, to
    save CircleCI credits and possibly reduce operating costs.
  - Try adding source code caching: https://circleci.com/docs/2.0/caching/#source-caching. Measure
    time execution: with cache and without cache and decide, which approach to use.
  - In real live we would have a lot of tests and this phase, if executed sequentially, would take a
    lot of time. To optimise that, we can use CircleCI feature allowing run tests in parallel:
    https://circleci.com/docs/2.0/parallelism-faster-jobs/
  - Give more memory for production build with change in package.json:

    ```
    from:
        "build:prod": "ng build --configuration=production",
    to:
        "build:prod": "node --max_old_space_size=8192 ./node_modules/@angular/cli/bin/ng build --configuration=production",
    ```

  - Configure more powerful building machine with 'resource_class' keyword:
    https://circleci.com/docs/2.0/configuration-reference/#resource_class
  - Switch to builder image already containing Chrome for automated testing:
    "circleci/node:14.6.0-browsers", so we don't have to install it every time we want to run tests.
  - Ask developers to remove unused packages from package.json
  - Ask developers to use smaller packages for the job with less dependencies

* how would you notify the team if something went wrong?

  - Setup Default Notifications: https://app.circleci.com/settings/user/notifications
  - Project Notifications: https://app.circleci.com/settings/user/notifications
  - Enable Web Notifications: https://app.circleci.com/settings/user/notifications
  - Setup Slack notifications _slack/notify-on-failure_:
    https://circleci.com/docs/2.0/notifications/#using-the-slack-orb
  - Setup IRC notifications: https://circleci.com/docs/2.0/notifications/#using-the-irc-orb
  - Setup third party CircleCI notification orbs, that can be explored here:
    https://circleci.com/orbs/registry/

* how would you implement feature flags?

  - I already know from Luke, that Optimizely is used in Cobiro. So, I created account there, added
    TopMsgFeature feature and made use of it in the demo application. We can verify it during the
    second meeting.

* how do feature flags affect testing?

* what is your roll back strategy?
  - The basic way is

- The most straightforward approach with CircleCI would be to go to its UI, navigate to the pipeline
  that deployed version you want to rollback to and click **Rerun -> Rerun Job with SSH**:

  ![alt text](https://i.imgur.com/ZUlwojP.png 'Screenshot from CircieCI showing Rerun Job with SSH option')

  This way we can switch between any deployed versions of the application (assuming there are no
  other breaking things like database schema change).

* please take advantage of smoke tests

  - Added _Smoke tests after deploying to DEV_ job to _.circleci/config.yml_

* please add a job for acceptance tests

  - Added _User Acceptance Testing on QA_ job to _.circleci/config.yml_

* assuming that acceptance test can run 1 hour but developers can push multiple times a day, how do
  you solve a problem of running these tests?

* What is your zero down time deployment strategy?
