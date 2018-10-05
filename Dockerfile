FROM huggla/postgresql as postgresql
FROM huggla/alpine-official:20181005-edge as alpine

ARG BUILDDEPS="git g++"

COPY --from=postgresql /postgresql /

RUN apk --no-cache add $BUILDDEPS \
 && buildDir="$(mktemp -d)" \
 && cd $buildDir \
 && git clone https://github.com/tds-fdw/tds_fdw.git \
 && cd tds_fdw \
 && make USE_PGXS=1 \
 && destDir="/apps/tds_fdw" \
 && mkdir -p $destDir \
 && make -j1 DESTDIR="$destDir" USE_PGXS=1 install \
 && apk --no-cache --purge del $BUILDDEPS \
 && cd / \
 && rm -rf "$buildDir"

FROM scratch as image

COPY --from=alpine /apps /
