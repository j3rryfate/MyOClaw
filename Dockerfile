FROM node:22

RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN npm install -g openclaw@latest


RUN mkdir -p /root/.openclaw

RUN echo '{\
  "gateway": {\
    "host": "0.0.0.0",\
    "port": 18789\
  },\
  "agents": {\
    "main": {\
      "auth": {\
        "choice": "gemini-api-key",\
        "gemini-api-key": "REPLACE_ME_KEY"\
      }\
    }\
  }\
}' > /root/.openclaw/openclaw.json

ENV PORT=18789
EXPOSE 18789

CMD ["sh", "-c", "sed -i \"s/REPLACE_ME_KEY/$GEMINI_API_KEY/g\" /root/.openclaw/openclaw.json && openclaw gateway run --port 18789 --host 0.0.0.0 --verbose"]
