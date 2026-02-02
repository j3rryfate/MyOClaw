FROM node:22

# socat ကို ထပ်သွင်းပေးရပါမယ်
RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates socat \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN npm install -g openclaw@latest

# Port သတ်မှတ်ချက်
ENV PORT=18789
EXPOSE 18789

# CMD ထဲမှာ Socat ကို background မှာ run ခိုင်းပြီး OpenClaw ကိုပါ တစ်ခါတည်း run ပါမယ်
# 0.0.0.0:18789 ကလာတဲ့ data ကို 127.0.0.1:18789 ဆီ အတင်းလွှဲပေးတဲ့ နည်းလမ်းပါ
CMD ["sh", "-c", "openclaw onboard --non-interactive --accept-risk --mode local --auth-choice gemini-api-key --gemini-api-key \"$GEMINI_API_KEY\" --gateway-port 18789 && \
    socat TCP-LISTEN:18789,fork,reuseaddr TCP:127.0.0.1:18789 & \
    openclaw gateway run --port 18789 --verbose"]
