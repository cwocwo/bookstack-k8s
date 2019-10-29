FROM golang:1.13.3 AS builder
RUN apt update && apt install -y git && \
    apt install -y zip && \
    apt install -y wget && \
    mkdir -p /go/src/github.com/TruthHun/ && \
    cd /go/src/github.com/TruthHun/ && \
    git clone https://github.com/cwocwo/BookStack.git && \
    cd BookStack && \
    go get -d -v ./...
WORKDIR /go/src/github.com/TruthHun/BookStack/ 
RUN ./build.sh 

FROM ubuntu:18.04
WORKDIR /opt/
RUN apt update && apt install -y ttf-wqy-zenhei && \
    apt install -y fonts-wqy-microhei && \
    sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()" && \
    apt install -y chromium-browser && \
    apt install -y git && \
# COPY --from=builder /go/src/github.com/TruthHun/BookStack/conf/*.example ./conf/
COPY --from=builder /go/src/github.com/TruthHun/BookStack/conf \ 
                    /go/src/github.com/TruthHun/BookStack/dictionary \ 
                    /go/src/github.com/TruthHun/BookStack/dictionary/static \
                    /go/src/github.com/TruthHun/BookStack/dictionary/views \ 
                    /go/src/github.com/TruthHun/BookStack/dictionary/crawl.js 
                    /go/src/github.com/TruthHun/BookStack/output/linux/BookStack
            ./
RUN rm conf/*.go
