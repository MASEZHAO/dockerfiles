FROM centos:7

MAINTAINER zhao "cprogram05@126.com"

#设置root用户为后续的命令执行者
USER root
#更新源 安装ssh server
RUN yum install -y openssh-server sudo
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
#添加测试用户zhao密码123456 并且将此用户添加到sudoers里
RUN useradd zhao
RUN echo "zhao:123456" | chpasswd
RUN echo "zhao   ALL=(ALL)    ALL" >> /etc/sudoers
#下面为了sshd登陆产生公钥和私钥
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
#启动sshd服务并暴露22端口
RUN mkdir -p /var/run/sshd
EXPOSE 22

#安装curl命令
RUN yum install curl
#安装 JDK8
RUN cd /tmp && curl -L 'http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-x64.tar.gz' -H 'Cookie: oraclelicense=accept-securebackup-cookie; gpw_e24=Dockerfile' | tar -xz
RUN mkdir -p /usr/lib/jvm
RUN mv /tmp/jdk1.8.0_51/ /usr/lib/jvm/java-8-oracle/

#设置oracle JDK 8 作为默认java
RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-8-oracle/bin/java 180
RUN update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-8-oracle/bin/javac 180

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/

#安装 tomcat8
RUN cd /tmp && curl -L 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.18/bin/apache-tomcat-8.0.18.tar.gz' | tar -xz
RUN mv /tmp/apache-tomcat-8.0.18/ /opt/tomcat8/

ENV CATALINA_HOME /opt/tomcat8
ENV PATH $PATH:$CATALINA_HOME/bin

ADD tomcat8.sh /etc/init.d/tomcat8
RUN chmod 755 /etc/init.d/tomcat8

#暴露tomcat端口
EXPOSE 8080

#设置默认命令行
#ENTRYPOINT /opt/tomcat8/bin/startup.sh && /usr/sbin/sshd -D
ENTRYPOINT tomcat8 start && /usr/sbin/sshd -D
