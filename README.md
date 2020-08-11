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

* **DONE** how would you notify the team if something went wrong?

  - Setup Default Notifications: https://app.circleci.com/settings/user/notifications
  - Project Notifications: https://app.circleci.com/settings/user/notifications
  - Enable Web Notifications: https://app.circleci.com/settings/user/notifications
  - Setup Slack notifications _slack/notify-on-failure_:
    https://circleci.com/docs/2.0/notifications/#using-the-slack-orb
  - Setup IRC notifications: https://circleci.com/docs/2.0/notifications/#using-the-irc-orb
  - Setup third party CircleCI notification orbs, that can be explored here:
    https://circleci.com/orbs/registry/
  - We can use 'when: on_fail' to add some custom action

* **DONE** how would you implement feature flags?

  - I already know from Luke, that Optimizely is being used in Cobiro. So, I created account there,
    added TopMsgFeature feature and made use of it in the demo application. It is now possible to
    switch demo feature on and off in runtime.

* how do feature flags affect testing?

* what is your roll back strategy?

  - First let's state, that we can have manual or automated rollbacks (or both covering different
    failure cases).
  - Manual rollbacks

    - The most straightforward approach with CircleCI would be to go to its UI, navigate to the
      pipeline that deployed version you want to rollback to and click **Rerun -> Rerun Job with
      SSH**:

      ![alt text](https://i.imgur.com/ZUlwojP.png 'Screenshot from CircieCI showing Rerun Job with SSH option')

      This way we can switch between any deployed versions of the application (assuming there are no
      other breaking things like database schema change).

    - What can work in some simpler cases, is to turn breaking feature off in Optimizely.

  - Automated rollbacks

    - AWS ECS already supports health checks...

    - TODO the one from open tab in my m8

* **DONE** please take advantage of smoke tests

  - Added _Smoke tests after deploying to DEV_ job to _.circleci/config.yml_

* **DONE** please add a job for acceptance tests

  - Added _User Acceptance Testing on QA_ job to _.circleci/config.yml_

* assuming that acceptance test can run 1 hour but developers can push multiple times a day, how do
  you solve a problem of running these tests?

  - Before I start implementing workaround(s) to handle that, I would try to find an actual solution
    to the situation. According to Martin Fowler, entire pipeline should take - ideally - no more
    than 10 minutes
    ([KeepTheBuildFast](https://martinfowler.com/articles/continuousIntegration.html#KeepTheBuildFast)).

    - If there are in fact many acceptance tests instead of just one, then a key thing to
      investigate is, whether it is possible to split those acceptance tests and make use of
      CircleCI's parallel execution. Ideally this would allow reducing tests run time to a point,
      where executing them every time developer commits something, is acceptable.

    - If there is actually one long test or test suite with at least one long test, than we could
      try talking to developers to refactor that test, so it could be executed in acceptable time.

  - However, if we really have to deal with at least one acceptance test running for 1 hour......
    TODO

* What is your zero down time deployment strategy?
