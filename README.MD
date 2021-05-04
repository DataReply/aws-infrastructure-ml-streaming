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

You might run into issues because both `terragrunt` and `tfenv` depend on terraform. Some solutions to this are outlined here:
https://github.com/gruntwork-io/terragrunt/issues/580

### Configure AWS Access

Ensure you have an aws profile configured that is named `datareply`.


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
1. Run the bundled `bash bootstrap.sh`


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
