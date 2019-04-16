#!/bin/bash
vpn_provider="$(echo $OPENVPN_PROVIDER | tr '[A-Z]' '[a-z]')"
vpn_provider_configs="/etc/openvpn/$vpn_provider"
if [ ! -d "$vpn_provider_configs" ]; then
	echo "Could not find OpenVPN provider: $OPENVPN_PROVIDER"
	echo "Please check your settings."
	exit 1
fi

# Post process files as paths are now potentially dynamic
/etc/openvpn/adjustConfigs.sh ${vpn_provider_configs}

echo "Using OpenVPN provider: $OPENVPN_PROVIDER"

if [ ! -z "$OPENVPN_CONFIG" ]
then
	if [ -f $vpn_provider_configs/"${OPENVPN_CONFIG}".ovpn ]
  	then
		echo "Starting OpenVPN using config ${OPENVPN_CONFIG}.ovpn"
		OPENVPN_CONFIG=$vpn_provider_configs/${OPENVPN_CONFIG}.ovpn
	else
		echo "Supplied config ${OPENVPN_CONFIG}.ovpn could not be found."
		echo "Using default OpenVPN gateway for provider ${vpn_provider}"
		OPENVPN_CONFIG=$vpn_provider_configs/default.ovpn
	fi
else
	echo "No VPN configuration provided. Using default."
	OPENVPN_CONFIG=$vpn_provider_configs/default.ovpn
fi

# add OpenVPN user/pass
if [ "${OPENVPN_USERNAME}" = "**None**" ] || [ "${OPENVPN_PASSWORD}" = "**None**" ] ; then
  if [ ! -f /etc/openvpn/openvpn-credentials.txt ] ; then
    echo "OpenVPN credentials not set. Exiting."
    exit 1
  fi
  echo "Found existing OPENVPN credentials..."
else
  echo "Setting OPENVPN credentials..."
  mkdir -p /etc/openvpn
  echo $OPENVPN_USERNAME > /etc/openvpn/openvpn-credentials.txt
  echo $OPENVPN_PASSWORD >> /etc/openvpn/openvpn-credentials.txt
  chmod 600 /etc/openvpn/openvpn-credentials.txt
fi

cat >>/etc/supervisor/conf.d/supervisord.conf <<EOL

[program:openvpn]
priority=30
directory=/etc/openvpn
command=/usr/sbin/openvpn $OPENVPN_OPTS --config "$OPENVPN_CONFIG"
user=root
autostart=true
autorestart=true
stopsignal=QUIT
stdout_logfile=/var/log/openvpn.log
redirect_stderr=true
stopasgroup=true
EOL


