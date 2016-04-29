FROM ubuntu:14.04
MAINTAINER wlu wlu@linkernetworks.com

RUN echo "deb http://repos.mesosphere.io/ubuntu/ trusty main" > /etc/apt/sources.list.d/mesosphere.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
    apt-get -y update && \
    apt-get -y install mesos=0.26.0-0.2.145.ubuntu1404 openjdk-7-jre supervisor curl

ADD supervisord.conf /etc/

RUN ln -f -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN curl -fL http://archive.cloudera.com/cdh5/cdh/5/hadoop-2.5.0-cdh5.2.0.tar.gz | tar xzf - -C /usr/local

ENV MESOS_NATIVE_LIBRARY="/usr/lib/libmesos.so hadoop jobtracker" \
    HADOOP_HOME="/usr/local/hadoop-2.5.0-cdh5.2.0"

ADD mapred-site.xml ${HADOOP_HOME}/etc/hadoop/mapred-site.xml
ADD hadoop-mesos-0.1.0.jar ${HADOOP_HOME}/share/hadoop/common/lib/

ENV JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64"
ENV PATH=$PATH:$JAVA_HOME/bin \
    MESOS_NATIVE_LIBRARY=/usr/lib/libmesos.so

RUN apt-get remove -y curl && \
    apt-get clean

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]

