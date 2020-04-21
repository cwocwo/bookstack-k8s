FROM golang:1.13.3 AS builder
RUN apt update && apt install -y git && \
#    apt install -y zip && \
    apt install -y wget && \
    mkdir -p /go/src/github.com/TruthHun/ && \
    cd /go/src/github.com/TruthHun/ && \
    git clone https://github.com/cwocwo/BookStack.git && \
    cd BookStack && \
    git checkout -b v2.7 origin/v2.7 && \
    go get -d -v ./...
WORKDIR /go/src/github.com/TruthHun/BookStack/ 
RUN mkdir dist && ./build.sh && \
    cp -r conf dictionary static views dist/ && \
    cp crawl.js output/linux/BookStack favicon.ico LICENSE.md dist/ && \
    mv dist/conf/app.conf.example dist/conf/app.conf && \
    mv dist/conf/oauth.conf.example dist/conf/oauth.conf && \
    mv dist/conf/oss.conf.example dist/conf/oss.conf


FROM ubuntu:18.04
RUN apt update && apt install -y ttf-wqy-zenhei && \
    apt install -y fonts-wqy-microhei && \
    apt install -y wget && \
    apt install -y python && \
    wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()" && \
    apt install -y chromium-browser && \
    apt install -y git && \
    apt-get clean && rm -rf /var/lib/apt/lists /tmp/* /var/tmp/*
   
# COPY --from=builder /go/src/github.com/TruthHun/BookStack/conf/*.example ./conf/
COPY --from=builder /go/src/github.com/TruthHun/BookStack/dist /opt/bookstack/ 
COPY bookstack.sh /opt/bookstack/
EXPOSE 8181
WORKDIR /opt/bookstack
CMD ["/opt/bookstack/bookstack.sh"]
# RUN rm conf/*.go
