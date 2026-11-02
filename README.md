# rpi-repo
Local repository for custom written programs for Raspberry Pis


## Unraid setup
```bash
mkdir -p /mnt/user/appdata/rpi-repo/{srv,packages}
```

Copy this git wherever you store the compose stack.

```bash
docker compose up -d --build
```

## Adding packages
Copy packages to the /mnt/user/appdata/rpi-repo/packages directory. The packages should be in the form of .deb files
.
Run the following command to update the repository:
```bash
docker exec rpi-repo bash -c 'for f in /packages/*.deb; do reprepro includedeb bookworm "$f"; done'
```

Note you can add packges

## Raspbery Pi setup
Add the repo as Truisted.
```/etc/apt/sources.list.d/flbt.sources
Types: deb
URIs: http://au-nas-01:8081
Suites: trixie
Components: main
Trusted: yes
```

Update
```bash
sudo apt update
```
Update the URL to your Unraid server's IP address and port number in the above commands. After running these command
s, you should be able to install packages from your local repository using `apt install package-name`.
