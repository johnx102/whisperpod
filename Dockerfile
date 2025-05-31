FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# Installe Python 3.9 manuellement
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.9 python3.9-dev python3.9-distutils \
    git ffmpeg wget curl \
    build-essential cmake libopenblas-dev libomp-dev ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure python3 et pip par défaut sur Python 3.9
RUN ln -sf python3.9 /usr/bin/python3 && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.9

# Installe torch compatible CUDA 12.1 (cu121) + WhisperX + dépendances
RUN pip install --upgrade pip

RUN pip install torch==2.3.1+cu121 torchvision==0.18.1+cu121 torchaudio==2.3.1+cu121 \
    --extra-index-url https://download.pytorch.org/whl/cu121

RUN pip install git+https://github.com/m-bain/whisperx.git

RUN pip install \
    runpod==1.7.0 \
    pydub \
    cog \
    speechbrain==0.5.16 \
    huggingface-hub \
    numpy==1.24.2 \
    cryptography<43.0.0 \
    ctranslate2==4.3.1
