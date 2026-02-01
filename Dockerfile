FROM node:22

RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN npm install -g openclaw@latest

# Zeabur အတွက် Port ကို 8080 ပြောင်းလိုက်ပါမယ်
ENV OPENCLAW_GATEWAY_HOST=0.0.0.0
ENV PORT=8080
EXPOSE 8080

CMD ["sh", "-c", "openclaw onboard --non-interactive --accept-risk --mode local --auth-choice gemini-api-key --gemini-api-key \"$GEMINI_API_KEY\" --gateway-port 8080 && openclaw gateway run --port 8080 --host 0.0.0.0"]
