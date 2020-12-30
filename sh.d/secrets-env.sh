#!/usr/bin/env bash

# .env files encrypting/decrypting script. Uses Ansible under the hood.
# Author: Eugene Zhukov <jack.zhukov@gmail.com>

envs=("production" "staging" "dev" "local" "Quit")
operations=("encrypt" "decrypt" "Quit")

# Check the vault key before any operations
if [ ! -f ./vault ]; then
  echo -e "${COLOR__RED} ERROR! Ansible's vault-file wasn't found in the project's directory ${COLOR__DEFAULT}"
  exit 1
elif ! docker image inspect "${COMPOSE_PROJECT_NAME}__ansible:latest" &>/dev/null; then
  make build__ansible
fi

# Encrypting function.
# Requires an actual .env-file related to the proper environment
encrypt() {
  if [ ! -f ./.env ]; then
    echo -e "${COLOR__RED} Cannot find an appropriate .env-file to encode. Aborting.${COLOR__DEFAULT}"
    exit 1
  else
    echo -e "${COLOR__YELLOW} Encrypting the .env-file for the \"${DOCKER__ENV}\" environment ${COLOR__DEFAULT}"
    docker run \
      --volume="$(pwd):/ansible" \
      -it --rm \
      "${COMPOSE_PROJECT_NAME}__ansible:latest" \
      encrypt .env --output="./secrets.d/env.d/.env.${DOCKER__ENV}.enc"
    echo -e "${COLOR__GREEN} The .env-file for the \"${DOCKER__ENV}\" environment was successfully encrypted ${COLOR__DEFAULT}"
  fi
}

# Decrypting function.
# Requires the COMPOSE_PROJECT_NAME defined in the Makefile & some encrypted .env's in the 'secrets.d' folder
decrypt_files() {
  echo -e "${COLOR__GREEN} You chose $REPLY which corresponds to the \"$env\" ${COLOR__DEFAULT}"
  echo -e "Decrypting .env-file"
  docker run \
    --volume="$(pwd)/:/ansible" \
    --rm -it \
    "${COMPOSE_PROJECT_NAME}__ansible:latest" \
    decrypt "./secrets.d/env.d/.env.${env}.enc" --output=.env
  sudo chown "$USER" .env
}

# Decrypting entrypoint.
# Allows you to select, for which environment you want to get the .env-file
decrypt() {
  echo -e "${COLOR__YELLOW} What environment you would like to decrypt? (select a number) ${COLOR__DEFAULT}"
  select env in "${envs[@]}"; do
    case $env in
    "production")
      decrypt_files
      break
      ;;
    "staging")
      decrypt_files
      break
      ;;
    "dev")
      decrypt_files
      break
      ;;
    "local")
      decrypt_files
      break
      ;;
    "Quit")
      break
      ;;
    *)
      echo -e "${COLOR__RED} invalid option $env ${COLOR__DEFAULT}"
      exit 1
      ;;
    esac
  done
}

# Script's entrypoint.
# Allows you to select an operation or to pass the operation name to the script.
if [ -n "$1" ]; then
  if [ "$1" == "encrypt" ]; then
    encrypt
    exit 0
  elif [ "$1" == "decrypt" ]; then
    decrypt
    exit 0
  else
    echo -e "Unknown operation was requested. Aborting."
    exit 1
  fi
else
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
fi
