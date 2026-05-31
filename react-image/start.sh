#!/bin/bash

# 에러 발생 시 스크립트 중단
set -e

# (옵션) 만약 여전히 docker-buildx 관련 에러가 발생한다면 아래 주석을 해제하세요.
# export DOCKER_BUILDKIT=0

# ==========================================
# 환경 설정
# ==========================================
IMAGE_NAME="rhel9-react-builder"
IMAGE_TAG="node20-yarn1"
CONTAINER_NAME="react-build-container"

# 호스트의 현재 경로 (React 프로젝트 루트에서 실행한다고 가정)
HOST_PROJECT_DIR="$(pwd)"
# 호스트의 Yarn 캐시 저장 경로
HOST_YARN_CACHE="${HOST_PROJECT_DIR}/.yarn_cache"

# 컨테이너 내부 경로 (Dockerfile의 WORKDIR 및 Yarn 내부 캐시 경로)
CONTAINER_PROJECT_DIR="/app"
CONTAINER_YARN_CACHE="/usr/local/share/.cache/yarn"

# 캐시 디렉터리가 호스트에 없다면 생성
if [ ! -d "$HOST_YARN_CACHE" ]; then
    echo "Creating host Yarn cache directory at: $HOST_YARN_CACHE"
    mkdir -p "$HOST_YARN_CACHE"
fi

# ==========================================
# 1. Docker 이미지 빌드
# ==========================================
echo "=========================================="
echo "Step 1: Building React Build Image..."
echo "=========================================="
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

# ==========================================
# 2. Docker 컨테이너 실행하여 빌드 수행
# ==========================================
echo "=========================================="
echo "Step 2: Running Yarn Install & Build in Container..."
echo "=========================================="

# --rm: 빌드 종료 후 컨테이너 자동 삭제
# -v: 소스 코드 및 Yarn 캐시 볼륨 마운트
docker run --rm \
  --name ${CONTAINER_NAME} \
  -v "${HOST_PROJECT_DIR}:${CONTAINER_PROJECT_DIR}" \
  -v "${HOST_YARN_CACHE}:${CONTAINER_YARN_CACHE}" \
  ${IMAGE_NAME}:${IMAGE_TAG}

echo "=========================================="
echo "React Project Build Completed Successfully!"
echo "=========================================="

