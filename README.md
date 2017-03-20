# mariadb-cluster with Portworx
##Preparations

Unless your Kubernetes setup has volume provisioning for StatefulSet (GKE has) you need to make sure the Persistent Volumes exist first.

Then:

Create namespace.
Create 10pvc.yml if you created PVs manually.
Create configmap (see 40configmap.sh) and secret (see 41secret.sh).
Create StatefulSet's "headless" service 20mariadb-service.yml.
Create the service that other applications depend on 30mysql-service.yml.
After that start bootstrapping.

Initialize volumes and cluster

First get a single instance with --wsrep-new-cluster up and running:

kubectl create -f ./
kubectl logs -f mariadb-0
You should see something like

...[Note] WSREP: Quorum results:
  version    = 3,
  component  = PRIMARY,
  conf_id    = 0,
  members    = 1/1 (joined/total),
  act_id     = 4,
  last_appl. = -1,
  protocols  = 0/7/3 (gcs/repl/appl),
Now keep that pod running, but change StatefulSet to create normal replicas.

./70unbootstrap.sh
This scales to three nodes. You can kubectl logs -f mariadb-1 to see something like:

[Note] WSREP: Quorum results:
	version    = 3,
	component  = PRIMARY,
	conf_id    = 4,
	members    = 2/3 (joined/total),
	act_id     = 4,
	last_appl. = 0,
	protocols  = 0/7/3 (gcs/repl/appl),
Now you can kubectl delete mariadb-0 and it'll be re-created without the --wsrep-new-cluster argument. Logs will confirm that the new mariadb-0 joins the cluster.

Keep at least 1 node running at all times - which is what you want anyway, and the manual "unbootstrap" step isn't a big deal.
