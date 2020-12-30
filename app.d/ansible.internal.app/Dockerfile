###> Built-in Ansible Vault tool for keeping the sensitive data in a secret
FROM ansible/ansible:ubuntu1604

ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_VAULT_PASSWORD_FILE /ansible/vault

WORKDIR /ansible

RUN pip install --upgrade pip

RUN pip install \
    ansible \
    pywinrm  \
    pysphere \
    pyvmomi \
    kazoo

ENTRYPOINT ["ansible-vault"]
CMD ["--version"]