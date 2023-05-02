# Installation & usage instructions

## VirtualBox

Install VirtualBox from https://www.virtualbox.org.

## Vagrant

Install Vagrant from https://developer.hashicorp.com/vagrant/downloads for your
platform.

## Start the VM:

```bash
$ vagrant up
```

That should perform all building steps and even will run the test with the built
images.

## Interactive use

On the host machine:

```bash
$ vagrant ssh
```

## Destroy the VM and start over

```bash
$ cd <bnl-wormland-repo>/vm/
$ vagrant destroy --force
```
