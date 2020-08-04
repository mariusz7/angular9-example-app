# 2nd task

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
    "build:prod": "ng build --configuration=production",
    o:
    ",
    /)

    2)
    B)
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
* how do feature flags affect testing?
* what is your roll back strategy?
* please take advantage of smoke tests
* please add a job for acceptance tests
* assuming that acceptance test can run 1 hour but developers can push multiple times a day, how do
  you solve a problem of running these tests?
* What is your zero down time deployment strategy?
