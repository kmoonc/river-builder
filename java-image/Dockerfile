# 1. Base Image 설정 (RHEL 9.4 UBI)
FROM registry.access.redhat.com/ubi9/ubi:9.4

# 2. 환경 변수 설정
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV GRADLE_HOME=/opt/gradle/gradle-8.1.1
ENV PATH=$PATH:$JAVA_HOME/bin:$GRADLE_HOME/bin

# 3. 필수 패키지(Java 17, wget, unzip) 설치 및 Gradle 다운로드/설치
RUN dnf update -y && \
    dnf install -y java-17-openjdk-devel wget unzip && \
    dnf clean all && \
    rm -rf /var/cache/dnf

# Gradle 8.1.1 수동 설치
RUN wget -q https://services.gradle.org/distributions/gradle-8.1.1-bin.zip -P /tmp && \
    mkdir /opt/gradle && \
    unzip -d /opt/gradle /tmp/gradle-8.1.1-bin.zip && \
    rm /tmp/gradle-8.1.1-bin.zip

# 4. 작업 디렉터리 설정 (프로젝트 소스가 마운트될 위치)
WORKDIR /home/gradle/project

# 5. 기본 실행 명령 (컨테이너 실행 시 빌드가 수행되도록 설정 가능)
CMD ["gradle", "build", "--no-daemon"]

