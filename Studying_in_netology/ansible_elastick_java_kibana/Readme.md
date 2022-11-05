## 8.3
# 1. Выполнено 
# 2.
    ansible-galaxy install --role-file=requirements.yml --roles-path=roles --force
    - changing role java from 1.0.1 to 1.0.1
    - extracting java to /home/mikhail/devops/ansible/8.3/playbook/roles/java
    - java (1.0.1) was installed successfully
        molecule test
        ---
        dependency:
        name: galaxy
        driver:
        name: docker
        platforms:
        - image: docker.io/pycontribs/centos:8
            name: centos8
            pre_build_image: true
        - image: docker.io/pycontribs/centos:7
            name: centos7
            pre_build_image: true
        - image: docker.io/pycontribs/ubuntu:latest
            name: ubuntu
            pre_build_image: true
        provisioner:
        inventory:
            group_vars:
            all:
                java_home: /opt/jdk/{{ jdk_folder }}
                jdk_distr_name: openjdk-11-linux.tar.gz
                jdk_distr_type: remote
                jdk_folder: '{{ jdk_distr_name.split(''-'')[:2] | join(''-'')  }}'
                jdk_url: '{{ openjdk[11] }}'
        name: ansible
        verifier:
        name: ansible
# 3.
    molecule init scenario -r elastic-role elastic-role/
    INFO     Initializing new scenario elastic-role/...
    INFO     Initialized scenario in /home/mikhail/devops/ansible/8.3/playbook/roles/elastic-role/molecule/elastic-role/ successfully.
    /home/mikhail/.local/bin/molecule test                              
    ---
    dependency:
    name: galaxy
    driver:
    name: docker
    platforms:
    - image: docker.io/pycontribs/centos:7
        name: instance
        pre_build_image: true
    provisioner:
    name: ansible
    verifier:
    name: ansible

# 4.
    molecule test
    ---
    dependency:
    name: galaxy
    driver:
    name: docker
    lint: "set -e \nyamllint\nansible-lint\n"
    platforms:
    - capabilities:
        - SYS_ADMIN
        command: /usr/sbin/init
        image: registry.access.redhat.com/ubi8/ubi-init
        name: rhel8
        pre_build_image: true
        tmpfs:
        - /run
        - /tmp
        volumes:
        - /sys/fs/cgroup:/sys/fs/cgroup:ro
    - capabilities:
        - SYS_ADMIN
        command: /lib/systemd/systemd
        image: geerlingguy/docker-ubuntu2004-ansible
        name: ubuntu
        tmpfs:
        - /run
        - /tmp
        volumes:
        - /sys/fs/cgroup:/sys/fs/cgroup:ro
    provisioner:
    name: ansible
    verifier:
    name: ansible
# 5.
    molecule init scenario -r kibana-role 
    INFO     Initializing new scenario default...
    INFO     Initialized scenario in /home/mikhail/devops/ansible/8.3/playbook/roles/kibana-role/molecule/default successfully.
# 6.
    molecule test
    ---
    dependency:
    name: galaxy
    driver:
    name: docker
    lint: "set -e \nyamllint\nansible-lint\n"
    platforms:
    - capabilities:
        - SYS_ADMIN
        command: /usr/sbin/init
        image: registry.access.redhat.com/ubi8/ubi-init
        name: rhel8
        pre_build_image: true
        tmpfs:
        - /run
        - /tmp
        volumes:
        - /sys/fs/cgroup:/sys/fs/cgroup:ro
    - capabilities:
        - SYS_ADMIN
        command: /lib/systemd/systemd
        image: geerlingguy/docker-ubuntu2004-ansible
        name: ubuntu
        tmpfs:
        - /run
        - /tmp
        volumes:
        - /sys/fs/cgroup:/sys/fs/cgroup:ro
    provisioner:
    name: ansible
    verifier:
    name: ansible
# 8.
requirements.yml
    ---
    - src: git@github.com:netology-code/mnt-homeworks-ansible.git
        scm: git
        version: "1.0.1"
        name: java
        path: ./java
    
    - src: git@github.com:MikhailShapovalov26/elastic.git
        scm: git
        version: "1.0.1"
        name: elastic
        path: ./elastic-role 
    
    - src: git@github.com:MikhailShapovalov26/kibana.git
        scm: git
        version: "2.0.2"
        name: kibana
        path: ./kibana-role

# 9.

Теперь попробуем запустить данные роли на докер контейнере и проверить

    ansible-playbook -i  inventory/prod.yml  site.yml   

    PLAY [install python3] *********************************************************************************************************************************

    TASK [install python3] *********************************************************************************************************************************
    changed: [debian]

    PLAY [Install Java and elasticsearch] ******************************************************************************************************************

    TASK [debug] *******************************************************************************************************************************************
    ok: [debian] => {
        "ansible_host": "debian"
    }

    TASK [java : Upload .tar.gz file containing binaries from local storage] *******************************************************************************
    skipping: [debian]

    TASK [java : Upload .tar.gz file conaining binaries from remote storage] *******************************************************************************
    ok: [debian]

    TASK [java : Ensure installation dir exists] ***********************************************************************************************************
    ok: [debian]

    TASK [java : Extract java in the installation directory] ***********************************************************************************************
    skipping: [debian]

    TASK [java : Export environment variables] *************************************************************************************************************
    ok: [debian]

    PLAY [Install Elasticsearch] ***************************************************************************************************************************

    TASK [debug] *******************************************************************************************************************************************
    ok: [debian] => {
        "ansible_host": "debian"
    }

    TASK [elastic-role : check filesystem existence] *******************************************************************************************************
    changed: [debian]

    TASK [elastic-role : Upload tar.gz Elasticsearch from remote URL] **************************************************************************************
    skipping: [debian]

    TASK [elastic-role : Create directrory for Elasticsearch] **********************************************************************************************
    ok: [debian]

    TASK [elastic-role : Extract Elasticsearch in the installation directory] ******************************************************************************
    skipping: [debian]

    TASK [elastic-role : Set environment Elastic] **********************************************************************************************************
    ok: [debian]

    PLAY [Install Kibana] **********************************************************************************************************************************

    TASK [debug] *******************************************************************************************************************************************
    ok: [debian] => {
        "ansible_host": "debian"
    }

    TASK [kibana-role : check filesystem existence] ********************************************************************************************************
    changed: [debian]

    TASK [kibana-role : check filesystem existence] ********************************************************************************************************
    changed: [debian]

    TASK [kibana-role : dowland kibana] ********************************************************************************************************************
    skipping: [debian]

    TASK [kibana-role : Create directory from kibana] ******************************************************************************************************
    ok: [debian]

    TASK [kibana-role : Coppy to files bin] ****************************************************************************************************************
    skipping: [debian]

    TASK [kibana-role : set environment kibana] ************************************************************************************************************
    ok: [debian]

    PLAY RECAP *********************************************************************************************************************************************
    debian                     : ok=14   changed=4    unreachable=0    failed=0    skipped=6    rescued=0    ignored=0   
# 10.
[playbook](playbook/site.yml)