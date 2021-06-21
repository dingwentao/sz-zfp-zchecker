FROM alpine:edge AS build
RUN apk update && \
    apk add alpine-sdk texlive texlive-dvi texmf-dist-latexextra gnuplot bash ghostscript gcc g++ cmake make git zlib-dev zstd-dev
RUN git clone https://github.com/CODARcode/z-checker-installer zchecker
WORKDIR /zchecker
RUN bash ./z-checker-install.sh
WORKDIR /
RUN git clone https://github.com/szcompressor/SZ.git SZ
WORKDIR /SZ
RUN ./configure; make -j 4; make install
WORKDIR /
RUN git clone https://github.com/szcompressor/qcat QCAT
WORKDIR /QCAT
RUN ./configure; make -j 4; make install
WORKDIR /
RUN wget https://github.com/LLNL/zfp/releases/download/0.5.5/zfp-0.5.5.tar.gz
RUN tar -xzvf zfp-0.5.5.tar.gz; mv zfp-0.5.5 ZFP
WORKDIR /ZFP
RUN make -j 4
WORKDIR /
RUN wget https://eecs.wsu.edu/~dtao/data/usecases.tar.gz
RUN tar -xzvf usecases.tar.gz

FROM alpine:edge
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing">>/etc/apk/repositories && \
    apk add --no-cache texlive texlive-dvi texmf-dist-latexextra gnuplot bash ghostscript gcc g++ cmake make git zlib-dev zstd-dev openssh openmpi-dev musl-dev hdf5-dev zip
RUN sed -i 's/PATH=/PATH=.:/g' /etc/profile
COPY --from=build /zchecker/ /zchecker/
COPY --from=build /SZ/ /SZ/
COPY --from=build /QCAT/ /QCAT/
COPY --from=build /ZFP/ /ZFP/
COPY --from=build /usecases/ /usecases/
COPY --from=build /usr/local/bin /usr/local/bin
WORKDIR /zchecker/Z-checker
RUN make -j 4; make install
WORKDIR /zchecker/zc-patches
RUN gcc -O3 -o manageCompressor manageCompressor.c -fPIC -I/zchecker/Z-checker/zc-install/include -L/zchecker/Z-checker/zc-install/lib -lzc -lm -Wl,-rpath /zchecker/Z-checker/zc-install/lib; mv manageCompressor ..
WORKDIR /
