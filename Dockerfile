FROM alpine:latest

# 1. Instala o Tailscale, ttyd e ferramentas básicas
RUN apk update && apk add --no-cache \
    tailscale \
    ttyd \
    bash \
    curl

# 2. Cria a pasta para guardar os dados do Tailscale
RUN mkdir -p /data

# 3. Cria o script de inicialização direto dentro do contêiner
RUN echo '#!/bin/sh' > /entrypoint.sh && \
    echo 'echo "Iniciando o Tailscaled em modo Userspace..."' >> /entrypoint.sh && \
    echo 'tailscaled --state=/data/tailscaled.state --tun=userspace-networking --socks5-server=localhost:1055 --outbound-http-proxy-listen=localhost:1055 &' >> /entrypoint.sh && \
    echo 'sleep 2' >> /entrypoint.sh && \
    echo 'echo "Conectando ao Tailscale..."' >> /entrypoint.sh && \
    echo 'tailscale up --authkey="tskey-auth-kyuTjdEsqD11CNTRL-4PKPUpftgF7z6u7KtekYG7noi3d5rtBXb" --hostname="alpine-railway"' >> /entrypoint.sh && \
    echo 'echo "Iniciando o ttyd na porta ${PORT:-7681}..."' >> /entrypoint.sh && \
    echo 'exec ttyd -p "${PORT:-7681}" /bin/sh' >> /entrypoint.sh

# 4. Dá permissão de execução para o script
RUN chmod +x /entrypoint.sh

# 5. Informa a porta que o contêiner vai usar
EXPOSE 7681

# 6. Define o comando para rodar ao iniciar
ENTRYPOINT ["/entrypoint.sh"]
