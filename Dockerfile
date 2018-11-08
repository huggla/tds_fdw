ARG TAG="20181108-edge"

FROM huggla/tds_fdw:$TAG as tdsfdw
FROM huggla/alpine-official:$TAG as alpine

ARG RUNDEPS="libressl2.7-libssl unixodbc"

COPY --from=tdsfdw /tds_fdw /

RUN apk add $RUNDEPS
