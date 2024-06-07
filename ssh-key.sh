#!/bin/bash

# 配置参数
SSH_DIR="$HOME/.ssh"
PRIVATE_KEY="$SSH_DIR/id_ed25519"
PUBLIC_KEY="$PRIVATE_KEY.pub"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"
SSH_CONFIG="/etc/ssh/sshd_config"

# 生成 ed25519 密钥对
echo "正在生成 ed25519 密钥对..."
ssh-keygen -t ed25519 -f $PRIVATE_KEY -N ""

# 创建 .ssh 目录并设置权限
mkdir -p $SSH_DIR
chmod 700 $SSH_DIR

# 将公钥添加到 authorized_keys
cat $PUBLIC_KEY >> $AUTHORIZED_KEYS
chmod 600 $AUTHORIZED_KEYS


PORT=13635

# 修改 SSH 服务器配置
echo "正在修改 SSH 服务器配置..."
sudo sed -i "s/#Port 22/Port $PORT/" $SSH_CONFIG
sudo sed -i "s/Port 22/Port $PORT/" $SSH_CONFIG
sudo sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" $SSH_CONFIG
sudo sed -i "s/PasswordAuthentication yes/PasswordAuthentication no/" $SSH_CONFIG

# 重启 SSH 服务
echo "正在重启 SSH 服务..."
sudo systemctl restart ssh

# 输出结果
echo "密钥生成成功并配置完成。以下是详细信息："
echo "私钥路径：$PRIVATE_KEY"
echo "公钥路径：$PUBLIC_KEY"
echo "SSH 服务器端口：$PORT"

# 显示私钥和公钥
echo "私钥内容："
cat $PRIVATE_KEY
echo "公钥内容："
cat $PUBLIC_KEY

# 显示新的 SSH 端口
echo "新的 SSH 端口：$PORT"