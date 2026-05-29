FROM alpine:latest

RUN apk add --no-cache \
    bash \
    ttyd

EXPOSE 7681

CMD ["ttyd", "-W", "bash"]
