FROM debian:trixie-slim
RUN apt-get update && \
    apt-get install -y tor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir -p /data
#COPY --chown=debian-tor data/ /data
RUN mkdir -p /var/lib/tor/hidden_service
# Massive security issue, Why are we including the private and public key in the image!
# Suggestion, Instead do a check in a script during runtime and exit the container with 1 error code if these checks fail
# Instead of doing these checks in the build process itself
#RUN if [ -d /data ] && [ -f /data/hostname ] && [ -f /data/hs_ed25519_public_key ] && [ -f /data/hs_ed25519_secret_key ]; then \
#        cp -r /data/* /var/lib/tor/hidden_service/ && \
#        chown -R debian-tor:debian-tor /var/lib/tor/hidden_service/ && \
#        chmod 700 /var/lib/tor/hidden_service/ && \
#        chmod 600 /var/lib/tor/hidden_service/hostname && \
#        chmod 600 /var/lib/tor/hidden_service/hs_ed25519_public_key && \
#        chmod 600 /var/lib/tor/hidden_service/hs_ed25519_secret_key; \
#    else \
#        echo "Required files are missing or /data directory does not exist. Exiting."; \
#        exit 1; \
#    fi

RUN echo "HiddenServiceDir /var/lib/tor/hidden_service/" > /etc/tor/torrc
RUN echo "HiddenServicePort 80 nginx:80" >> /etc/tor/torrc

USER debian-tor
#CMD (cat /var/lib/tor/hidden_service/hostname || echo "No hostname found.") && tor -f /etc/tor/torrc
ENTRYPOINT ["/entrypoint.sh"]