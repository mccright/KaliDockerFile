FROM kalilinux/kali-linux-docker
# Using technique from: 
# https://www.pentestpartners.com/security-blog/docker-for-hackers-a-pen-testers-guide/
# https://blogs.technet.microsoft.com/positivesecurity/2017/09/01/setting-up-kali-linux-in-docker-on-windows-10/
# https://tutorials.ubuntu.com/tutorial/tutorial-windows-ubuntu-hyperv-containers#0
# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
# 
# Yes, I know that my approach violates some docker best practices...
# but this tooling has been useful to me.
#

# Metadata params
ARG BUILD_DATE
ARG VERSION
ARG VCS_URL
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.version=$VERSION \
      org.label-schema.name='Kali Linux' \
      org.label-schema.description='Official Kali Linux docker image' \
      org.label-schema.usage='https://www.kali.org/news/official-kali-linux-docker-images/' \
      org.label-schema.url='https://www.kali.org/' \
      org.label-schema.vendor='Offensive Security' \
      org.label-schema.schema-version='1.0' \
      org.label-schema.docker.cmd='docker run --rm kalilinux/kali-linux-docker' \
      org.label-schema.docker.cmd.devel='docker run --rm -ti kalilinux/kali-linux-docker' \
      org.label-schema.docker.debug='docker logs $CONTAINER' \
      io.github.offensive-security.docker.dockerfile="Dockerfile" \
      io.github.offensive-security.license="GPLv3" \
      MAINTAINER="Steev Klimaszewski <steev@kali.org>"
# Begin pre-https work
RUN echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list && \
    echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list
RUN export http_proxy=http://tjlnuxb:byb81!xf@pfgproxy.principal.com:80 
RUN export https_proxy=http://tjlnuxb:byb81!xf@pfgproxy.principal.com:80
RUN echo "export http_proxy=http://tjlnuxb:byb81!xf@pfgproxy.principal.com:80" >> /root/.bashrc 
RUN echo "export https_proxy=http://tjlnuxb:byb81!xf@pfgproxy.principal.com:80" >> /root/.bashrc
RUN echo "Acquire::http::proxy \"http://tjlnuxb:byb81!xf@pfgproxy.principal.com:80\";"  > /etc/apt/apt.conf.d/80proxy
RUN echo "Acquire::https::proxy \"http://tjlnuxb:byb81!xf@pfgproxy.principal.com:80\";"  >> /etc/apt/apt.conf.d/80prox
ENV DEBIAN_FRONTEND noninteractive
# Update and apt install programs
RUN set -x && apt-get -yqq update && apt-get -yqq dist-upgrade && apt-get clean
# symlink apt/methods http https.  
# https://unix.stackexchange.com/questions/338915/how-to-fix-apt-get-install-f-apt-transport-https-error-404-not-found
RUN rm /usr/lib/apt/methods/https
RUN ln -s /usr/lib/apt/methods/http /usr/lib/apt/methods/https
RUN apt-get -y install ca-certificates 
RUN apt-get -y install openssl
RUN apt-get -y install apt-transport-https
# End pre-https work
RUN echo "deb https://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list && \
    echo "deb-src https://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list
RUN set -x && apt-get -yqq install ruby metasploit-framework
# tcp 5432 is needed for Metasploit's Postgres database
# EXPOSE 5432/tcp
# RUN service postgresql start
# RUN msfdb init

# Remember these kali meta-packages are available:
# kali-linux - Kali Linux base system
# kali-linux-all - Kali Linux - all packages
# kali-linux-forensic - Kali Linux forensic tools
# kali-linux-full - Kali Linux complete system
# kali-linux-gpu - Kali Linux GPU tools
# kali-linux-nethunter - Kali Linux Nethunter tools
# kali-linux-pwtools - Kali Linux password cracking tools
# kali-linux-rfid - Kali Linux RFID tools
# kali-linux-sdr - Kali Linux SDR tools
# kali-linux-top10 - Kali Linux Top 10 tools
# kali-linux-voip - Kali Linux VoIP tools
# kali-linux-web - Kali Linux webapp assessment tools
# kali-linux-wireless - Kali Linux wireless tools
# *** They will make your image much larger!
#
# Now install the parts of Kali that you need
RUN apt-get -y install \
 git \
 screen \
 hashcat \
 hydra \
 man-db \
 nmap \
 sqlmap \
 sslscan \
 burpsuite \
 wordlists \
 net-tools \
 lsof \
 netstat-nat \
 dnsrecon \
 dnsenum \
 udns-utils 

# Create known_hosts for git cloning
RUN mkdir /root/.ssh
RUN touch /root/.ssh/known_hosts
# Add host keys
RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
RUN ssh-keyscan scm.principal.com >> /root/.ssh/known_hosts

# Set entrypoint and working directory
WORKDIR /root/

# Indicate we want to expose ports 80 and 443
EXPOSE 80/tcp 443/tcp
CMD ["bash"]
