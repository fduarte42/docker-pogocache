ARG TAG="1.0.2"

FROM debian:bookworm-slim AS builder
ARG TAG
RUN apt update -y && apt install -y build-essential git wget unzip
WORKDIR /app
RUN wget https://github.com/tidwall/pogocache/archive/refs/tags/${TAG}.zip \
    && unzip ${TAG}.zip \
    && mv pogocache-${TAG}/* . \
    && rm -rf pogocache-${TAG} ${TAG}.zip
RUN make distclean && make clean && make

FROM debian:bookworm-slim
COPY --from=builder /app/pogocache /usr/local/bin
EXPOSE 9401
ENTRYPOINT ["pogocache"]
CMD ["-h", "0.0.0.0"]