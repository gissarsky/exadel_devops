# Task 7: Logging & Monitoring
=====================================================

## Tasks:
=====================================================

1. Zabbix:
Big brother is watching  ....

1.1 Install on server, configure web and base
**This part of the assignment is accomplished by installing Zabbix on AWS EC2 Ubuntu Server by according to this [documentation](https://github.com/groorj/aws-zabbix) by using Terraform** 

1.2 Prepare VM or instances. Install Zabbix agents on previously prepared servers or VM.
**This part of the assignment is accomplished by installing Zabbix on AWS EC2 Ubuntu Server by according to this [documentation](https://github.com/groorj/aws-zabbix)** 

EXTRA 1.2.1: Complete this task using ansible

**Zabbix available on following address**
>http://3.8.112.46/zabbix

1.3 Make several of your own dashboards, where to output data from your triggers (you can manually trigger it)

**This part of the assignment is accomplished according to this [documentation](https://www.zabbix.com/documentation/current/manual/web_interface/frontend_sections/monitoring/dashboard)** 


1.4 Active check vs passive check - use both types.

**This part of the assignment is accomplished according to this [documentation](https://blog.zabbix.com/zabbix-agent-active-vs-passive/9207/)** 

1.5 Make an agentless check of any resource (ICMP ping)

**This part of the assignment is accomplished by according to this [documentation](http://woshub.com/zabbix-simple-icmp-ping-checks/)** 


1.6 Provoke an alert - and create a Maintenance instruction

**This part of the assignment is accomplished according to this [documentation](https://bestmonitoringtools.com/zabbix-alerts-setup-zabbix-email-notifications-escalations/)** 

>If an alert occurs, a message will be sent to the email

1.7 Set up a dashboard with infrastructure nodes and monitoring of hosts and software installed on them

**Done**

2. ELK:
Nobody is forgotten and nothing is forgotten.

>**Due to resource limitations on AWS EC2 t2.micro, all further tasks are performed locally.**

2.1 Install and configure ELK

**This part of the assignment is accomplished by installing ELK by according to this [documentation](https://github.com/deviantony/docker-elk)** 

>The Dockerized ELK will be installed

**Output should be as follow**:
```
Creating docker-elk_elasticsearch_1 ... done
Creating docker-elk_logstash_1      ... done
Creating docker-elk_kibana_1        ... done
```

2.2 Organize collection of logs from docker to ELK and receive data from running containers

**This part of the assignment is accomplished by installing ELK by according to this [documentation](https://logz.io/blog/docker-logging/)** 

2.3 Customize your dashboards in ELK

**This part of the assignment is accomplished by installing ELK by according to this [documentation](https://logz.io/blog/docker-logging/)** 

EXTRA 2.4: Set up filters on the Logstash side (get separate docker_container and docker_image fields from the message field)

2.5 Configure monitoring in ELK, get metrics from your running containers

**This part of the assignment is accomplished by installing ELK by according to this [documentation](https://logz.io/blog/docker-logging/)** 

2.6 Study features and settings

**Done**

3. Grafana:
3.1 Install Grafana

**This part of the assignment is accomplished by according to this [documentation](https://github.com/stefanprodan/dockprom)**

>It will set up Prometheus, Grafana, cAdvisor, Node Exporter and alerting with AlertManager.

**Output should be as follow**:
```
Creating prometheus   ... done
Creating cadvisor     ... done
Creating pushgateway  ... done
Creating grafana      ... done
Creating caddy        ... done
Creating nodeexporter ... done
Creating alertmanager ... done
```
3.2 Integrate with installed ELK

**This part of the assignment is accomplished by according to this [documentation](https://github.com/stefanprodan/dockprom)**

>**Using the following JSON code to integrate with Grafana**
```
{
  "name" : "ae9611c6ea17",
  "cluster_name" : "docker-cluster",
  "cluster_uuid" : "jPPZb6O4SBCCNvd26VfrFw",
  "version" : {
    "number" : "7.14.0",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "dd5a0a2acaa2045ff9624f3729fc8a6f40835aa1",
    "build_date" : "2021-07-29T20:49:32.864135063Z",
    "build_snapshot" : false,
    "lucene_version" : "8.9.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

3.3 Set up Dashboards

**This part of the assignment by configuring default[dashboards](https://github.com/stefanprodan/dockprom/tree/master/grafana/provisioning/dashboards)**

3.4 Study features and settings

**Done**
