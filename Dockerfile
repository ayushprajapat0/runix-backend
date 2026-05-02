FROM node:20-alpine AS deps

WORKDIR /usr/src/app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts

FROM node:20-alpine AS runner

LABEL org.opencontainers.image.title="codeME-backend"
LABEL org.opencontainers.image.description="codeME API server and code-execution worker"

ENV NODE_ENV=production

WORKDIR /usr/src/app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=deps /usr/src/app/node_modules ./node_modules

COPY . .

RUN chown -R appuser:appgroup /usr/src/app

USER appuser

EXPOSE 5000

CMD ["node", "app/server.js"]
