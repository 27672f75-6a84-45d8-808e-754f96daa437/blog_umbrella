FROM hexpm/elixir:1.14.0-erlang-25.0.4-ubuntu-jammy-20220428 as builder
ARG _MIX_ENV
ARG _RELEASE_NAME
RUN apt-get update
# argon2 dependency
RUN apt-get install gcc make -y 
WORKDIR /src
COPY . .
RUN mix local.rebar --force
RUN mix local.hex --force
RUN mix deps.get
RUN MIX_ENV=${_MIX_ENV} mix release ${_RELEASE_NAME}
RUN mv _build/${_MIX_ENV}/rel/${_RELEASE_NAME} /opt/release
RUN mv /opt/release/bin/${_RELEASE_NAME} /opt/release/bin/app

FROM ubuntu:jammy-20220428 as runner
RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales && apt-get clean && rm -f /var/lib/apt/lists/*_*
WORKDIR /opt/release
COPY --from=builder /opt/release .
CMD /opt/release/bin/app start