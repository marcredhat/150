
ceph-rook and portworx on the same OpenShift 4.10 cluster

## Ceph

```
oc rsh rook-ceph-tools-6765648554-8cpgx ceph status
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


Let's tag the Ceph nodes so that they are not used by Portworx


oc label nodes  ip-10-0-144-251.us-west-2.compute.internal ip-10-0-167-1.us-west-2.compute.internal ip-10-0-217-214.us-west-2.compute.internal.    px/enabled=false --overwrite


## Portworx
StorageCluster: https://github.com/marcredhat/150/blob/main/portworxstoragecluster.yaml

```
oc rsh px-cluster-be2635e9-0ad1-460c-99fb-8054f24c24ef-6k97d /opt/pwx/bin/pxctl status
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


