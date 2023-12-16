FROM registry:2.5

WORKDIR /app
COPY app.json auth.sh config.yml /app

CMD ["registry", "serve", "/app/config.yml"]
