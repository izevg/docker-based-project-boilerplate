#!/usr/bin/env bash

# Certificates encrypting/decrypting based on the Ansible Vault.
# Heavily depends on the project structure.
# Author: Eugene Zhukov <jack.zhukov@gmail.com>

# Get the service name for any further operation (encrypt/decrypt)
intro () {
  echo -e "${COLOR__YELLOW} Please, specify the service name for further operations ${COLOR__DEFAULT}"
  read -r -p "Docker service name: " serviceName

  encryptedStorageDirectory="./secrets.d/cert.d/enc.d"
  decryptedStorageDirectory="./secrets.d/cert.d/dec.d"
}

# Select an appropriate operation to do with secrets
selectOperation () {
  local operations=("encrypt" "decrypt")

  echo -e "${COLOR__YELLOW} What operation do you want to perform? (select a number) ${COLOR__DEFAULT}"
  select operation in "${operations[@]}"; do
    case $operation in
    "encrypt")
      encrypt
      break
      ;;
    "decrypt")
      decrypt
      break
      ;;
    "Quit")
      break
      ;;
    *) echo -e "${COLOR__RED} invalid option $operation ${COLOR__DEFAULT}" ;;
    esac
  done
}

# Encrypt a secret
encrypt () {
  local pathForEncrypt="${decryptedStorageDirectory}/${serviceName}"
  local certFileName

  if [ ! -d "$pathForEncrypt" ]; then
    echo -e "${COLOR__RED} Cannot find the appropriate service in the secrets.d/cert.d directory! Aborting."
    exit 1
  fi

  echo -e "${COLOR__YELLOW} Please, specify cert's filename to encrypt ${COLOR__DEFAULT}"
  read -r -p "Certificate file name: " certFileName
  local fileToEncrypt="${pathForEncrypt}/${certFileName}"
  local whereToStore="${encryptedStorageDirectory}/${serviceName}.${DOCKER__ENV}.${certFileName}.enc"

  if [ ! -f "$fileToEncrypt" ]; then
    echo -e "${COLOR__RED} Cannot find the selected file! Aborting."
    exit 1
  else
    echo -e "${COLOR__YELLOW} Encrypting the certificate for the \"${DOCKER__ENV}\" environment ${COLOR__DEFAULT}"
    docker run \
      --volume="$(pwd):/ansible" \
      -it --rm \
      "${COMPOSE_PROJECT_NAME}__ansible:latest" \
      encrypt "$fileToEncrypt" --output="${whereToStore}"
    echo -e "${COLOR__GREEN} The certificate for the \"${DOCKER__ENV}\" environment was successfully encrypted ${COLOR__DEFAULT}"
  fi
}

# Decrypt a secret
decrypt () {
  local certFileName

  echo -e "${COLOR__YELLOW} Please, specify cert's filename to decrypt ${COLOR__DEFAULT}"
  read -r -p "Certificate file name: " certFileName
  local whereItIsStored="${encryptedStorageDirectory}/${serviceName}.${DOCKER__ENV}.${certFileName}.enc"

  if [ ! -f "$whereItIsStored" ]; then
    echo -e "${COLOR__RED} Cannot find the encrypted file! Aborting."
    exit 1
  else
    local decryptedServicePath="${decryptedStorageDirectory}/${serviceName}"

    if [ ! -d "$decryptedServicePath" ]; then
      mkdir -p "$decryptedServicePath"
    fi

    local whereToStore="${decryptedServicePath}/${certFileName}"

    echo -e "Decrypting the certificate"
    docker run \
      --volume="$(pwd)/:/ansible" \
      --rm -it \
      "${COMPOSE_PROJECT_NAME}__ansible:latest" \
      decrypt "${whereItIsStored}" --output="$whereToStore"
    sudo chown "$USER" .env
  fi
}

# Combine intro step and secrets operations into flow
main () {
  intro
  selectOperation
}

# Run the flow
main