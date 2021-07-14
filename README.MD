# aws-infrastructure-ml-streaming

This repository defines aws infrastructure required to operate the ml-streaming showcase.
<p align="center" width="100%">
        <img width="50%" src="https://github.com/DataReply/aws-infrastructure-ml-streaming/blob/master/doc/architecture.png"> 
</p>


### Required tooling

- aws cli https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html
- aws cli session manager plugin https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html

```bash
brew tap gjbae1212/gossm
brew install gossm terragrunt tfenv jq awscli fluxcd/tap/flux
tfenv install 0.14.1
tfenv use 0.14.1
```

You might run into issues because both `terragrunt` and `tfenv` depend on terraform. Some solutions to this are outlined here:
https://github.com/gruntwork-io/terragrunt/issues/580

### Configure AWS Access

Ensure you have an aws profile configured that is named `datareply`.

We do not yet use role assumption for the use case, thus the only thing declared in `~/.aws/config` for the `datareply` profile ist:

```
[profile datareply]
region = eu-central-1
```

Make additionally sure to have set proper access credentials in `~/.aws/credentials` :
```
[datareply]
aws_access_key_id = YOU_ACCCESS_KEY_ID
aws_secret_access_key = theRespectivEAccessKey
```


### Apply state locally
The terraform will pickup the profile called `datareply` and will assume you have sufficient privleges to apply the infrastructure spec.
This repository will soon have an automated CD pipeline which will make this partly redundant.

```
cd env/dev/k3s
terragrunt apply
```

###  kubectl locally
This section explains which steps need to be done to run kubectl towards the cluster locally.

#### One-time config
You need to set this up once to get a local copy of the kubeconfig.

1. Run the bundled `bash bin/bootstrap.sh`
2. (optionaly) Run `bash bin/bootstrap.sh k3s-arm-cluster` to setup the arm cluster.

#### Connecting to the cluster
You need to run this, if you are planning to connect to the cluster via kubectl.

1. Run the bundled `bash bin/connect.sh` or `bash bin/connect.sh k3s-arm-cluster` 
2. Use kubectl as usual

#### Connecting to kafka cluster

1. Make sure to have initialized kubernetes connectivity
2. Make sure you are connected to the cluster
3. Run `bash bin/extract_kafka_clientconfig.sh k3s-arm-cluster` which yields the kafka client config.


### Run sample cifar10 workload 
Please review the  [the cifar10 workload](doc/workload.md) section.

### Inspect model performance (disabled atm)
The installed grafana dashboard provides an indication about the model perfomance,

```
kubectl port-forward svc/seldon-core-analytics-grafana 3000:80 -n seldon-system
```

Open localhost:3000 in your webbrowser to get an indication of model performance.
Login admin:password

### bootstrap flux 
This  only needs to be done *once by the cluster admin* in order to bootstrap flux on the cluster and connect the `app-configuration-layer-ml-streaming` with it.

```
export GITHUB_TOKEN="TODO REPLACE BY TOKEN"
export GITHUB_USER="TODO REPLACE BY USER"
flux bootstrap github \
    --owner=DataReply \
    --repository=app-configuration-layer-ml-streaming \
    --branch=master \
    --kubeconfig k3s-cluster.yaml \
    --context=default \
    --path=clusters/dev

flux bootstrap github \
    --owner=DataReply \
    --repository=app-configuration-layer-ml-streaming \
    --branch=master \
    --kubeconfig k3s-arm-cluster.yaml \
    --context=default \
    --path=clusters/dev-arm
```

#### Tools/Frameworks planned to used

- https://github.com/dflook/terraform-github-actions
- https://github.com/fluxcd/flux2-kustomize-helm-example/tree/main/apps
- https://github.com/sagittaros/terraform-k3s-private-cloud
