# Public stuff

This is my public stuff such as kickstart scripts and public keys.

The shot command below gets you started (which perhaps a short delay from cacheing if you are actually editting this):

```bash
wget cutt.ly/RCPrunme
```
  
or, more verbosely,

```bash
wget https://raw.githubusercontent.com/rcpaffenroth/public_bootstrap/master/RUNME.sh
```

## lxc example

```bash 
lxc rm --force test
lxc launch images:ubuntu/24.04 test
lxc exec test -- bash -c "wget https://raw.githubusercontent.com/rcpaffenroth/public_bootstrap/master/RUNME.sh -O - | bash"
```