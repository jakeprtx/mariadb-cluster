#!/bin/bash
DIR=`dirname "$BASH_SOURCE"`
set -e
set -x

cp "$DIR/porx-mariadb-statefulset.yml" "$DIR/porx-mariadb-statefulset.yml.unbootstrap.yml"

sed -i  's/replicas: 1/replicas: 3/' "$DIR/porx-mariadb-statefulset.yml.unbootstrap.yml"
sed -i  's/- --wsrep-new-cluster/#- --wsrep-new-cluster/' "$DIR/porx-mariadb-statefulset.yml.unbootstrap.yml"

kubectl apply -f "$DIR/porx-mariadb-statefulset.yml.unbootstrap.yml"
rm "$DIR/porx-mariadb-statefulset.yml.unbootstrap.yml"
