#### Tooling
```bash
brew install tfenv jq awscli
tfenv install 0.15.1
tfenv use 0.15.1

chmod +x ./bin/*.sh
```

### Configure AWS ACCESS

#### Apply state

1. First apply
2. -target=module.vpc

####  kubectl locally

Once
1. start ssession to master node

`gossm start -p datareply`

2. copy kubeconfig from `cat /etc/rancher/k3s/k3s.yaml`  and store locally.



1. Use this kubeconfig `export KUBECONFIG="$(pwd)/k3s.yaml"`
2. create tunnel
   
```
aws ssm start-session --profile datareply --region eu-central-1  \
    --target i-0b078c18de2075b0d  \
    --document-name AWS-StartPortForwardingSession \
    --parameters '{"portNumber":["6443"], "localPortNumber":["6443"]}'
```

### bootstrap flux

```
export GITHUB_USER="TODO REPLACE BY TOKEN"
flux bootstrap github \
    --owner=DataReply \
    --repository=app-configuration-layer-ml-streaming \
    --branch=main \
    --kubeconfig k3s.yaml \
    --context=default \
    --path=clusters/dev
```

#### Tools/Frameworks planned to used

- https://github.com/dflook/terraform-github-actions

- https://github.com/fluxcd/flux2-kustomize-helm-example/tree/main/apps

- https://github.com/sagittaros/terraform-k3s-private-cloud
