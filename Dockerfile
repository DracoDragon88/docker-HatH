FROM anapsix/alpine-java:8

# Install dependencies 
RUN apk --no-cache add curl sqlite unzip

# Common
ENV HatH_VERSION 1.6.4
ENV HatH_DOWNLOAD_URL https://repo.e-hentai.org/hath/HentaiAtHome_$HatH_VERSION.zip
ENV HatH_DOWNLOAD_SHA256 25351e4b43169f0bad25abcfe7f61034f03cca08b69f219727713975dc5b03b1
ENV HatH_USER hath
ENV HatH_PATH "/home/$HatH_USER/client"
ENV HatH_ARCHIVE hath.zip
ENV HatH_PORT 4915
ENV HatH_JAR HentaiAtHome.jar
ENV HatH_ARGS -Xms16m -Xmx512m --silentstart

# Container Setup
RUN adduser -D "$HatH_USER" && \
    mkdir "$HatH_PATH" && \
    cd "$HatH_PATH" && \
    curl -fsSL "$HatH_DOWNLOAD_URL" -o "$HatH_ARCHIVE" && \
    echo -n ""$HatH_DOWNLOAD_SHA256"  "$HatH_ARCHIVE"" | sha256sum -c && \
    unzip "$HatH_ARCHIVE" && \
    rm "$HatH_ARCHIVE"

RUN mkdir -p "$HatH_PATH/cache" "$HatH_PATH/data" "$HatH_PATH/download" "$HatH_PATH/hathdl" "$HatH_PATH/tmp"

COPY client/ "$HatH_PATH/"

RUN chmod -R 775 "$HatH_PATH"
WORKDIR "$HatH_PATH"

# Expose the port
EXPOSE "$HatH_PORT"

VOLUME ["$HatH_PATH/cache", "$HatH_PATH/data", "$HatH_PATH/download", "$HatH_PATH/hathdl"]

CMD java -jar "$HatH_JAR" "$HatH_ARGS"
