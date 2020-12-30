#!/usr/bin/env bash

intro() {
  local serviceName

  echo -e "${COLOR__YELLOW} Please, specify the service name for which you're want to generate certs: ${COLOR__DEFAULT}"
  read -r -p "Docker service name: " serviceName

  servicePath="./secrets.d/cert.d/dec.d/${serviceName}"

  if [ ! -d "$servicePath" ]; then
    mkdir -p "$servicePath"
  fi
}

readDomains() {
  echo -e "${COLOR__YELLOW} Please, specify the primary domain name (2nd-level, should be consistent with a one specified in .env-file): ${COLOR__DEFAULT}"
  read -r -p "Primary domain name: " primaryDomain

  secondaryDomains=()
  echo -e "${COLOR__YELLOW} Please, specify all other domains (3rd-level, should be consistent with a one specified in .env-file): ${COLOR__DEFAULT}"
  while IFS= read -r -p "Secondary domain name (press return to end): " line; do
    if [ -z "$line" ]; then
      break
    fi

    secondaryDomains+=("$line")
  done
}

generateCerts() {
  echo -e "${COLOR__GREEN} Generating certificates... ${COLOR__DEFAULT}"
  local subject="/C=US/ST=NY/L=NewYork/O=Stub/OU=Stub/CN=$primaryDomain"

  openssl req -x509 -new -nodes -newkey rsa:2048 \
    -keyout "${servicePath}/secret_root_CA.key" -sha256 -days 800 \
    -out "${servicePath}/secret_root_CA.pem" -subj "$subject"

  cat <<EOF >"${servicePath}/secret_v3.ext"
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
EOF

  echo "DNS.1 = ${primaryDomain}" >>"${servicePath}/secret_v3.ext"
  local secondaryDomainsCount=${#secondaryDomains[*]}

  if [ "$secondaryDomainsCount" -gt 0 ]; then
    for ((i = 0; i <= $((secondaryDomainsCount - 1)); i++)); do
      echo "DNS.$((i + 2)) = ${secondaryDomains[$i]}" >>"${servicePath}/secret_v3.ext"
    done
  fi

  openssl req -new -newkey rsa:2048 -sha256 -nodes \
    -newkey rsa:2048 -keyout "${servicePath}/secret.key" \
    -subj "$subject" \
    -out "${servicePath}/secret.csr"

  openssl x509 -req -in "${servicePath}/secret.csr" \
    -CA "${servicePath}/secret_root_CA.pem" \
    -CAkey "${servicePath}/secret_root_CA.key" \
    -CAcreateserial \
    -out "${servicePath}/secret.crt" \
    -days 800 -sha256 -extfile "${servicePath}/secret_v3.ext"

  echo -e "${COLOR__GREEN} Certificates have been generated successfully! ${COLOR__DEFAULT}"
}

cleanup() {
  echo -e "${COLOR__YELLOW} Post-gen cleanup ${COLOR__DEFAULT}"

  read -p "Do you want to cleanup meta-files left after the certs generating process? [Yn] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -f \
      "${servicePath}/secret_v3.ext" \
      "${servicePath}/secret.csr" \
      "${servicePath}/secret_root_CA.pem" \
      "${servicePath}/secret_root_CA.srl" \
      "${servicePath}/secret_root_CA.key"

    echo -e "${COLOR__GREEN} Cleanup finished ${COLOR__DEFAULT}"
  else
    echo -e "${COLOR__GREEN} Finishing without cleanup. Don't forget to remove all the meta-files! ${COLOR__DEFAULT}"
  fi
}

main() {
  intro
  readDomains
  generateCerts
  cleanup
}

main
