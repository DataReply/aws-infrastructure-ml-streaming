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



1. Use this kubeconfig `export KUBECONFIG="$(pwd)/k3s.yaml`
2. create tunnel
   
```
aws ssm start-session --profile datareply --region eu-central-1  \                    SIG(125) ↵  ⚙  11374  17:26:00
    --target i-0297a003b50836844 \
    --document-name AWS-StartPortForwardingSession \
    --parameters '{"portNumber":["6443"], "localPortNumber":["6443"]}
```

### bootstrap flux

flux bootstrap github \
    --context=staging \
    --owner=${GITHUB_USER} \
    --repository=${GITHUB_REPO} \
    --branch=main \
    --personal \
    --path=clusters/staging

#### Tools/Frameworks planned to used

- https://github.com/dflook/terraform-github-actions

- https://github.com/fluxcd/flux2-kustomize-helm-example/tree/main/apps

- https://github.com/sagittaros/terraform-k3s-private-cloud
