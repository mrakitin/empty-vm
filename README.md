# Installation & usage instructions

## VirtualBox

Install VirtualBox from https://www.virtualbox.org.

## Vagrant

Install Vagrant from https://developer.hashicorp.com/vagrant/downloads for your
platform.

## Start the VM:

```console
$ vagrant up
```

That should perform all building steps and even will run the test with the built
images.

## Interactive use

On the host machine:

```console
$ vagrant ssh
```

## Destroy the VM and start over

```console
$ cd <bnl-wormland-repo>/vm/
$ vagrant destroy --force
```

## Load the generated VM

Download a generated .zip archive from GHA artifacts and unpack it to have the
file named `sirepo-raydata-vm.box`. Then run the following commands:

```console
$ vagrant box add sirepo-raydata-vm sirepo-raydata-vm.box
$ vagrant init sirepo-raydata-vm sirepo-raydata-vm.box
$ vagrant up
$ vagrant ssh
```

### Docs
- https://developer.hashicorp.com/vagrant/docs/cli/package
- https://stackoverflow.com/a/20680816/4143531


## General notes

https://ctrlnotes.com/vagrant-advanced-examples/#-insert-custom-ssh-public-key-to-the-vm
