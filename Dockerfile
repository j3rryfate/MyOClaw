FROM node:22

RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN npm install -g openclaw@latest

ENV PORT=18789
EXPOSE 18789


CMD ["sh", "-c", "openclaw onboard --non-interactive --accept-risk --mode local --auth-choice gemini-api-key --gemini-api-key \"$GEMINI_API_KEY\" --gateway-port 18789 && \
    sed -i 's/127.0.0.1/0.0.0.0/g' /root/.openclaw/openclaw.json && \
    openclaw gateway run --port 18786 --host 0.0.0.0 --verbose"]
