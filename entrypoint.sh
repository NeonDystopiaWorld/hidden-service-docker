#! /bin/bash
if [ -e "/data/hostname" ] && [ -e "/data/hs_ed25519_public_key" ] && [ -e "/data/hs_ed25519_secret_key" ]; then 
  chown -R debian-tor:debian-tor /var/lib/tor/hidden_service/ 
  cp -r /data/* /var/lib/tor/hidden_service/
  chmod 700 /var/lib/tor/hidden_service/ 
  chmod 600 /var/lib/tor/hidden_service/hostname 
  chmod 600 /var/lib/tor/hidden_service/hs_ed25519_public_key 
  chmod 600 /var/lib/tor/hidden_service/hs_ed25519_secret_key   
else 
  echo "Required files are missing or /data directory does not exist. Exiting."; 
  exit 1; 
fi
cat /var/lib/tor/hidden_service/hostname || echo "No hostname found."
tor -f /etc/tor/torrc