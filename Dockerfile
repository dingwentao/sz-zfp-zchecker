FROM alpine:edge AS build
RUN apk update && \
    apk add alpine-sdk texlive gnuplot bash ghostscript cmake git zlib-dev zstd-dev
RUN git clone https://github.com/CODARcode/z-checker-installer zchecker
WORKDIR /zchecker
RUN bash ./z-checker-install.sh
RUN ./manageCompressor -d SZauto -c manageCompressor-SZauto.cfg
WORKDIR /
RUN git clone https://github.com/szcompressor/SZ.git SZ
WORKDIR /SZ
RUN ./configure; make
WORKDIR /
RUN git clone https://github.com/szcompressor/qcat QCAT
WORKDIR /QCAT
RUN ./configure; make
WORKDIR /
RUN wget https://github.com/LLNL/zfp/releases/download/0.5.5/zfp-0.5.5.tar.gz
RUN tar -xzvf zfp-0.5.5.tar.gz; mv zfp-0.5.5 ZFP
WORKDIR /ZFP
RUN make
WORKDIR /
RUN wget https://eecs.wsu.edu/~dtao/data/usecases.tar.gz
RUN tar -xzvf usecases.tar.gz

FROM alpine:edge
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing">>/etc/apk/repositories && \
    apk add --no-cache texlive texlive-dvi texmf-dist-latexextra gnuplot bash ghostscript openssh openmpi-dev musl-dev gcc hdf5-dev make git zlib zstd zip
RUN sed -i 's/PATH=/PATH=.:/g' /etc/profile
COPY --from=build /zchecker/ /zchecker/
COPY --from=build /SZ/ /SZ/
COPY --from=build /QCAT/ /QCAT/
COPY --from=build /ZFP/ /ZFP/
COPY --from=build /usecases/ /usecases/


