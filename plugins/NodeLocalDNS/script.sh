#! /bin/bash

declare -r localdns='169.254.20.10'
declare -r domain='cluster.local'
declare -r kubedns=`/usr/bin/kubectl get svc kube-dns -n kube-system -o jsonpath={.spec.clusterIP}`

echo localdns: $localdns
echo domain: $domain
echo kubedns: $kubedns

sed -i  "s/__PILLAR__LOCAL__DNS__/$localdns/g; s/__PILLAR__DNS__DOMAIN__/$domain/g; s/10.100.0.10/$kubedns/g" nodelocaldns.yaml
