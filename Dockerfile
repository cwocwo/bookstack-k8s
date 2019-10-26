FROM golang:1.13.3
mkdir -p /go/src/github.com/TruthHun/
WORKDIR /go/src/github.com/TruthHun/
RUN apt install git && \
    apt install zip && \
    apt install wget && \
    git clone https://github.com/cwocwo/BookStack.git && \
    cd BookStack && \
    go get -d -v ./... && \ 
    ./build.sh && \

FROM ubuntu:18.04
RUN apt install ttf-wqy-zenhei && \
    apt install fonts-wqy-microhei && \
    sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()" && \
    apt install chromium-browser && \
    apt install git && \
    
