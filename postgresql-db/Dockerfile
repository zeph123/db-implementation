ARG POSTGRES_VERSION=15.2
FROM postgres:${POSTGRES_VERSION}
RUN localedef -i pl_PL -c -f UTF-8 -A /usr/share/locale/locale.alias pl_PL.UTF-8
ENV LANG pl_PL.utf8