
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


