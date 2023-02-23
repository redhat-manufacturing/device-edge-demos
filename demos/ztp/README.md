# Zero Touch Provisioning of Red Hat Device Edge Demo

This demo showcases zero touch provisioning of Device Edge, using an image that has microshift built in. It deploys a sample application to the deployed system once it's available.

This is essentially a demo version of [this workshop](https://redhat-manufacturing.github.io/device-edge-workshops/exercises/rhde_aw_120/).

## Requirements

This workshop requires one system (could be an edge device, a VM on your laptop, etc) to act as the "edge management node", where some core services will run.

Edge Management Node Requirements:
- RHEL9.1+
- Ansible Automation Platform v2.1+ Installed
- Two available connections: a 'WAN' link and a 'LAN' link - WiFi is perfectly fine for the WAN link

This node will create its own network segment on the LAN link and run DNS/DHCP. Optionally, this network can be extended via a wireless access point or switch where RHDE nodes can be connected.

Other requirements:
- A 4GB+ flash drive for the boot ISO

## Setting Up the Demo

Create an inventory file with the following information:
```yaml
all:
  hosts:
    steamdeck:
      ansible_user: ansible
      ansible_password: ansible-password
      ansible_become_password: ansible-password
      
      external_connection: eth0-or-wifinetwork
      internal_connection: eth1
      base_domain: edge.demos.lcl

      switch_mac_address: 00:00:00:00:00:00

      controller_username: admin
      controller_password: password

      ocp_pull_secret: your-pull-secret
```

Ensure the following collections are available:
- community.general
- ansible.posix
- redhat_cop.controller_configuration

The playbooks to build the demo are `build-demo.yml` and `build-demo-alt.yml`.

> Note:
>
> There are two versions of this: one that created a priviliged container to run dnsmasq and one that uses dnsmasq on the system (normal and alt, respectively). There is some weirdness with host networking via Podman on RHEL9.1, so if the first one doesn't work as expected, use the alternate one.

The `populate-controller.yml` will configure the default organization in Ansible Controller to be ready to provision systems when they call home.

In addition, `teardown-demo.yml` and `teardown-demo-alt.yml` will revserse all changes made for the demo.

## Running the Demo

Once the demo is built, add the appropriate passwords to `iso/ks.cfg` and use the `recook.sh` script to create a boot ISO. Write it to a flash drive, and then boot your edge devices from it. They should boot up, pull their image, install themselves, reboot, and call home to Controller.
