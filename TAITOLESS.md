# Without Taito CLI

This file has been copied from [WEBSITE-TEMPLATE](https://github.com/TaitoUnited/WEBSITE-TEMPLATE/). Keep modifications minimal and improve the [original](https://github.com/TaitoUnited/WEBSITE-TEMPLATE/blob/dev/TAITOLESS.md) instead. Project specific conventions are located in [README.md](README.md#conventions).

> TODO: Improve instructions

Table of contents:

* [Prerequisites](#prerequisites)
* [Quick start](#quick-start)
* [Testing](#testing)
* [Configuration](##onfiguration)

## Prerequisites

* [Node.js](https://nodejs.org/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* Optional: eslint/tslint and prettier plugins for your code editor

## Quick start

Install libraries on host:

    npm install
    npm run install-dev

Start containers:

    docker-compose up

Open the site on browser:

    http://localhost:9999

Use `npm`, `docker-compose` and `docker` normally to run commands and operate containers.

If you would like to use some of the additional commands provided by Taito CLI also without using Taito CLI, first run the command with verbose option (`taito -v`) to see which commands Taito CLI executes under the hood, and then implement them in your package.json or makefile.

## Testing

You may run Cypress against any remote environment without Taito CLI or docker. See `client/test/README.md` for more instructions.

## Configuration

Instructions defined in [CONFIGURATION.md](CONFIGURATION.md) apply. You just need to run commands with `npm` or `docker-compose` directly instead of Taito CLI. If you want to setup the application environments or run CI/CD steps without Taito CLI, see the following instructions.

### Creating an environment

* Run taito-config.sh to set the environment variables:
    ```
    set -a
    taito_target_env=dev
    . taito-config.sh
    set +a
    ```
* Run terraform scripts that are located at `scripts/terraform/`. Note that the scripts assume that a cloud provider project defined by `taito_resource_namespace` and `taito_resource_namespace_id` already exists and Terraform is allowed to create resources for that project.
* Set Kubernetes secret values with `kubectl`. The secrets are defined by `taito_secrets` in `taito-config.sh`, and they are referenced in `scripts/helm*.yaml` files.

### Setting up CI/CD

You can easily implement CI/CD steps without Taito CLI. See [continuous integration and delivery](https://github.com/TaitoUnited/taito-cli/blob/master/docs/manual/06-continuous-integration-and-delivery.md) chapter of Taito CLI manual for instructions.