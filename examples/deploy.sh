#!/bin/sh
host='{remote_host}'         #远程主机的地址
port='{remote_port}'         #远程主机端口
user='{remote_user}'         #远程用户
password='{remote_password}' #远程用户密码

confName='conf'    #本例子中 作为应用配置的文件
serverPort='18080' #本例子中，远程服务启动的端口

#1.俾权限
chmod 777 ./copyFile.sh
chmod 777 ./executeCmd.sh

#2.打包挂载的文件、远程需要部署需要用到的文件、拷贝至远程服务器并解包、删除本地压缩包
zip -q -r "$confName".zip ./"$confName"
./copyFile.sh $user $host $port $password "$confName".zip /home/docker-deploy/citrus/
./executeCmd.sh $user $host $port $password unzip\ /home/docker-deploy/citrus/"$confName".zip\ -d\ /home/docker-deploy/citrus/
find . -name '*.zip' -type f -print -exec rm -rf {} \;

#3.mvn 构建Springboot应用、拷贝至远程目录
cd /Users/yiumankam/workspace/github_space/citrus/citrus-main
mvn clean package
./copyFile.sh $user $host $port $password citrus-main-0.0.1.jar /home/docker-deploy/citrus/

#4.yarn 构建前端应用、拷贝至远程目录、解包
cd /Users/yiumankam/workspace/vue_space/citrus-vuetify
yarn build
zip -q -r ./dist.zip ./dist
./copyFile.sh $user $host $port $password dist.zip /home/docker-deploy/citrus/
./executeCmd.sh $user $host $port $password unzip\ /home/docker-deploy/citrus/dist.zip\ -d\ /home/docker-deploy/citrus/
find . -name '*.zip' -type f -print -exec rm -rf {} \;

#5.执行远程docker-compose构建  先停掉、再重启
./executeCmd.sh $user $host $port $password docker-compose -f /home/docker-deploy/citrus/docker-compose.yml stop
./executeCmd.sh $user $host $port $password docker-compose -f /home/docker-deploy/citrus/docker-compose.yml up -d
