
# Rook Ceph / OpenShift Data Foundation and Portworx on the same OpenShift 4.10 cluster

# replacing NFS with Portworx px-sharedv4-sc

# creating pods using px-sharedv4-sc


## Check whether you need to increase ncrease the maximum number of pods per node on the worker nodes (default is 250)
```
for i in `oc get nodes | egrep -v "NAME" | awk '{ print $1 }'`;
  do
    echo $i `oc get pods -A --field-selector=spec.host=$i  -o wide | egrep -v "NAME" | wc -l` ;
  done
ip-10-0-131-222.us-west-2.compute.internal 51
ip-10-0-132-120.us-west-2.compute.internal 260
ip-10-0-143-1.us-west-2.compute.internal 21
ip-10-0-144-251.us-west-2.compute.internal 422
ip-10-0-151-136.us-west-2.compute.internal 58
ip-10-0-151-47.us-west-2.compute.internal 247
ip-10-0-167-1.us-west-2.compute.internal 226
ip-10-0-175-9.us-west-2.compute.internal 29
ip-10-0-183-38.us-west-2.compute.internal 217
ip-10-0-194-208.us-west-2.compute.internal 247
ip-10-0-203-246.us-west-2.compute.internal 88
ip-10-0-217-214.us-west-2.compute.internal 251
ip-10-0-227-45.us-west-2.compute.internal 35
ip-10-0-228-24.us-west-2.compute.internal 252
ip-10-0-242-26.us-west-2.compute.internal 62
ip-10-0-248-135.us-west-2.compute.internal 224
```

Follow the procedure to increase the maximum number of pods per node on the worker nodes:
https://access.redhat.com/documentation/en-us/openshift_container_platform/4.10/html/post-installation_configuration/post-install-machine-configuration-tasks



## Ceph

oc rsh rook-ceph-tools-6765648554-8cpgx ceph status
```
  cluster:
    id:     08cf1953-7cb3-4444-a676-c22e74409be0
    health: HEALTH_OK

  services:
    mon: 3 daemons, quorum a,c,d (age 6h)
    mgr: b(active, since 6d), standbys: a
    mds: 1/1 daemons up, 1 hot standby
    osd: 3 osds: 3 up (since 6h), 3 in (since 2w)

  data:
    volumes: 1/1 healthy
    pools:   4 pools, 81 pgs
    objects: 4.97k objects, 18 GiB
    usage:   55 GiB used, 3.7 TiB / 3.8 TiB avail
    pgs:     81 active+clean

  io:
    client:   853 B/s rd, 377 KiB/s wr, 1 op/s rd, 4 op/s wr
```

My Ceph nodes are:

```
oc rsh rook-ceph-tools-6765648554-8cpgx ceph osd tree
ID   CLASS  WEIGHT   TYPE NAME                                                    STATUS  REWEIGHT  PRI-AFF
 -1         3.75966  root default
 -5         3.75966      region us-west-2
 -4         3.75966          zone us-west-2a
 -9         1.26949              host ip-10-0-144-251-us-west-2-compute-internal
  1    ssd  1.26949                  osd.1                                            up   1.00000  1.00000
 -3         1.22069              host ip-10-0-167-1-us-west-2-compute-internal
  0    ssd  1.22069                  osd.0                                            up   1.00000  1.00000
-11         1.26949              host ip-10-0-217-214-us-west-2-compute-internal
  2    ssd  1.26949                  osd.2                                            up   1.00000  1.00000
```


*Let's tag the Ceph nodes so that they are not used by Portworx.*


oc label nodes  ip-10-0-144-251.us-west-2.compute.internal ip-10-0-167-1.us-west-2.compute.internal ip-10-0-217-214.us-west-2.compute.internal.    px/enabled=false --overwrite


## Portworx
StorageCluster: https://github.com/marcredhat/150/blob/main/portworxstoragecluster.yaml

oc rsh px-cluster-be2635e9-0ad1-460c-99fb-8054f24c24ef-6k97d /opt/pwx/bin/pxctl status
```
Defaulting container name to portworx.
Use 'oc describe pod/px-cluster-be2635e9-0ad1-460c-99fb-8054f24c24ef-6k97d -n portworx' to see all of the containers in this pod.
Status: PX is operational
Telemetry: Disabled or Unhealthy
Metering: Healthy
License: PX-Essential (lease renewal in 23h, 31m)
Node ID: 25d4d25c-4334-46e3-9def-7962ce88f9b5
	IP: 10.0.132.120
 	Local Storage Pool: 1 pool
	POOL	IO_PRIORITY	RAID_LEVEL	USABLE	USED	STATUS	ZONE		REGION
	0	HIGH		raid0		600 GiB	11 GiB	Online	us-west-2a	us-west-2
	Local Storage Devices: 1 device
	Device	Path		Media Type		Size		Last-Scan
	0:1	/dev/nvme5n1	STORAGE_MEDIUM_NVME	600 GiB		13 Jan 23 06:44 UTC
	total			-			600 GiB
	Cache Devices:
	 * No cache devices
	Kvdb Device:
	Device Path	Size
	/dev/nvme6n1	150 GiB
	 * Internal kvdb on this node is using this dedicated kvdb device to store its data.
Cluster Summary
	Cluster ID: px-cluster-be2635e9-0ad1-460c-99fb-8054f24c24ef
	Cluster UUID: 2cbddc42-2fc3-479e-9381-3c81e3aa9bf6
	Scheduler: kubernetes
	Nodes: 5 node(s) with storage (4 online)
	IP		ID					SchedulerNodeName				Auth		StorageNode	Used		Capacity	Status	StorageStatus	Version		Kernel				OS
	10.0.194.208	7e438e0f-1fe3-4c1d-9064-87ea3573a2ef	ip-10-0-194-208.us-west-2.compute.internal	Disabled	Yes		11 GiB		600 GiB		Online	Up		2.12.1-d572bb8	4.18.0-305.57.1.el8_4.x86_64	Red Hat Enterprise Linux CoreOS 410.84.202207262020-0 (Ootpa)
	10.0.143.1	422bd9ef-a383-4d7b-9bef-62c14fc5ac3c	ip-10-0-143-1.us-west-2.compute.internal	Disabled	Yes		Unavailable	Unavailable	Offline	Down		2.12.1-d572bb8	4.18.0-305.57.1.el8_4.x86_64	Red Hat Enterprise Linux CoreOS 410.84.202207262020-0 (Ootpa)
	10.0.151.136	2d9c6d55-2514-4e5a-84d4-d6810abd0517	ip-10-0-151-136.us-west-2.compute.internal	Disabled	Yes		11 GiB		600 GiB		Online	Up		2.12.1-d572bb8	4.18.0-305.57.1.el8_4.x86_64	Red Hat Enterprise Linux CoreOS 410.84.202207262020-0 (Ootpa)
	10.0.132.120	25d4d25c-4334-46e3-9def-7962ce88f9b5	ip-10-0-132-120.us-west-2.compute.internal	Disabled	Yes		11 GiB		600 GiB		Online	Up (This node)	2.12.1-d572bb8	4.18.0-305.57.1.el8_4.x86_64	Red Hat Enterprise Linux CoreOS 410.84.202207262020-0 (Ootpa)
	10.0.151.47	20be2bde-f723-4af2-9e9d-99df0c9a934f	ip-10-0-151-47.us-west-2.compute.internal	Disabled	Yes		11 GiB		600 GiB		Online	Up		2.12.1-d572bb8	4.18.0-305.57.1.el8_4.x86_64	Red Hat Enterprise Linux CoreOS 410.84.202207262020-0 (Ootpa)
Global Storage Pool
	Total Used    	:  55 GiB
	Total Capacity	:  2.9 TiB
```

## Replace NFS with Portworx px-sharedv4-sc


### Create Portworx px-sharedv4-sc StorageClass
	
cat sharedsc
```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
    name: px-sharedv4-sc
provisioner: kubernetes.io/portworx-volume
parameters:
   repl: "2"
   sharedv4: "true"
   sharedv4_svc_type: "ClusterIP"
   stork.libopenstorage.org/preferRemoteNodeOnly: "true"
```

### Create Portwork sharedv4 PVC

cat sharedv4pvc
```
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: px-sharedv4-pvc
  annotations:
    volume.beta.kubernetes.io/storage-class: px-sharedv4-sc
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 10Gi
```

oc get pvc px-sharedv4-pvc -o yaml | kubectl neat
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  annotations:
    pv.kubernetes.io/bind-completed: "yes"
    pv.kubernetes.io/bound-by-controller: "yes"
    volume.beta.kubernetes.io/storage-class: px-sharedv4-sc
    volume.beta.kubernetes.io/storage-provisioner: kubernetes.io/portworx-volume
    volume.kubernetes.io/storage-provisioner: kubernetes.io/portworx-volume
  name: px-sharedv4-pvc
  namespace: portworx
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 10Gi
  volumeName: pvc-3183c9b9-a622-4bb1-8ad4-580ce55c3bf8
```
	
oc get pvc
```
NAME              STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS     AGE
px-check-pvc      Bound    pvc-fdad9f1d-d44a-4394-a9d7-38bfee78cc9a   2Gi        RWO            px-csi-db        3h31m
px-sharedv4-pvc   Bound    pvc-3183c9b9-a622-4bb1-8ad4-580ce55c3bf8   10Gi       RWX            px-sharedv4-sc   46m
```


### Create pod using px-sharedv4-pvc

```
podman pull gcr.io/google_containers/test-webserver
podman login ip-10-0-1-85.us-west-2.compute.internal:9999
podman images
podman push 25906c5a72ed ip-10-0-1-85.us-west-2.compute.internal:9999/tests
```

kubectl create secret docker-registry regcred --docker-server=ip-10-0-1-85.us-west-2.compute.internal:9999 --docker-username=admin.  --docker-password=<password> --docker-email=m@m.m


cat podsharedv4
```
apiVersion: v1
kind: Pod
metadata:
  name: pod-sharedv4
spec:
  containers:
  - name: test-container
    image: ip-10-0-1-85.us-west-2.compute.internal:9999/tests
  imagePullSecrets:
  - name: regcred
    volumeMounts:
    - name: test-volume
      mountPath: /test-portworx-volume
  volumes:
  - name: test-volume
    persistentVolumeClaim:
      claimName: px-sharedv4-pvc
```

oc get pods | grep sharedv4
```
pod-sharedv4                                            1/1     Running   0               28m
```
	
oc get pod pod-sharedv4 -o yaml | kubectl neat
```
apiVersion: v1
kind: Pod
metadata:
  annotations:
    k8s.v1.cni.cncf.io/network-status: |-
      [{
          "name": "openshift-sdn",
          "interface": "eth0",
          "ips": [
              "10.130.5.44"
          ],
          "default": true,
          "dns": {}
      }]
    k8s.v1.cni.cncf.io/networks-status: |-
      [{
          "name": "openshift-sdn",
          "interface": "eth0",
          "ips": [
              "10.130.5.44"
          ],
          "default": true,
          "dns": {}
      }]
    openshift.io/scc: anyuid
  name: pod-sharedv4
  namespace: portworx
spec:
  containers:
  - image: ip-10-0-1-85.us-west-2.compute.internal:9999/tests
    name: test-container
    securityContext:
      capabilities:
        drop:
        - MKNOD
    volumeMounts:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-59rqh
      readOnly: true
  imagePullSecrets:
  - name: regcred
  preemptionPolicy: PreemptLowerPriority
  priority: 0
  schedulerName: stork
  securityContext:
    seLinuxOptions:
      level: s0:c33,c7
  serviceAccountName: default
  tolerations:
  - effect: NoExecute
    key: node.kubernetes.io/not-ready
    operator: Exists
    tolerationSeconds: 300
  - effect: NoExecute
    key: node.kubernetes.io/unreachable
    operator: Exists
    tolerationSeconds: 300
  volumes:
  - name: test-volume
    persistentVolumeClaim:
      claimName: px-sharedv4-pvc
  - name: kube-api-access-59rqh
    projected:
      sources:
      - serviceAccountToken:
          expirationSeconds: 3607
          path: token
      - configMap:
          items:
          - key: ca.crt
            path: ca.crt
          name: kube-root-ca.crt
      - downwardAPI:
          items:
          - fieldRef:
              fieldPath: metadata.namespace
            path: namespace
      - configMap:
          items:
          - key: service-ca.crt
            path: service-ca.crt
          name: openshift-service-ca.crt
```
	
## Check Portworx PVCs are bound

oc get pvc -A | grep px
```
portworx               px-check-pvc                                           Bound    pvc-fdad9f1d-d44a-4394-a9d7-38bfee78cc9a   2Gi        RWO            px-csi-db         3h39m
portworx               px-sharedv4-pvc                                        Bound    pvc-3183c9b9-a622-4bb1-8ad4-580ce55c3bf8   10Gi       RWX            px-sharedv4-sc    54m
```
	
## Check rook-ceph PVCs are bound

oc get pvc -A | grep rook-ceph
```
mch10                  cdp-embedded-db-backend                                Bound    pvc-386d9633-5777-4bcb-b1fa-f889c0820391   200Gi      RWO            rook-ceph-block   8d
mch10                  cdp-release-prometheus-server                          Bound    pvc-a01096bd-06d9-4d5b-8c9c-1542642cf029   10Gi       RWO            rook-ceph-block   8d
mch10                  logs                                                   Bound    pvc-ba759a24-606e-4815-8cae-f4444a46bb91   20Gi       RWO            rook-ceph-block   8d
mch10                  storage-volume-cdp-release-prometheus-alertmanager-0   Bound    pvc-e7a30f8d-bc35-4771-bc27-00ef724616b7   2Gi        RWO            rook-ceph-block   8d
mch10                  storage-volume-cdp-release-prometheus-alertmanager-1   Bound    pvc-2d6916fb-cb44-4587-9147-7eaa7ecf6928   2Gi        RWO            rook-ceph-block   8d
mchaws2                cdp-embedded-db-backend                                Bound    pvc-658becc1-3db6-4144-9475-d1719fe6e468   200Gi      RWO            rook-ceph-block   6d22h
mchaws2                cdp-release-prometheus-server                          Bound    pvc-ca2f512e-dc90-4c9c-a86f-b17f5cc67f6a   10Gi       RWO            rook-ceph-block   6d22h
mchaws2                logs                                                   Bound    pvc-02d25aba-4e53-4a73-8a12-3d2cdac80cb1   20Gi       RWO            rook-ceph-block   6d22h
mchaws2                storage-volume-cdp-release-prometheus-alertmanager-0   Bound    pvc-40db92b7-bbac-42c1-ab3c-a99a4428c3b4   2Gi        RWO            rook-ceph-block   6d22h
mchaws2                storage-volume-cdp-release-prometheus-alertmanager-1   Bound    pvc-b93b5e2e-733c-4eaf-94fd-e42c747d17da   2Gi        RWO            rook-ceph-block   6d22h
```
