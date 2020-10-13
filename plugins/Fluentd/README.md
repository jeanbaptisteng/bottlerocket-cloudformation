# ** Fluentd on BottleRocket ** #

## Unofficial Fluentd configuration for Containerd Runtime WorkerNodes ##

Fluentd with ElasticSearch is very common for collecting logs from Kubernetes, but the official containers in Docker Hub is for Workernodes with docker runtime. Workernodes with Containerd runtime, BottleRocket default container runtime, need configuration adjustment in order to allow fluentd to collect containerd logs. 

The yaml file in this session encompass the necessary configuration for containerd log


# Quickstart


1.Download the yaml file
> [yaml file](https://raw.githubusercontent.com/jeanbaptisteng/bottlerocket-cloudformation/master/plugins/Fluentd/fluentd.yaml)


2.Make amendment in node label and elasticsearch cluster information


3.Apply the yaml file in Kubernetes cluster


`kubectl apply -f fluentd.yaml`


# See also

[**Fluentd-kubernetes-daemonset official GitHub**](https://github.com/fluent/fluentd-kubernetes-daemonset)
