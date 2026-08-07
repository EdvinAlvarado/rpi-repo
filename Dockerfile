FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    reprepro \
    gnupg \
    nginx \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/sites-available/default
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# WORKDIR /srv/rpi-repo
ENV GNUPGHOME=/srv/rpi-repo/.gnupg
VOLUME ["/srv/rpi-repo"]
EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
