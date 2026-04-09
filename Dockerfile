# Stage 1: dependancies
FROM node:20-alpine AS deps

WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production


# Stage 1: production
FROM node:20-alpine AS runner

WORKDIR /app

# Run as non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

USER appuser

# Copy deps 
COPY --from=deps --chown=appuser:appgroup /app/node_modules ./node_modules

COPY --chown=appuser:appgroup . . 

EXPOSE 8080

# HealthCheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
CMD wget -qO- http://217.76.61.226:8080/health || exit 1

CMD [ "node", "app.js" ]