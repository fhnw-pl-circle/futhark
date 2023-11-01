FROM haskell:9.4-slim

RUN git clone https://github.com/diku-dk/futhark.git \
    && cd futhark \
    && make configure \
    && make build \
    && make install

