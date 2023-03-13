FROM ubuntu:22.04

MAINTAINER devd4n

RUN apt-get update && apt-get install -y tar wget xauth libqt5webkit5 libqt5xml5 libqt5multimedia5 libqt5script5 libqt5scripttools5 sudo libnss3 libxss1 libasound2 vim less

RUN export uid=1000 gid=1000 \
  && mkdir -p /home/pt \
  && echo "pt:x:${uid}:${gid}:pt,,,:/home/pt:/bin/bash" >> /etc/passwd \
  && echo "pt:x:${uid}:" >> /etc/group \
  && mkdir /home/pt/storage \
  && chown ${uid}:${gid} -Rv /home/pt
  
COPY PacketTracer.deb /home/pt/packettracer.deb

RUN mkdir -p pt_package/DEBIAN \
  && dpkg-deb -x /home/pt/packettracer.deb /home/pt/pt_package/ \
  && dpkg-deb -e /home/pt/packettracer.deb /home/pt/pt_package/DEBIAN/ \
  && rm -f /home/pt/pt_package/DEBIAN/preinst \
  && dpkg-deb -Z xz -b /home/pt/pt_package/ . \
  && ls -la /home/pt/pt_package/
  && mv /home/pt/pt_package/packettracer_* /home/pt/packettracer.deb \
  && apt install /home/pt/packettracer.deb \
  && rm -f /home/pt/*.deb \
  && rm -rf /home/pt/pt_package \
  && chown ${uid}:${gid} -Rv /opt/pt

COPY packettracer /usr/local/bin/packettracer
RUN chmod +x /usr/local/bin/packettracer

USER pt
ENV HOME /home/pt
CMD /usr/local/bin/packettracer
