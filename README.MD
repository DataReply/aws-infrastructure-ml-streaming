# aws-infrastructure-ml-streaming

This repository defines aws infrastructure required to operate the ml-streaming showcase.

### Required tooling

- aws cli https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html
- aws cli session manager plugin https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html

```bash
brew tap gjbae1212/gossm
brew install gossm terragrunt tfenv jq awscli fluxcd/tap/flux
tfenv install 0.15.1
tfenv use 0.15.1
```

### Configure AWS Access

Ensure you have an aws profile configured that is named `datareply`.


### Apply state

```
cd env/dev/k3s
terragrunt apply
```

###  kubectl locally

This section explains which steps need to be done to run kubectl towards the cluster locally.

#### One-time config
1. start ssession to master node
`gossm start -p datareply`
2. copy kubeconfig from `cat /etc/rancher/k3s/k3s.yaml`  and store locally.
(can also be shared among team members)

#### Connecting to the cluster

1. Run the bundled `bash connect.sh`

2. Use kubectl as usual

### bootstrap flux

This  only needs to be done once, it connects the app config layer with flux:

```
export GITHUB_USER="TODO REPLACE BY TOKEN"
flux bootstrap github \
    --owner=DataReply \
    --repository=app-configuration-layer-ml-streaming \
    --branch=master \
    --kubeconfig k3s.yaml \
    --context=default \
    --path=clusters/dev
```

#### Tools/Frameworks planned to used

- https://github.com/dflook/terraform-github-actions
- https://github.com/fluxcd/flux2-kustomize-helm-example/tree/main/apps
- https://github.com/sagittaros/terraform-k3s-private-cloud