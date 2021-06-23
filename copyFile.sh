#!/usr/bin/expect -f
#用途:远程复制文件
#用户名
set user [lindex $argv 0]
#服务器地址
set host [lindex $argv 1]
#目标端口
set port [lindex $argv 2]
#密码
set password [lindex $argv 3]
#本地文件
set locaFile [lindex $argv 4]
#目标路径
set targetPath [lindex $argv 5]

spawn scp -P $port $locaFile $user@$host:$targetPath
#spawn $cmd
set timeout 300
expect "$user@$host's password:"
set timeout 300
send "$password\r"
set timeout 300
send "exit\r"
expect eof
