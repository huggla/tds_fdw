ARG TAG="20181106-edge"

FROM huggla/freetds:test2 as freetds
FROM huggla/tds_fdw:$TAG as tdsfdw
FROM huggla/alpine-official:$TAG as alpine

ARG RUNDEPS="libressl2.7-libssl unixodbc"

COPY --from=freetds /usr /usr
COPY --from=freetds /etc /etc
COPY --from=tdsfdw /tds_fdw /

RUN apk --no-cache add $RUNDEPS
