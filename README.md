docker-ubuntu-vnc-desktop
=========================

From Docker Index
```
docker pull dorowu/ubuntu-lxqt-vnc
```

Build yourself
```
git clone -b lxqt https://github.com/fcwu/docker-ubuntu-vnc-desktop.git
docker build --rm -t dorowu/ubuntu-lxqt-vnc docker-ubuntu-vnc-desktop
```

Run
```
docker run -i -t -p 6080:6080 dorowu/ubuntu-lxqt-vnc
```

Browse http://127.0.0.1:6080/vnc.html

<img src="https://raw.github.com/fcwu/docker-ubuntu-vnc-desktop/lxqt/screenshots/lxqt.png" width=400/>
