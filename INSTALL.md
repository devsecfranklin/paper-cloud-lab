## build

Using Makefile:

```sh
make python
. ./_build/bin/activate.fish
make paper
```

From shell:

```sh
sudo sysctl -w net.ipv6.conf.all.forwarding=1 # Use when you have IPv6 network issues
export CR_PAT=$(pass show ghcr)
echo $CR_PAT | docker login ghcr.io -u devsecfranklin --password-stdin
```

