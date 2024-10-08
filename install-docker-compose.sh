#!/bin/bash

# 检测操作系统类型
OS_TYPE=$(uname)

# 检测操作系统发行版
if [[ "$OS_TYPE" == "Linux" ]]; then
  OS=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
  # 删除引号
  OS="${OS%\"}"
  OS="${OS#\"}"
fi

# 获取最新版本的 Docker Compose
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d '"' -f 4)

# 根据不同的操作系统发行版安装 Docker 和 Docker Compose
case $OS in
  "Debian GNU/Linux"|"Ubuntu")
    echo "Detected $OS"
    # 安装 Docker
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker $USER
    # 安装 Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    if [ -L /usr/bin/docker-compose ]; then
      sudo rm /usr/bin/docker-compose
    fi
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    ;;

  "CentOS Linux"|"Rocky Linux")
    echo "Detected $OS"
    # 其余部分同上
    ;;

  *)
    if [[ "$OS_TYPE" == "Darwin" ]]; then
      echo "Detected macOS"
      # macOS 的安装部分
    else
      echo "Unsupported operating system"
    fi
    ;;
esac

# 验证安装
echo "Docker version:"
sudo docker --version
echo "Docker Compose version:"
docker-compose --version

# 提示用户重启终端或重新登录
echo "1. 请注销并重新登录
2. 开一个新的终端以应用 Docker 组权限。
3. 运行下面的命令来更改应用组：
    newgrp docker"
<<<<<<< HEAD
=======


>>>>>>> e2e7a23c86a798562f36a892b3ccbe606e57a734
