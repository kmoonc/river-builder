#!/bin/bash

# 에러 발생 시 스크립트 중단
set -e
export DOCKER_BUILDKIT=0

# ==========================================
# 환경 설정 (사용자 환경에 맞게 수정 가능)
# ==========================================
IMAGE_NAME="rhel9-gradle"
IMAGE_TAG="8.1.1-jdk17"
CONTAINER_NAME="gradle-build-container"

# 호스트의 현재 경로 (프로젝트 루트에서 실행한다고 가정)
#HOST_PROJECT_DIR="$(pwd)"
#/home/kmoonc/gitRepo/river-builder/river-src/backend_ewa-organizations
HOST_PROJECT_DIR="$(pwd)/../river-src/backend_ewa-organizations"
# 호스트의 Gradle 캐시 경로 (없으면 현재 디렉터리 하위에 생성)
#HOST_GRADLE_CACHE="${HOST_PROJECT_DIR}/.gradle_home_cache"
HOST_GRADLE_CACHE="$(pwd)/.gradle_home_cache"

# 컨테이너 내부 경로 (Dockerfile 설정과 일치해야 함)
CONTAINER_PROJECT_DIR="/home/gradle/project"
CONTAINER_GRADLE_CACHE="/root/.gradle"

# 캐시 디렉터리가 호스트에 없다면 생성
if [ ! -d "$HOST_GRADLE_CACHE" ]; then
    echo "Creating host gradle cache directory at: $HOST_GRADLE_CACHE"
    mkdir -p "$HOST_GRADLE_CACHE"
fi

# ==========================================
# 1. Docker 이미지 빌드
# ==========================================
echo "=========================================="
echo "Step 1: Building Docker Image..."
echo "=========================================="
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

# ==========================================
# 2. Docker 컨테이너 실행 및 프로젝트 빌드
# ==========================================
echo "=========================================="
echo "Step 2: Running Gradle Build in Container..."
echo "=========================================="

# --rm: 컨테이너 종료 후 자동 삭제
# -v: 호스트와 컨테이너 간 디렉터리 마운트
docker run --rm \
  --name ${CONTAINER_NAME} \
  -v "${HOST_PROJECT_DIR}:${CONTAINER_PROJECT_DIR}" \
  -v "${HOST_GRADLE_CACHE}:${CONTAINER_GRADLE_CACHE}" \
  ${IMAGE_NAME}:${IMAGE_TAG} \
  gradle clean build --no-daemon

echo "=========================================="
echo "Build Completed Successfully!"
echo "=========================================="



