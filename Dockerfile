#####################
##  Builder stage  ##
#####################
FROM alpine AS builder
WORKDIR /build

# Install build dependencies
RUN apk add --no-cache build-base wget coreutils patch busybox-static

# Get frankenphp
RUN wget -qO- https://frankenphp.dev/install.sh | sh

# Build a statically linked daemontools from source 
RUN wget https://cr.yp.to/daemontools/daemontools-0.76.tar.gz \
    && tar xzf daemontools-0.76.tar.gz
WORKDIR /build/admin/daemontools-0.76/src
RUN wget https://gitlab.alpinelinux.org/alpine/aports/-/raw/master/testing/daemontools/0.76-C99-decls.patch \
    && wget https://gitlab.alpinelinux.org/alpine/aports/-/raw/master/testing/daemontools/0.76-const-typecasts-C99.patch \
    && wget https://gitlab.alpinelinux.org/alpine/aports/-/raw/master/testing/daemontools/0.76-errno.patch \
    && wget https://gitlab.alpinelinux.org/alpine/aports/-/raw/master/testing/daemontools/0.76-implicit-func-decl-clang16.patch
RUN patch -p1 < 0.76-C99-decls.patch \
    && patch -p1 < 0.76-const-typecasts-C99.patch \
    && patch -p1 < 0.76-errno.patch \
    && patch -p1 < 0.76-implicit-func-decl-clang16.patch
RUN echo "gcc -static ${CFLAGS}" > conf-cc \
    && echo "gcc -static ${LDFLAGS}" > conf-ld
RUN cd .. && package/compile


#####################
##   Final image   ##
#####################
FROM scratch

# These are all static binaries
COPY --from=builder /build/admin/daemontools-0.76/command/svscan /bin/svscan
COPY --from=builder /build/admin/daemontools-0.76/command/supervise /bin/supervise
COPY --from=builder /build/frankenphp /bin/frankenphp
COPY --from=builder /bin/busybox.static /bin/busybox

# /launcher will need to be mounted
ENTRYPOINT ["/bin/svscan"]
CMD ["/launcher"]
