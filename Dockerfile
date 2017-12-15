FROM centos:7

MAINTAINER Sara Vallero <svallero@to.infn.it>

# create the squid user/grup with same uid/gid as on the host
RUN    groupadd -g 1001 squid
RUN    useradd  -u 1001 -g squid squid 

# install required package
RUN    set -ex \
       && rpm -Uvh http://frontier.cern.ch/dist/rpms/RPMS/noarch/frontier-release-1.1-1.noarch.rpm \
       && yum -y install frontier-squid \
       && yum clean all 

# some preliminary action from /etc/init.d/frontier-squid
# user's home must exist
RUN  set -ex \
     && mkdir -p /var/run/squid \
     && chown squid:squid /var/run/squid \
     && chmod 755 /var/run/squid

# configuration goes here 
COPY files/customize.sh /etc/squid/customize.sh
RUN  chown squid:squid /etc/squid/customize.sh
RUN  chmod +x /etc/squid/customize.sh

EXPOSE   3128                                                                   

# fix the startup script to run squid in foreground
RUN   sed -i 's/^SQUIDEXE=.*$/SQUIDEXE="$SBIN_DIR\/squid -NCd1"/' /usr/sbin/fn-local-squid.sh

ENTRYPOINT  ["runuser", "-s", "/bin/bash", "squid", "/usr/sbin/fn-local-squid.sh", "start"]

