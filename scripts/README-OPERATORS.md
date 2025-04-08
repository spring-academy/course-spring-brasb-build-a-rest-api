# Operator Documentation

## Course authors

See the [../README.md](top-level README) for documentation of scripts meant to be used by course authors.

## Cloud Environments

As of release 0.0.98,
educates workshops are not longer push-deployed to kubernetes clusters.

The educates clusters will reconcile from github container packages that
are now published via the `publish-latest-workshops.yaml` workflow (latest)
or tagged (production).

The cluster setup will be responsible for watching for updates to the
packages, and keep the clusters up-to-date.

The penguin updates still occur as before,
they are pushed:

- staging deployments are triggered by pushes to `main` -
  staging environment will be updated to the latest commit.

- production deployments are triggered by semantic version tags,
  and operators will configure the watch on the production cluster
  according to semantic version rules applied to them.
  See the [Spring Academy Config](https://github.com/spring-academy-config) repo for more information.
