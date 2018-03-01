# OWASP Mutillidae 2 Vagrant

Vagrant config to configure an Ubuntu 16.04 virtual machine and install [OWASP Mutillidae 2](https://sourceforge.net/projects/mutillidae/files/), a deliberately vulnerable PHP web application.

## Requirements

- [vagrant](https://www.vagrantup.com/docs/installation/)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## How to use

Get this repo

```
git clone https://github.com/paulfurley/owasp-mutillidae-vagrant && cd owasp-mutillidae-vagrant
```

Invoke vagrant to create and provision the box:

```
mkdir -p ~/.cache/vagrant-apt-archives
vagrant up
```

Connect to [http://localhost:8080/mutillidae](http://localhost:8080/mutillidae)
