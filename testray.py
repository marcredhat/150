from cmlextensions.ray_cluster import RayCluster

# Cluster Parameters (head_cpu,head_memory,num_workers,worker_memory,
# worker_cpu, env, dashboard_port) 
cluster = RayCluster(num_workers=3,worker_memory=12,head_memory=12)
cluster.init()
