FROM ubuntu:22.04 as builder

RUN apt-get update && apt-get install --no-install-recommends -y git python3.10 python3.10-dev python3.10-venv python3-pip python3-wheel build-essential && \
   apt-get clean && rm -rf /var/lib/apt/lists/*

# create and activate virtual environment
RUN python3.10 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# install requirements
RUN git clone --depth 1 https://github.com/ndoell/gato.git && \
    cd gato && \
    pip3 install --no-cache-dir .

FROM ubuntu:22.04 AS runner
RUN apt-get update && apt-get install --no-install-recommends -y git python3.10 python3-venv && \
   apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/venv /opt/venv

# activate virtual environment
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="/opt/venv/bin:$PATH"

ENTRYPOINT ["python", "/opt/venv/bin/gato"]