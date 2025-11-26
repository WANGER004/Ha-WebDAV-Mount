#!/usr/bin/env bash
# 启动脚本，功能：
# 1. 启动 API 服务监听 8127
# 2. 配置 nginx 监听 8127 并代理 API 请求
# 3. 启动 nginx

CONFIG_PATH=/data/options.json

# 启动 API 服务（监听本地 8127）
/app/api.sh &

# 配置 Nginx 监听 8127 并代理 /api/
cat > /etc/nginx/conf.d/default.conf <<EOL
server {
    listen 8127;  # 直接暴露端口 8127

    server_name _;

    root /var/www/html;

    # 转发 API 请求到本地 8127
    location /api/ {
        proxy_pass http://127.0.0.1:8127/;
    }

    # 静态文件
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOL

# 启动 nginx 前台运行
nginx -g 'daemon off;'
