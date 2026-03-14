FROM node:lts-alpine AS build
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@latest --activate

COPY pnpm-lock.yaml package.json ./
RUN pnpm install --frozen-lockfile

COPY . .
RUN pnpm build

FROM caddy:2-alpine
USER 1000
COPY --from=build /app/dist /srv
EXPOSE 19840
CMD ["caddy", "file-server", "--listen", ":19480", "--root", "/srv"]
