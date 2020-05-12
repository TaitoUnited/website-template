# Configuration

This file has been copied from [WEBSITE-TEMPLATE](https://github.com/TaitoUnited/WEBSITE-TEMPLATE/). Keep modifications minimal and improve the [original](https://github.com/TaitoUnited/WEBSITE-TEMPLATE/blob/dev/scripts/taito/CONFIGURATION.md) instead.

## Prerequisites

* [npm](https://github.com/npm/cli) that usually ships with [Node.js](https://nodejs.org/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Taito CLI](https://taitounited.github.io/taito-cli/) (or see [TAITOLESS.md](TAITOLESS.md))
* Optional: Some editor plugins depending on technology (e.g. [ESLint](https://eslint.org/docs/user-guide/integrations#editors) and [Prettier](https://prettier.io/docs/en/editors.html) for JavaScript/TypeScript)

## Basic settings

1. Run `taito open conventions` in the project directory to see organization specific settings that you should configure for your git repository. At least you should set `dev` as the default branch to avoid people using master branch for development by accident.
2. Modify `taito-project.sh` if you need to change some settings. The default settings are ok for most projects.
3. Run `taito project apply`
4. Commit and push changes

## Static site generator and local development environment

Configure static site generator of your choice with the following instructions. Currently instructions are provided only for Gatsby, Hugo, Jekyll and plain static files, but with some extra work the website-template may easily be used with any static site generator.

Remove static site generators that you do not use from `www/install.sh` but do not delete the whole file:

    EDIT www/install.sh

Start containers (see `taito trouble` if containers fail to start):

    taito kaboom

Once you see text `No site yet at www/site. Just keep the container running.`, execute the following steps depending on the static site generator of your choice.

### Plain static files (no site generator)

1. Add your static files to www/public with your code editor.

2. Restart containers and open the site on browser:

    ```
    taito stop
    taito start --clean
    taito open www
    ```

### Gatsby

1. Start a shell inside the www Docker container:

    ```
    taito shell:www
    ```

2. Create a new Gatsby site based on one of the [starters](https://www.gatsbyjs.org/starters?v=2) (NOTE: Select 'npm' as package manager and ignore the 'git commit' error):

    ```
    su node
    npx gatsby new site STARTER-SOURCE-URL-OF-MY-CHOICE
    rm -rf site/.git
    exit
    exit
    ```

3. Enable `/service/site/node_modules` mount in `docker-compose.yaml`:

    ```
    EDIT docker-compose.yaml
    ```

4. Restart containers and open the site on browser:

    ```
    taito stop
    taito start --clean
    taito open www
    ```

### Hugo

1. Start a shell inside the www Docker container:

    ```
    taito shell:www
    ```

2. Create a new Hugo site (See [Hugo themes](https://themes.gohugo.io/) and [Hugo quick start](https://gohugo.io/getting-started/quick-start/) for more details):

    ```
    hugo new site site
    cd site
    git clone https://github.com/budparr/gohugo-theme-ananke.git themes/ananke
    rm -rf themes/ananke/.git
    echo 'theme = "ananke"' >> config.toml
    hugo new posts/my-first-post.md
    exit
    ```

3. If you have some trouble with links, you might also need to enable relative urls by using the following settings in `www/site/config.toml`:

    ```
    baseURL = ""
    relativeURLs = true
    ```

4. Restart containers and open the site on browser:

    ```
    taito stop
    taito start --clean
    taito open www
    ```

### Jekyll

1. Start a shell inside the www Docker container:

    ```
    taito shell:www
    ```

2. Create a new site:

    ```
    bash
    jekyll new site
    exit
    exit
    ```

3. Restart containers and open the site on browser:

    ```
    taito stop
    taito start --clean
    taito open www
    ```

## Your first remote environment (dev)

Make sure your authentication is in effect:

    taito auth:dev

Create the environment (NOTE: You can enter anything as github token, if you don't need live preview):

    taito env apply:dev

OPTIONAL: If the git repository is private, you may choose to write down the basic auth credentials to [README.md#links](../../README.md#links):

    EDIT README.md                # Edit the links section

Push some changes to dev branch with a [Conventional Commits](http://conventionalcommits.org/) commit message (e.g. `chore: configuration`):

    taito stage                   # Or just: git add .
    taito commit                  # Or just: git commit -m 'chore: configuration'
    taito push                    # Or just: git push

> On Gatsby your first git push will likely fail because you haven't written any tests. Either write tests or replace `exit 1` with `exit 0` on `www/site/package.json`

See it build and deploy:

    taito open builds:dev
    taito status:dev
    taito open www:dev

> If you have some trouble creating an environment, you can destroy it by running `taito env destroy:dev` and then try again with `taito env apply:dev`.

---

## Remote real-time preview

You can edit the site on GitHub web GUI and preview changes on a remote environment. This is how you enable preview for dev environment:

1. Enable build webhook by editing `scripts/helm-dev.yaml`.
2. Optional: If you want to be able to merge changes between environments using GitHub web GUI, enable builds for all branches by setting `ci_exec_build=true` in `scripts/taito/project.sh`. This is required because GitHub web GUI does not support merging with fast-forward.
3. Make sure that urlprefix and personal git token have been set for webhook by running `taito secret show:dev`. If they are unset, set them with `taito secret rotate:dev webhook`
4. Configure a git webhook for your git repository. It should call url https://USER:PASSWORD@DEV-DOMAIN/webhook/URLPREFIX/build when changes are pushed to the git repository. For more information see the [GitHub Webhooks Guide](https://developer.github.com/webhooks/).

You can enable the build webhook also for staging, if you like.

## Remote environments

You can create the other environments just like you did the dev environment. However, you don't need to write down the basic auth credentials anymore, since you can reuse the same credentials as in dev environment.

Project environments are configured in `scripts/taito/project.sh` with the `taito_environments` setting. Examples for environment names: `f-orders`, `dev`, `test`, `stag`, `canary`, `prod`.

See [remote environments](https://taitounited.github.io/taito-cli/tutorial/05-remote-environments) chapter of Taito CLI tutorial for more thorough instructions.

Operations on production and staging environments usually require admin rights. Please contact DevOps personnel if necessary.

## Custom provider

If you cannot use Docker containers on your remote environments, you can customize the deployment with a custom provider. Instead of deploying the site as docker container image, you can, for example, deploy the site as static files on a web server, or as a WAR package on a Java application server. You can enable the custom provider with the `taito_provider` setting in `scripts/taito/main.sh` and implement [custom deployment scripts](https://github.com/TaitoUnited/WEBSITE-TEMPLATE/blob/master/scripts/custom-provider) yourself.

## Kubernetes

If you need to, you can configure Kubernetes settings by modifying `heml*.yaml` files located under the `scripts`-directory. The default settings, however, are ok for most sites.

## Secrets

You can add a new secret like this:

1. Add a secret definition to the `taito_secrets` or the `taito_remote_secrets` setting in `scripts/taito/project.sh`.
2. Map the secret definition to a secret in `docker-compose.yaml` for Docker Compose and in `scripts/helm.yaml` for Kubernetes.
3. Run `taito secret rotate:ENV SECRET` to generate a secret value for an environment. Run the command for each environment separately. Note that the rotate command restarts all pods in the same namespace.