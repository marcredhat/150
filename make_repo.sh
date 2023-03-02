#!/bin/bash
export username="<license username>"
export password="<license password"

export REPO_HOME=/repo/cloudera/p
export REPO_SOURCE="https://${username}:${password}@archive.cloudera.com/p"
export CDH_VERSIONS=(7.1.7.2000 7.1.7.1000 7.1.8.0)
export CDF_VERSIONS=(2.1.5.0)
export CSA_VERSIONS=(1.7.0.0 1.8.0.2)
export CDP_PVC_DS_VERSIONS=(1.5.0)
export CM_VERSIONS=(7.9.5 7.6.5)

mkdir -p ${REPO_HOME}

for CDH_VERSION in ${CDH_VERSIONS[@]}; do
  echo "Downloading CDH ${CDH_VERSION}"
  wget -nv -r -np -l 2 -nH --cut-dirs=3 --reject "index.html*" --accept "*-el8.parcel*,manifest.json" ${REPO_SOURCE}/cdh7/${CDH_VERSION}/parcels/ -P ${REPO_HOME}/cdh7/${CDH_VERSION}/
done

for CDF_VERSION in ${CDF_VERSIONS[@]}; do
  echo "Downloading CDF ${CDF_VERSION}"
  wget  -nv -r -np -l 2 -nH --cut-dirs=6 --reject "index.html*" --accept "*-el8.parcel*,manifest.json,*.jar" ${REPO_SOURCE}/cfm2/${CDF_VERSION}/redhat8/yum/tars/parcel/ -P ${REPO_HOME}/cfm2/${CDF_VERSION}/redhat8/yum/tars/
done

for CSA_VERSION in ${CSA_VERSIONS[@]}; do
  echo "Downloading CSA ${CSA_VERSION}"
  wget  -nv -r -np -l 2 -nH --cut-dirs=3 --reject "index.html*" --accept "*-el8.parcel*,manifest.json,*.jar" ${REPO_SOURCE}/csa/${CSA_VERSION}/parcels/ -P ${REPO_HOME}/csa/${CSA_VERSION}/
  wget  -nv -r -np -l 2 -nH --cut-dirs=3 --reject "index.html*" --accept "*-el8.parcel*,manifest.json,*.jar" ${REPO_SOURCE}/csa/${CSA_VERSION}/csd/ -P ${REPO_HOME}/csa/${CSA_VERSION}/
done

for CDP_PVC_DS_VERSION in ${CDP_PVC_DS_VERSIONS[@]}; do
  echo "Downloading DS ${CDP_PVC_DS_VERSION}"
  wget  -nv -r -np -l 2 -nH --cut-dirs=3 --reject "index.html*" ${REPO_SOURCE}/cdp-pvc-ds/${CDP_PVC_DS_VERSION} -P ${REPO_HOME}/cdp-pvc-ds/${CDP_PVC_DS_VERSION}
done

for CM_VERSION in ${CM_VERSIONS[@]}; do
  echo "Downloading CM ${CM_VERSION}"
  wget  -nv -nc ${REPO_SOURCE}cm7/${CM_VERSION}/repo-as-tarball/cm${CM_VERSION}-redhat8.tar.gz -P ${REPO_HOME}/cm7/${CM_VERSION}/repo-as-tarball
  mkdir ${REPO_HOME}/cm7/${CM_VERSION}/redhat8/
                                                                                                                                                     34,1          Top
  wget  -nv -nc ${REPO_SOURCE}cm7/${CM_VERSION}/repo-as-tarball/cm${CM_VERSION}-redhat8.tar.gz -P ${REPO_HOME}/cm7/${CM_VERSION}/repo-as-tarball
  mkdir ${REPO_HOME}/cm7/${CM_VERSION}/redhat8/
  tar -xzvf ${REPO_HOME}/cm7/${CM_VERSION}/repo-as-tarball/cm${CM_VERSION}-redhat8.tar.gz -C /tmp
  mv /tmp/cm${CM_VERSION} ${REPO_HOME}/cm7/${CM_VERSION}/redhat8/yum
done
