#!/bin/bash -e
: "${taito_company:?}"
: "${taito_vc_repository:?}"
: "${taito_vc_repository_alt:?}"

if [[ ${taito_verbose:-} == "true" ]]; then
  set -x
fi

# Remove the example site
rm -rf www/site
sed -i '/\/site\/.cache" # FOR GATSBY ONLY/d' docker-compose.yaml
sed -i '/\/site\/node_modules" # FOR GATSBY ONLY/d' docker-compose.yaml
sed -i '/\/site\/public" # FOR GATSBY ONLY/d' docker-compose.yaml

# Replace some strings
echo "Replacing project and company names in files. Please wait..."
find . -type f -exec sed -i \
  -e "s/website_template/${taito_vc_repository_alt}/g" 2> /dev/null {} \;
find . -type f -exec sed -i \
  -e "s/website-template/${taito_vc_repository}/g" 2> /dev/null {} \;
find . -type f -exec sed -i \
  -e "s/companyname/${taito_company}/g" 2> /dev/null {} \;
find . -type f -exec sed -i \
  -e "s/WEBSITE-TEMPLATE/website-template/g" 2> /dev/null {} \;

# Generate ports
echo "Generating unique random ports (avoid conflicts with other projects)..."
if [[ ! $ingress_port ]]; then ingress_port=$(shuf -i 8000-9999 -n 1); fi
if [[ ! $server_debug_port ]]; then server_debug_port=$(shuf -i 4000-4999 -n 1); fi
sed -i "s/4229/${server_debug_port}/g" \
  docker-compose.yaml \
  scripts/taito/project.sh scripts/taito/env-local.sh \
  scripts/taito/TAITOLESS.md www/README.md &> /dev/null || :
sed -i "s/9999/${ingress_port}/g" \
  scripts/taito/DEVELOPMENT.md \
  scripts/taito/TAITOLESS.md \
  scripts/taito/env-local.sh \
  scripts/taito/config/main.sh \
  docker-compose.yaml \
    &> /dev/null || :

./scripts/taito-template/common.sh
echo init done
