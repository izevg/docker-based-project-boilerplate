# Docker-based Project Boilerplate

For questions like "What is it", "Why it's here" and "Why it looks like this" - I have a pretty-well formed [docs page here](https://blog.ezhukov.space/docs/struktura-proekta/)

## Under the hood

- [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html) for managing secrets
- Secrets managing shell-scripts
- [Make](https://www.gnu.org/software/make/) receipts for all the needed operations for the environment
- Config examples for `local`, `dev`, `staging` and `production` environments
- Sample compose files for all the mentioned environments ([used in combination](https://docs.docker.com/compose/extends/) with a base compose file)
- [Container registry](https://docs.docker.com/registry/) managements samples
- [Docker Swarm](https://docs.docker.com/engine/swarm/) as an orchestrator (_optional_, could be replaced with whatever you want) with corresponding compose settings & Make targets
- Sample structure for a dependent application
- [Traefik](https://doc.traefik.io/traefik/) configuration as an example of how to store & manage services in this kind of project

## Purpose

This repo was created mostly for me, and my projects (because this kind of structure always took quite a lot of time to build from scratch),
but since this structure looks like not a piece of mammoth shit, I decided to create a shared boilerplate for everyone who found this structure
useful.

## Further steps

- [ ] Replace shell scripts with Python scripts
- [ ] Replace Makefiles with consistent Python-based management system
- [ ] Translate docs into English