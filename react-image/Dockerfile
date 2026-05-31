# 1. Base Image 설정 (RHEL 9.4 UBI)
FROM registry.access.redhat.com/ubi9/ubi:9.4

# 2. 환경 변수 설정
ENV NODE_VERSION=v20.17.0
ENV PATH=/usr/local/lib/nodejs/node-$NODE_VERSION-linux-x64/bin:$PATH

# 3. 필수 패키지 설치 및 Node.js / Yarn 설치
RUN dnf update -y && \
    dnf install -y wget tar xz gzip && \
    dnf clean all && \
    rm -rf /var/cache/dnf

# Node.js 20.17.0 수동 설치
RUN mkdir -p /usr/local/lib/nodejs && \
    wget -q https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.xz -P /tmp && \
    tar -xJf /tmp/node-$NODE_VERSION-linux-x64.tar.xz -C /usr/local/lib/nodejs && \
    rm /tmp/node-$NODE_VERSION-linux-x64.tar.xz

# Yarn 1.22.22 고정 설치
RUN npm install -g yarn@1.22.22

# 4. 작업 디렉터리 설정 (React 소스코드가 마운트될 위치)
WORKDIR /app

# 5. 기본 실행 명령 (컨테이너가 실행되면 의존성 설치 후 빌드 수행)
CMD ["sh", "-c", "yarn install && yarn build"]

