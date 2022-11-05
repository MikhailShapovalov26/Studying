# 8.01
## 1.

    ansible-playbook -i inventory/test.yml site.yml

    PLAY [Print os facts] *************************************************************************************************************************************************

    TASK [Gathering Facts] ************************************************************************************************************************************************
    [WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python, but future installation of another Python interpreter could
    change this. See https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for more information.
    ok: [localhost]

    TASK [Print OS] *******************************************************************************************************************************************************
    ok: [localhost] => {
        "msg": "Linux Mint"
    }

    TASK [Print fact] *****************************************************************************************************************************************************
    ok: [localhost] => {
        "msg": 12
    }

    PLAY RECAP ************************************************************************************************************************************************************
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
# 2.

    ansible-playbook -i inventory/test.yml site.yml

    PLAY [Print os facts] *************************************************************************************************************************************************

    TASK [Gathering Facts] ************************************************************************************************************************************************
    [WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python, but future installation of another Python interpreter could
    change this. See https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for more information.
    ok: [localhost]

    TASK [Print OS] *******************************************************************************************************************************************************
    ok: [localhost] => {
        "msg": "Linux Mint"
    }

    TASK [Print fact] *****************************************************************************************************************************************************
    ok: [localhost] => {
        "msg": "all default fact"
    }

    PLAY RECAP ************************************************************************************************************************************************************
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
# 3.

    docker ps
    CONTAINER ID   IMAGE      COMMAND            CREATED         STATUS         PORTS     NAMES
    18e5b9a780e3   ubuntu     "sleep infinity"   2 seconds ago   Up 1 second              deb
    c6c529ea722b   centos:7   "/usr/sbin/init"   4 minutes ago   Up 2 minutes             el
## 4.
    ansible-playbook -i inventory/prod.yml site.yml         

    PLAY [Print os facts] *************************************************************************************************************************************************

    TASK [Gathering Facts] ************************************************************************************************************************************************
    ok: [debian]
    ok: [cent]

    TASK [Print OS] *******************************************************************************************************************************************************
    ok: [cent] => {
        "msg": "CentOS"
    }
    ok: [debian] => {
        "msg": "Ubuntu"
    }

    TASK [Print fact] *****************************************************************************************************************************************************
    ok: [debian] => {
        "msg": "deb"
    }
    ok: [cent] => {
        "msg": "el"
    }

    PLAY RECAP ************************************************************************************************************************************************************
    cent                       : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    debian                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
## 6.
Такие портянки большие

    TASK [Print fact] *****************************************************************************************************************************************************
    ok: [cent] => {
        "msg": "el default fact"
    }
    ok: [debian] => {
        "msg": "deb default fact"
    }
## 7.

    ansible-vault encrypt group_vars/deb/examp.yml 
    New Vault password: 
    Confirm New Vault password: 
    Encryption successful
    ansible-vault encrypt group_vars/el/examp.yml
    New Vault password: 
    Confirm New Vault password: 
    Encryption successful
## 8.

    ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
    Vault password: 

    PLAY [Print os facts] *************************************************************************************************************************************************

    TASK [Gathering Facts] ************************************************************************************************************************************************
    ok: [debian]
    ok: [cent]
и т.д.
## 11-12

        ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
        Vault password: 

        PLAY [Print os facts] *************************************************************************************************************************************************

        TASK [Gathering Facts] ************************************************************************************************************************************************
        ok: [debian]
        ok: [cent]
        [WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python, but future installation of another Python interpreter could
        change this. See https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for more information.
        ok: [localhost]

        TASK [Print OS] *******************************************************************************************************************************************************
        ok: [localhost] => {
            "msg": "Linux Mint"
        }
        ok: [debian] => {
            "msg": "Ubuntu"
        }
        ok: [cent] => {
            "msg": "CentOS"
        }

        TASK [Print fact] *****************************************************************************************************************************************************
        ok: [localhost] => {
            "msg": "local"
        }
        ok: [cent] => {
            "msg": "el default fact"
        }
        ok: [debian] => {
            "msg": "deb default fact"
        }

        PLAY RECAP ************************************************************************************************************************************************************
        cent                       : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
        debian                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
        localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
# Доп задание 
    bash ./script.sh
    docker: Error response from daemon: Conflict. The container name "/cent" is already in use by container "40d0c8ffc21d77ac84f70ddb28df359ea6ed3368cc2100b5c59bdb206982d4c2". You have to remove (or rename) that container to be able to reuse that name.
    See 'docker run --help'.
    docker: Error response from daemon: Conflict. The container name "/debian" is already in use by container "8eb1ed33cc361e3c80515aa5babc48fa29421dd10ba9b2bb7f71b74271112603". You have to remove (or rename) that container to be able to reuse that name.
    See 'docker run --help'.
    Hit:1 http://archive.ubuntu.com/ubuntu jammy InRelease                         
    Hit:2 http://archive.ubuntu.com/ubuntu jammy-updates InRelease
    Hit:3 http://archive.ubuntu.com/ubuntu jammy-backports InRelease
    Hit:4 http://security.ubuntu.com/ubuntu jammy-security InRelease
    Reading package lists... Done
    Building dependency tree... Done
    Reading state information... Done
    9 packages can be upgraded. Run 'apt list --upgradable' to see them.
    Reading package lists... Done
    Building dependency tree... Done
    Reading state information... Done
    python3 is already the newest version (3.10.4-0ubuntu2).
    0 upgraded, 0 newly installed, 0 to remove and 9 not upgraded.
    Vault password: 

    PLAY [Print os facts] **********************************************************

    TASK [Gathering Facts] *********************************************************
    [WARNING]: Platform linux on host localhost is using the discovered Python
    interpreter at /usr/bin/python, but future installation of another Python
    interpreter could change this. See https://docs.ansible.com/ansible/2.9/referen
    ce_appendices/interpreter_discovery.html for more information.
    ok: [localhost]
    ok: [debian]
    ok: [cent]

    TASK [Print OS] ****************************************************************
    ok: [localhost] => {
        "msg": "Linux Mint"
    }
    ok: [cent] => {
        "msg": "CentOS"
    }
    ok: [debian] => {
        "msg": "Ubuntu"
    }

    TASK [Print fact] **************************************************************
    ok: [localhost] => {
        "msg": "local"
    }
    ok: [cent] => {
        "msg": "el default fact"
    }
    ok: [debian] => {
        "msg": "deb default fact"
    }

    PLAY RECAP *********************************************************************
    cent                       : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    debian                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
    localhost                  : ok=3    changed=0    unreachable=0    