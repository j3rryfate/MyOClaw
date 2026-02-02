FROM node:22

RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN npm install -g openclaw@latest

# Port 18789 အတွက် ပြင်ဆင်ခြင်း
ENV PORT=18789
EXPOSE 18789

# Step 1: onboard ကို အရင် run ခိုင်းပြီး JSON အမှန်ကို ထွက်လာအောင်လုပ်မယ်
# Step 2: ထွက်လာတဲ့ JSON ထဲက loopback IP ကို sed နဲ့ အတင်းလိုက်ပြင်မယ်
# Step 3: Gateway ကို 0.0.0.0 မှာ bind ပြီး run မယ်
CMD ["sh", "-c", "openclaw onboard --non-interactive --accept-risk --mode local --auth-choice gemini-api-key --gemini-api-key \"$GEMINI_API_KEY\" --gateway-port 18789 && \
    sed -i 's/127.0.0.1/0.0.0.0/g' /root/.openclaw/openclaw.json && \
    openclaw gateway run --port 18789 --bind-all --verbose || openclaw gateway run --port 18789 --verbose"]
