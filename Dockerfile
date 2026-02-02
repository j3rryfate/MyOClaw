FROM node:22

RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates socat \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN npm install -g openclaw@latest


ENV PORT=18789
EXPOSE 18789

CMD ["sh", "-c", "openclaw onboard --non-interactive --accept-risk --mode local --auth-choice gemini-api-key --gemini-api-key \"$GEMINI_API_KEY\" --gateway-port 18790 && \
    socat TCP-LISTEN:18789,fork,reuseaddr TCP:127.0.0.1:18790 & \
    openclaw gateway run --port 18790 --verbose"]
