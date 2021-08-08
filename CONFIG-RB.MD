


## change hostnames

192.168.2.101  (E4:5F:01:34:9E:9A) top raspberry


192.168.2.102  E4:5F:01:34:9F:05
sudoedit /etc/netplan/50-cloud-init.yaml

network:
    ethernets:
        eth0:
            dhcp4: true
            optional: true
    version: 2
    wifis:
      wlan0:
         access-points:
            NSA:
             password: 10134506770078535793
         dhcp4: true
         optional: true

sudo netplan apply


# install on the master


sudo vim /boot/firmware/cmdline.txt
Add cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 into end of the file.

curl -sfL https://get.k3s.io | sh -
## install SSM agent

sudo curl https://s3.eu-central-1.amazonaws.com/amazon-ssm-eu-central-1/latest/debian_arm64/amazon-ssm-agent.deb  -o /tmp/ssm/amazon-ssm-agent.deb
sudo dpkg -i /tmp/ssm/amazon-ssm-agent.deb
sudo service amazon-ssm-agent stop


You have successfully created a new activation. Your activation code is listed below. Copy this code and keep it in a safe place as you will not be able to access it again.


sudo amazon-ssm-agent -register -code hidden -id 95dedba3-babd-4f96-87c1-a8f371cb2c52 -region eu-central-1

sudo service amazon-ssm-agent start

sudo /snap/amazon-ssm-agent/current/amazon-ssm-agent -register -code activation-1 -id 


## connect to the agent remotely

 aws ssm start-session --profile datareply --region eu-central-1  \    
    --target mi-0b956957d8f125fd7   \
    --document-name AWS-StartPortForwardingSession \
    --parameters '{"portNumber":["6443"], "localPortNumber":["6443"]}'

##  extracting the join token
sudo cat /etc/rancher/k3s/k3s.yaml

sudo cat /var/lib/rancher/k3s/server/node-token
K10c96fd3cb70f15373ddf56dff916525f81ba0440bb7e83000c86fa8777de70fc0::server:0345143779f89cbeb98fee03425404ff



# install in the node
curl -sfL http://get.k3s.io | K3S_URL=https://192.168.2.101:6443 \
K3S_TOKEN=K10c96fd3cb70f15373ddf56dff916525f81ba0440bb7e83000c86fa8777de70fc0::server:0345143779f89cbeb98fee03425404ff sh -


ensure local path is writbale

sudo chmod 700 /var/lib/rancher/k3s/storage