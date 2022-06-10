#!/usr/bin/bash

cp /etc/resolv.conf /tmp/resolv.conf
su -c 'umount /etc/resolv.conf'
cp /tmp/resolv.conf /etc/resolv.conf
sed -i 's/DAEMON_ARGS=.*/DAEMON_ARGS=""/' /etc/init.d/expressvpn
service expressvpn restart
/usr/bin/expect /tmp/expressvpnActivate.sh
expressvpn preferences set auto_connect true
expressvpn preferences set preferred_protocol $PREFERRED_PROTOCOL
expressvpn preferences set lightway_cipher $LIGHTWAY_CIPHER
expressvpn connect $SERVER

set -x

trap 'kill -TERM $PID' TERM INT

if expressvpn status | grep -q "Connected to"; then
	echo "ExpressVPN connected. Will now start transmission"
	if [ "$#" -eq 0 ]; then
  	transmission-daemon -c /watch -w /downloads --incomplete-dir /incomplete -f -t -a $T_ALLOWED -p $T_PORT -u $T_USERNAME -v $T_PASSWORD -g /config &
	else
  	transmission-daemon $@ &
	fi
else
	echo "ExpressVPN not connected! Will exit now!"
	return 9
fi

PID=$!
wait $PID
wait $PID
while [ -f /config/lock ]
do
  sleep 2
done

EXIT_STATUS=$?

