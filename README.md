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

## Addig packages
Copy packages to the /mnt/user/appdata/rpi-repo/packages directory. The packages should be in the form of .deb files.
Run the following command to update the repository:
```bash
docker exec rpi-repo bash -c 'for f in /packages/*.deb; do reprepro includedeb bookworm "$f"; done'
```

## Raspbery Pi setup
```bash
curl -fsSL http://your-unraid-ip:8080/public.key | sudo gpg --dearmor -o /etc/apt/keyrings/rpi-repo.gpg
echo "deb [signed-by=/etc/apt/keyrings/rpi-repo.gpg] http://your-unraid-ip:8080 bookworm main" | sudo tee /etc/apt/sources.list.d/rpi-repo.list
sudo apt update
```
Update the URL to your Unraid server's IP address and port number in the above commands. After running these commands, you should be able to install packages from your local repository using `apt install package-name`.
