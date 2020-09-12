# **NodelocalDNS** #

## Unofficial NodeLocalDNS Configuration##

The origin design of Kubernetes pods did not implement DNS cache. NodeLocalDNS is Kubernetes component to cache DNS queries in each of the WorkerNode to accelerate the setup of network connections. 

The official yaml file will only pass the DNS query to CoreDNS inside the cluster for domain within the Kubernetes Cluster (ie: Kubernetes service). DNS queries on domains outside the Kubernetes cluster will pass to the upstream domain server (ie: VPC DNS Server), which will definitely disable the rewrite rule of CoreDNS.

This implementation has the following advantages: 

- Enable rewrite rules of CoreDNS
- Reduce workload of Upstream DNS and CoreDNS 
- Lengthen cache time of NodeLocalDNS from 30s to 60s

# Quickstart

Download the following bash script and yaml file

> [Script](https://raw.githubusercontent.com/jeanbaptisteng/bottlerocket-cloudformation/master/plugins/NodeLocalDNS/script.sh)
> 
> [yaml file](https://raw.githubusercontent.com/jeanbaptisteng/bottlerocket-cloudformation/master/plugins/NodeLocalDNS/nodelocaldns.yaml)

Run the script to determine the ClusterDNS IP address
Apply the yaml file with the following command

`kubectl apply -f nodelocaldns.yaml`

# Mechanism

Nodelocaldns is CoreDNS in cache mode listening on Local-link address. It also has the capability of changing iptables in WorkerNode. Under this circumstance, traffic to the origin cluster DNS will be hijacked by nodelocaldns. DNS query within the pods inside workernode will be served by nodelocaldns. 

# Note to Security Group for pods Users

Assigning EC2 security groups for pods will create dedicated ENIs to pods related. These separate ENIs have their separate link-local network, which means pods cannot communicate to nodelocaldns. Therefore, *the network of pods will malfunction with the default DNS setting*. 

In order to make the network in pods work, assigning security groups to pods need to change pods DNS setting. Here are some suggestions: 

**Use Cluster DNS**

After installing NodeLocalDNS, the origin Cluster DNS IP address will change. You can gather DNS results from the new IP address in pods.

New Cluster IP address can be gathered from the following command: 

`kubectl -n kube-system  get svc | grep kube-dns-upstream| awk '{print $3}'`


Add the following in pods / deployment for manual configuration of DNS

      dnsConfig:
        nameservers:
        - 169.254.169.253
        options:
        - name: ndots
          value: "1"

*Make sure the security group of the pod allow traffic to udp/tcp 53 of all WorkerNode!*

**Use VPC default DNS server**

If you would like to quarantine the pods from the whole Kubernetes Cluster, you can change the pods DNS setting to the VPC one. 

Add the following in pods / deployment to use VPC DNS

      dnsPolicy: None
      dnsConfig:
        nameservers:
        - 169.254.169.253
        searches:
        - ap-southeast-1.compute.internal
        options:
        - name: ndots
          value: "1"

# License

This is licensed under GNU GENERAL PUBLIC LICENSE.

# See also

[**NodeLocalDNS official document**](https://kubernetes.io/docs/tasks/administer-cluster/nodelocaldns/)


[**Security Group for pods official document**](https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html)


