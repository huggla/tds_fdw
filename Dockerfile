ARG DESTDIR="/tds_fdw"

FROM huggla/freetds:1.00.103 as freetds
FROM huggla/alpine-official:20181005-edge as alpine

ARG BUILDDEPS="postgres-dev git g++"
ARG DESTDIR

COPY --from=freetds /freetds /freetds-dev /

RUN apk --no-cache add $BUILDDEPS \
 && mkdir -p $DESTDIR \
 && buildDir="$(mktemp -d)" \
 && cd $buildDir \
 && git clone https://github.com/tds-fdw/tds_fdw.git \
 && cd tds_fdw \
 && make USE_PGXS=1 \
 && make USE_PGXS=1 install \
 && echo "huggla/tds_fdw depends on huggla/postgresql and huggla/freetds" > $DESTDIR/README-tds_fdw

FROM scratch as image

ARG DESTDIR

COPY --from=alpine $DESTDIR $DESTDIR
