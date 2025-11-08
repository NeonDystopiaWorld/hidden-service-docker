FROM debian:trixie-slim
RUN apt-get update && \
    apt-get install -y tor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir -p /data
RUN mkdir -p /var/lib/tor/hidden_service
RUN chown debian-tor -R /var/lib/tor/hidden_service/
RUN echo "HiddenServiceDir /var/lib/tor/hidden_service/" > /etc/tor/torrc
RUN echo "HiddenServicePort 80 nginx:80" >> /etc/tor/torrc

USER debian-tor
ENTRYPOINT ["/entrypoint.sh"]
