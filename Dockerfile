# syntax=docker/dockerfile:1
# Builds our branded fork instead of pulling public.ecr.aws/zinclabs/openobserve:latest.
# Modeled directly on OpenObserve's own release build (deploy/build/Dockerfile.tag.amd64)
# so it stays easy to diff against upstream when we rebase onto a new pinned version.

FROM public.ecr.aws/docker/library/node:24-trixie AS webbuilder
WORKDIR /web
COPY ./web /web/
RUN npm install
RUN NODE_OPTIONS="--max-old-space-size=8192" npm run build

FROM public.ecr.aws/zinclabs/rust:trixie-sccache AS builder
WORKDIR /openobserve
COPY . /openobserve
COPY --from=webbuilder /web/dist web/dist
RUN mkdir -p /openobserve/target/release/
RUN cargo build --profile release-prod --features mimalloc --target x86_64-unknown-linux-gnu
RUN mv /openobserve/target/x86_64-unknown-linux-gnu/release-prod/openobserve /openobserve/target/release/openobserve

FROM gcr.io/distroless/cc-debian13 AS runtime
COPY --from=builder /openobserve/target/release/openobserve /
COPY --from=builder /lib/x86_64-linux-gnu/liblzma.so.5 /lib/x86_64-linux-gnu/liblzma.so.5
COPY --from=builder /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libz.so.1
COPY --from=builder /lib/x86_64-linux-gnu/libbz2.so.1.0 /lib/x86_64-linux-gnu/libbz2.so.1.0
RUN ["/openobserve", "init-dir", "-p", "/data/"]
CMD ["/openobserve"]
