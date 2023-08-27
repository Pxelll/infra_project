#!/bin/bash
cd /home/ubuntu
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip-py
sudo python3 -m pip install ansible
tee -a playbook.yml > /dev/null <<EOT
- hosts: localhost
  become: yes #isso eh para que todas as tasks tenham permissao privilegiada
  tasks:
  #----------------->
  - name: Instalando o python3, virtualenv
    apt:
      pkg:
      - python3
      - virtualenv
      update_cache: yes
    become: yes
  #------------------>
  - name: git clone
    become: yes
    git:
      repo: https://github.com/alura-cursos/clientes-leo-api.git
      dest: /home/ubuntu/tcc
      version: master
      clone: yes
      force: yes
  #------------------>
  - name: Instalando dependencias com pip (Django e Django Rest)
    become: yes
    pip:
      virtualenv: /home/ubuntu/tcc/venv
      requirements: /home/ubuntu/tcc/requirements.txt
  #------------------>
  - name: Verificando se o projeto ja existe
    stat:
      path: /home/ubuntu/tcc/setup/settings.py
    register: projeto
  #------------------>
  - name: Iniciando o projeto
    shell: '. /home/ubuntu/tcc/venv/bin/activate; django-admin startproject setup /home/ubuntu/tcc/'
    when: not projeto.stat.exists
  #------------------>
  - name: Alterando o hosts do settings
    lineinfile:
      path: /home/ubuntu/tcc/setup/settings.py
      regexp: 'ALLOWED_HOSTS'
      line: 'ALLOWED_HOSTS = ["*"]'
      backrefs: yes
  #------------------>
  - name: migrate database
    shell: '. /home/ubuntu/tcc/venv/bin/activate; python /home/ubuntu/tcc/manage.py migrate'
  #------------------>
  - name: loaddata database
    shell: '. /home/ubuntu/tcc/venv/bin/activate; python /home/ubuntu/tcc/manage.py loaddata clientes.json'
  #------------------>
  - name: server start
    shell: '. /home/ubuntu/tcc/venv/bin/activate; nohup python /home/ubuntu/tcc/manage.py runserver 0.0.0.0:8000 &'
EOT
ansible-playbook playbook.yml