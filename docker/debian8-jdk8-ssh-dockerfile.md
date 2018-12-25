## debian8-jdk8-ssh.dockerfile
```docker
#debian8-jdk8-ssh.dockerfile
FROM java:8-jdk
# MAINTAINER XIAOWS <xiaows08@163.com>
WORKDIR /root/

RUN echo 'deb http://mirrors.aliyun.com/debian stretch main' > /etc/apt/sources.list;\
    echo '#deb-src http://mirrors.aliyun.com/debian stretch main' >> /etc/apt/sources.list;\
    echo 'deb http://mirrors.aliyun.com/debian stretch-updates main' >> /etc/apt/sources.list;\
    echo '#deb-src http://mirrors.aliyun.com/debian stretch-updates main' >> /etc/apt/sources.list;\
    echo 'deb http://mirrors.aliyun.com/debian-security stretch/updates main' >> /etc/apt/sources.list;\
    echo '#deb-src http://mirrors.aliyun.com/debian-security stretch/updates main' >> /etc/apt/sources.list;\
    apt-get update;\
    apt-get install -y openssh-server wget curl net-tools vim fping;\
    apt-get clean;\
    ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '';\
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys;\
    echo '\tStrictHostKeyChecking no' >> /etc/ssh/ssh_config;\
    echo 'set ts=4' > /root/.vimrc;\
    echo 'set expandtab' >> /root/.vimrc;\
    echo 'set nu' >> /root/.vimrc;\
    echo "alias grep='grep --color=auto'" >> /root/.bashrc;\
    echo "alias ls='ls --color=auto'" >> /root/.bashrc;\
    echo "alias l='ls -lhF'" >> /root/.bashrc;\
    echo "alias la='ls -A'" >> /root/.bashrc;\
    echo "alias ll='ls -AlhF'" >> /root/.bashrc;\
    echo "PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '">> /root/.bashrc

# ENTRYPOINT ["service ssh start;"]
CMD ["sh", "-c", "service ssh start; bash"]

COPY .debian8-jdk8-ssh.dockerfile /
```