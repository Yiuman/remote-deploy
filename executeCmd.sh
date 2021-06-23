#!/usr/bin/expect -f
#用途:远程执行一条任务
#用户名
set user [lindex $argv 0]
#服务器地址
set host [lindex $argv 1]
#目标端口
set port [lindex $argv 2]
#服务器密码
set password [lindex $argv 3]
#命令
set cmd [lindex $argv 4]

spawn ssh -p $port $user@$host $cmd
#spawn $cmd
set timeout 300
expect "$user@$host's password:"
set timeout 300
send "$password\r"
set timeout 300
send "exit\r"
expect eof
