

![alt text](images/clusterlayout.png)

![alt text](images/machinelayout.png)

![alt text](images/machines2.png)


#### Marc - repo setup

```
sudo yum install -y httpd  mod_ssl net-tools
sudo systemctl enable httpd
```

```
sudo mv /var/www/html /var/www/html.orig
sudo mkdir -p /repo/cloudera
sudo ln -s /repo/cloudera /var/www/html
```

```
sudo cp base.local.crt /etc/httpd/host.pem
sudo cp base.local.key /etc/httpd/host.key
sudo cat root_ca.crt intermediate_ca.crt >/etc/httpd/cabundle.pem
```

```
<VirtualHost 10.10.10.202:443>
    DocumentRoot /var/www/html
    ServerName full1.base.local
        SSLEngine on
        SSLCertificateFile     /etc/httpd/host.pem
        SSLCertificateKeyFile  /etc/httpd/host.key
        SSLCertificateChainFile /etc/httpd/cabundle.pem
</VirtualHost>
```

```
sudo systemctl restart httpd
sudo systemctl status httpd
```

```
export username=""
export password=""
```

```
export REPO_HOME=/repo/cloudera/p
export REPO_SOURCE="https://${username}:${password}@archive.cloudera.com/p"
export CDH_VERSIONS=(7.1.7.2000 7.1.7.1000 7.1.8.0)
export CDF_VERSIONS=(2.1.5.0)
export CSA_VERSIONS=(1.7.0.0 1.8.0.2)
export CDP_PVC_DS_VERSIONS=(1.5.0)
export CM_VERSIONS=(7.9.5 7.6.5)
```

```
mkdir -p ${REPO_HOME}
```

```
for CDH_VERSION in ${CDH_VERSIONS[@]}; do
  echo "Downloading CDH ${CDH_VERSION}"
  wget -nv -r -np -l 2 -nH --cut-dirs=3 --reject "index.html*" --accept "*-el8.parcel*,manifest.json" ${REPO_SOURCE}/cdh7/${CDH_VERSION}/parcels/ -P ${REPO_HOME}/cdh7/${CDH_VERSION}/
done
```

```
for CDF_VERSION in ${CDF_VERSIONS[@]}; do
  echo "Downloading CDF ${CDF_VERSION}"
  wget  -nv -r -np -l 2 -nH --cut-dirs=6 --reject "index.html*" --accept "*-el8.parcel*,manifest.json,*.jar" ${REPO_SOURCE}/cfm2/${CDF_VERSION}/redhat8/yum/tars/parcel/ -P ${REPO_HOME}/cfm2/${CDF_VERSION}/redhat8/yum/tars/
done
```

```
for CSA_VERSION in ${CSA_VERSIONS[@]}; do
  echo "Downloading CSA ${CSA_VERSION}"
  wget  -nv -r -np -l 2 -nH --cut-dirs=3 --reject "index.html*" --accept "*-el8.parcel*,manifest.json,*.jar" ${REPO_SOURCE}/csa/${CSA_VERSION}/parcels/ -P ${REPO_HOME}/csa/${CSA_VERSION}/
  wget  -nv -r -np -l 2 -nH --cut-dirs=3 --reject "index.html*" --accept "*-el8.parcel*,manifest.json,*.jar" ${REPO_SOURCE}/csa/${CSA_VERSION}/csd/ -P ${REPO_HOME}/csa/${CSA_VERSION}/
done
```

```
for CDP_PVC_DS_VERSION in ${CDP_PVC_DS_VERSIONS[@]}; do
  echo "Downloading DS ${CDP_PVC_DS_VERSION}"
  wget  -nv -r -np -l 2 -nH --cut-dirs=3 --reject "index.html*" ${REPO_SOURCE}/cdp-pvc-ds/${CDP_PVC_DS_VERSION} -P ${REPO_HOME}/cdp-pvc-ds/${CDP_PVC_DS_VERSION}
done
```

```
for CM_VERSION in ${CM_VERSIONS[@]}; do
  echo "Downloading CM ${CM_VERSION}"
  wget  -nv -nc ${REPO_SOURCE}/cm7/${CM_VERSION}/repo-as-tarball/cm${CM_VERSION}-redhat8.tar.gz -P ${REPO_HOME}/cm7/${CM_VERSION}/repo-as-tarball
  mkdir ${REPO_HOME}/cm7/${CM_VERSION}/redhat8/
  tar -xzvf ${REPO_HOME}/cm7/${CM_VERSION}/repo-as-tarball/cm${CM_VERSION}-redhat8.tar.gz -C /tmp
  mv /tmp/cm${CM_VERSION} ${REPO_HOME}/cm7/${CM_VERSION}/redhat8/yum
done
```

```
nohup ./make_repo.sh > make_repo.sh.log 2>&1 &
```

#### Marc - certs

```
sudo step ca certificate *.base.local base.local.crt base.local.key --kty=RSA --password-file /home/rocky/password -f  --size 2048
sudo step ca certificate *.ecs.base.local ecs.base.local.crt ecs.base.local.key --kty=RSA --password-file /home/rocky/password -f  --size 2048
sudo step ca certificate *.apps.ecs.base.local apps.ecs.base.local.crt apps.ecs.base.local.key --kty=RSA --password-file /home/rocky/password -f  --size 2048
```

```
for i in $(seq 0 40); do
sudo step ca certificate full${i}.base.local full${i}.base.local.crt full${i}.base.local.key --kty=RSA --password-file /home/rocky/password -f  --size 2048
done
```


##### Generate all the certs in a local folder

```
for NODE in `ls -1 full*.key|sed "s/.key//g"`;do
openssl pkcs12 -export -in ${NODE}.crt -inkey ${NODE}.key -certfile ${NODE}.crt -out tmpkeystore.p12 -password pass:<password> -name ${NODE}
keytool -importkeystore -srckeystore tmpkeystore.p12 -srcstoretype pkcs12 -destkeystore ${NODE}.jks -deststoretype JKS -alias ${NODE} -srcstorepass <password> -deststorepass <password>
rm -rf tmpkeystore.p12
done
```

##### Marc - playbooks setup

```
export MY_WORKSPACE=/home/rocky/cloudera-playbooks
export ANSIBLE_COLLECTIONS_PATH=${MY_WORKSPACE}/cldr-runner/collections
```

## create the workspace if it does not exists

```
mkdir -p ${MY_WORKSPACE}
```

```
python3 -m venv ${MY_WORKSPACE}/OPEN-env
. ${MY_WORKSPACE}/OPEN-env/bin/activate
```

```
pip install --upgrade pip
```

```
sudo yum install -y git
###start installing Cloudera's playbooks
cd ${MY_WORKSPACE} && git clone https://github.com/cloudera-labs/cldr-runner
cd  ${MY_WORKSPACE}/cldr-runner && git checkout devel-pvc-update && git pull
```

#install ansible and initial collections

```
pip install ansible-base==2.10.16
ansible-galaxy collection install community.general
```

```
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
```


#remove any dependencies not required from the list (pip, google-sdk etc.)
#also - update the git to https:// if it fails

```
ansible-playbook local_development.yml  --extra-vars "ansible_python_interpreter=/usr/libexec/platform-python"
```

```
cd ${ANSIBLE_COLLECTIONS_PATH}/ansible_collections/cloudera/cloud && git checkout devel-pvc-update && git pull
cd ${ANSIBLE_COLLECTIONS_PATH}/ansible_collections/cloudera/exe && git checkout devel-pvc-update && git pull
cd ${ANSIBLE_COLLECTIONS_PATH}/ansible_collections/cloudera/cluster && git checkout devel-pvc-update && git pull
cd ${ANSIBLE_COLLECTIONS_PATH}/cdpy && git checkout devel-pvc-update && git pull
```

```
cat ${ANSIBLE_COLLECTIONS_PATH}/setup-ansible-env.sh
. ${ANSIBLE_COLLECTIONS_PATH}/setup-ansible-env.sh
```

```
echo $ANSIBLE_COLLECTIONS_PATH
echo $ANSIBLE_ROLES_PATH
```

```
cd ${MY_WORKSPACE} && git clone https://github.com/cloudera-labs/cloudera-deploy
cd ${MY_WORKSPACE}/cloudera-deploy && git checkout devel-pvc-update && git pull
```


#######################################################RSYNC################################################################################

```
rsync -av --exclude=".*" /Users/npopa/eclipse-workspace/OPEN-deploy-definitions/* rocky@54.200.238.248:cloudera-playbooks/OPEN-deploy-definitions
rsync -av --exclude=".*" /Users/npopa/eclipse-workspace/cloudera-deploy/* rocky@54.200.238.248:cloudera-playbooks/cloudera-deploy
rsync -av --exclude=".*" /Users/npopa/eclipse-workspace/cldr-runner/* rocky@54.200.238.248:cloudera-playbooks/cldr-runner
date;
```

############################################################################################################################################
#### Marc - playbooks run

##### Activate the cloudera playbooks python env

```
export MY_WORKSPACE=/home/rocky/cloudera-playbooks
export ANSIBLE_COLLECTIONS_PATH=${MY_WORKSPACE}/cldr-runner/collections
export ANSIBLE_ROLES_PATH=${ANSIBLE_COLLECTIONS_PATH}/roles
```

```
echo $ANSIBLE_COLLECTIONS_PATH
echo $ANSIBLE_ROLES_PATH
```

```
. ${MY_WORKSPACE}/OPEN-env/bin/activate
```

```
cd ${MY_WORKSPACE}/cloudera-deploy
```



##### Deploy cluster

###WA### - SSB JDBC fix

```
ansible all -i ~/server-list.txt -l "full6*" -m shell -a "sudo mkdir -p /usr/share/java/;sudo wget https://jdbc.postgresql.org/download/postgresql-42.2.27.jre7.jar -O /usr/share/java/postgresql-connector-java.jar;sudo chmod 644 /usr/share/java/postgresql-connector-java.jar" -e "ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=rocky" -f 50
```


###WA - HA proxy - we need to do this manually for now

```
#ansible all -i ~/server-list.txt  -l "full1*" -m copy -a "src=${MY_WORKSPACE}/haproxy.conf.sh dest=/home/rocky" -e "ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=rocky" -f 50
#ansible all -i ~/server-list.txt  -l "sbybaselb20*" -m shell -a 'chmod +x haproxy.conf.sh; sudo ./haproxy.conf.sh;sudo systemctl restart haproxy;sudo systemctl status haproxy' -f 50 -e "ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=rocky"
```

```
ansible all -i ~/server-list.txt  -m shell -a "sudo yum install -y libselinux-python3" -e "ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=rocky" -f 50
```


```
ansible all -i ~/server-list.txt  -m shell -a "sudo yum install -y python3" -e "ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=rocky" -f 50
```

# Run the 'external' system configuration


```
ansible-playbook -i ${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/inventory_static.ini \
   -e @${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/constants.yml \
   -e "definition_path=${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/" \
   -e "ansible_python_interpreter=/usr/bin/python3 ansible_os_family=RedHat" \
   -f 20 \
   pvc_base_prereqs_ext.yml
```


###WA - set permissions on the full_truststore###

```
ansible all -i ~/server-list.txt -m shell -a 'sudo chmod 644 /opt/cloudera/security/pki/full_truststore.jks' -f 50 -e "ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=rocky"
```

###WA - NIFI cert ###

```
ansible all -i ~/server-list.txt  -l "full2[0-3]*" -m copy -a "src=${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/resources/certs/nifi/{{ inventory_hostname }}.jks dest=/home/rocky/nifi.jks" -e "ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=rocky ansible_python_interpreter=/usr/bin/python3" -f 50
```

```
ansible all -i ~/server-list.txt  -l "full2[0-3]*" -m shell -a 'sudo mv /home/rocky/nifi.jks /opt/cloudera/security/pki/;sudo chmod 644 /opt/cloudera/security/pki/nifi.jks' -f 50 -e "ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=rocky ansible_python_interpreter=/usr/bin/python3"
```


###WA - ECS cert ###

```
ansible all -i ~/server-list.txt -l "full4*" -m copy -a "src=${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/resources/certs/apps.ecs.base.local.pem dest=/opt/cloudera/security/pki/apps.ecs.base.local.pem" -e "ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=rocky ansible_python_interpreter=/usr/bin/python3" -f 50 -become
```

```
ansible all -i ~/server-list.txt -l "full4*" -m shell -a 'sudo chmod 644 /opt/cloudera/security/pki/apps.ecs.base.local.pem' -f 50 -e "ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=rocky"
```

```
ansible all -i ~/server-list.txt -l "full4*" -m copy -a "src=${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/resources/certs/apps.ecs.base.local.key dest=/opt/cloudera/security/pki/apps.ecs.base.local.key" -e "ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=rocky ansible_python_interpreter=/usr/bin/python3" -f 50 -become
```

```
ansible all -i ~/server-list.txt -l "full4*" -m shell -a 'sudo chmod 644 /opt/cloudera/security/pki/apps.ecs.base.local.key' -f 50 -e "ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_user=rocky"
```


# Run the 'internal' Cloudera installations and configurations

```
ansible-playbook -i ${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/inventory_static.ini \
   -e @${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/constants.yml \
   -e "definition_path=${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/" \
   -e "ansible_python_interpreter=/usr/bin/python3 ansible_os_family=RedHat" \
   -f 20 \
   pvc_base_prereqs_int.yml
```

# Run the Cloudera BASE cluster configuration and imports

```
ansible-playbook -i ${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/inventory_static.ini \
   -e @${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/constants.yml \
   -e "definition_path=${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/" \
   -e "to_depoly=base" \
   -f 20 \
   pvc_base_setup.yml
```


# Run the Cloudera ENCRYPTION configuration and imports

```
ansible-playbook -i ${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/inventory_static.ini \
   -e @${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/constants.yml \
   -e "definition_path=${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/" \
   -e "ansible_python_interpreter=/usr/bin/python3 ansible_os_family=RedHat" \
   -f 20 \
   pvc_base_encryption_setup.yml
```

# Run the Cloudera COMPUTE (CSA, CDF etc.)cluster/s configuration and imports

```
ansible-playbook -i ${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/inventory_static.ini \
   -e @${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/constants.yml \
   -e "definition_path=${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/" \
   -e "to_depoly=compute" \
   -e "ansible_python_interpreter=/usr/bin/python3 ansible_os_family=RedHat" \
   -f 20 \
   pvc_base_setup.yml
```


# Run the Cloudera ECS cluster configuration and imports

```
ansible-playbook -i ${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/inventory_static.ini \
   -e @${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/constants.yml \
   -e "definition_path=${MY_WORKSPACE}/OPEN-deploy-definitions/OPEN-stg/" \
   -e "ansible_python_interpreter=/usr/bin/python3 ansible_os_family=RedHat" \
   -e "to_depoly=ecs" \
   -f 20 \
   pvc_base_setup.yml
```


# Checks

https://github.com/marcredhat/150/blob/main/checks%20keystore%20truststore.md
https://github.com/marcredhat/150/blob/main/check%20sssd
