#!/bin/bash
# shellcheck disable=SC2034

##########################################################################
# Testing settings
#
# NOTE: Variables are passed to the tests without the test_TARGET_ prefix.
##########################################################################

# Environment specific settings
case $taito_env in
  local)
    # local environment
    ci_test_base_url=http://website-template-ingress:80
    ;;
  *)
    # dev and feature environments
    if [[ $taito_env == "dev" ]] || [[ $taito_env == "f-"* ]]; then
      ci_exec_test=false        # enable this to execute test suites
      ci_exec_test_init=false   # run 'init --clean' before each test suite
      ci_test_base_url=https://username:secretpassword@$taito_domain
    fi
    ;;
esac

# URLs
test_www_CYPRESS_baseUrl=$ci_test_base_url
if [[ "$taito_target_env" == "local" ]]; then
  CYPRESS_baseUrl=$taito_app_url
else
  CYPRESS_baseUrl=$ci_test_base_url
fi

# Hack to avoid basic auth on Electron browser startup:
# https://github.com/cypress-io/cypress/issues/1639
CYPRESS_baseUrlHack=$CYPRESS_baseUrl
CYPRESS_baseUrl=https://www.google.com
test_www_CYPRESS_baseUrlHack=$test_client_CYPRESS_baseUrl
test_www_CYPRESS_baseUrl=https://www.google.com
