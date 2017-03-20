# mariadb-cluster with Portworx
## Preparations

We are using a storageclass ``porx-mysql-sc.yml`` of a replication of 2 to create the volumes
````
kubectl create -f porx-mariadb-mysql-service.yml
kubectl create -f porx-mariadb-mariadb-service.yml
kubectl create -f porx-mysql-sc.yml
#Install the config map
sh porx-maridb-configmap.sh
kubectl create -f porx-mariadb-statefulset.yml	
````

## Initialize volumes and cluster

First get a single instance with ``--wsrep-new-cluster`` up and running:

````
kubectl logs mariadb-0 
```` 
you should see something like 
````
...[Note] WSREP: Quorum results:
  version    = 3,
  component  = PRIMARY,
  conf_id    = 0,
  members    = 1/1 (joined/total),
  act_id     = 4,
  last_appl. = -1,
  protocols  = 0/7/3 (gcs/repl/appl),
````

We need to join the other nodes so keep this pod running and run
````
sh porx-unbootstrap.sh
````

This scales to three nodes. You can ``kubectl logs -f mariadb-1`` to see something like:

````
[Note] WSREP: Quorum results:
	version    = 3,
	component  = PRIMARY,
	conf_id    = 4,
	members    = 2/3 (joined/total),
	act_id     = 4,
	last_appl. = 0,
	protocols  = 0/7/3 (gcs/repl/appl),
````
Now you can kubectl delete mariadb-0 and it'll be re-created without the ``--wsrep-new-cluster argument``. Logs will confirm that the new mariadb-0 joins the cluster.

Keep at least 1 node running at all times - which is what you want anyway, and the manual "unbootstrap" step isn't a big deal.




