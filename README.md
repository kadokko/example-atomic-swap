# Atomic Swap Example

This example is for trying Atomic Swap easily.

You can try a case where two people can exchange normally, or a case where they get back along the way.

Elements are used for the environment. (regtest mode)


## Requirement

- VirtualBox ( 5.2.20 )
- Vagrant ( 2.2.0 )
- Vagrant Plugin
  - vagrant-disksize


## Usage

You can set up the environment below.

```bash
$ git clone https://github.com/kadokko/example-atomic-swap.git
$ cd example-atomic-swap
$ vagrant up
$ vagrant ssh
$ cd /vagrant_share
$ ./startup.sh
```

You can try this example on the following page.

```
http://192.168.33.12:8888/notebooks/example-atomic-swap.ipynb
```
