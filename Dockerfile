FROM node:22

RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates nginx \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN npm install -g openclaw@latest

RUN echo 'server {\
    listen 18789;\
    location / {\
        proxy_pass http://127.0.0.1:18790;\
        proxy_http_version 1.1;\
        proxy_set_header Upgrade $http_upgrade;\
        proxy_set_header Connection "upgrade";\
        proxy_set_header Host $host;\
    }\
}' > /etc/nginx/sites-available/default

ENV PORT=18789
EXPOSE 18789


CMD ["sh", "-c", "openclaw onboard --non-interactive --accept-risk --mode local --auth-choice gemini-api-key --gemini-api-key \"$GEMINI_API_KEY\" --gateway-port 18790 && \
    service nginx start && \
    openclaw gateway run --port 18790 --verbose"]
