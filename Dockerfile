FROM node:22

RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN npm install -g openclaw@latest

# Config directory ဆောက်ခြင်း
RUN mkdir -p /root/.openclaw

# OpenClaw ၏ Schema အမှန်အတိုင်း JSON ကို တည်ဆောက်ခြင်း
RUN echo '{\
  "gateway": {\
    "bind": "0.0.0.0",\
    "port": 18789\
  },\
  "instances": [\
    {\
      "name": "main",\
      "auth": {\
        "choice": "gemini-api-key",\
        "gemini-api-key": "REPLACE_ME_KEY"\
      }\
    }\
  ]\
}' > /root/.openclaw/openclaw.json

ENV PORT=18789
EXPOSE 18789

# --host command ကို ဖယ်ထုတ်ပြီး JSON ထဲက bind ကိုပဲ အားကိုးပါမယ်
CMD ["sh", "-c", "sed -i \"s/REPLACE_ME_KEY/$GEMINI_API_KEY/g\" /root/.openclaw/openclaw.json && openclaw gateway run --port 18789 --verbose"]
