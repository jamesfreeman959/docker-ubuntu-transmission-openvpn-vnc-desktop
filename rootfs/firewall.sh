ufw enable
ufw default reject outgoing
ufw allow out 1194/udp
ufw allow out 992/udp
ufw allow out 4443/udp
ufw allow out to 8.8.8.8 port 53 proto udp
ufw allow out to 8.8.4.4 port 53 proto udp
ufw allow out on tun0
ufw allow in 80/tcp
ufw allow in 443/tcp
ufw allow in 5900/tcp
