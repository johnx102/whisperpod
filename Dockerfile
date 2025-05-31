# Base NVIDIA officielle avec CUDA 12.1 + cuDNN8
FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# Dépendances système stables et vérifiées
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip git ffmpeg wget curl \
    build-essential cmake libopenblas-dev libomp5 python3-dev \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Met à jour pip
RUN python3 -m pip install --upgrade pip

# PyTorch + cu121
RUN pip install torch==2.5.1+cu121 torchvision==0.18.1+cu121 torchaudio==2.5.1+cu121 \
    --extra-index-url https://download.pytorch.org/whl/cu121

# WhisperX dernière version
RUN pip install git+https://github.com/m-bain/whisperx.git

# Dépendances complémentaires
RUN pip install \
    runpod==1.7.0 \
    pydub \
    cog \
    speechbrain==0.5.16 \
    huggingface-hub \
    numpy==1.24.2 \
    cryptography<43.0.0 \
    ctranslate2==4.3.1
