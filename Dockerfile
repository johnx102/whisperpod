# Base officielle NVIDIA avec CUDA 12.1 + cuDNN8, compatible torch+cu121
FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

# Mise à jour et installation des paquets de base
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip git ffmpeg wget curl \
    build-essential cmake libopenblas-dev libomp-dev python3-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Mise à jour de pip
RUN python3 -m pip install --upgrade pip

# Installation des bibliothèques PyTorch compatibles CUDA 12.1
RUN pip install torch==2.3.0+cu121 torchvision==0.18.0+cu121 torchaudio==2.3.0+cu121 \
    --extra-index-url https://download.pytorch.org/whl/cu121

# Installation de WhisperX dernière version depuis GitHub
RUN pip install git+https://github.com/m-bain/whisperx.git

# Autres dépendances utiles à ton projet
RUN pip install \
    runpod==1.7.0 \
    pydub \
    cog \
    speechbrain==0.5.16 \
    huggingface-hub \
    cryptography<43.0.0 \
    numpy==1.24.2 \
    ctranslate2==4.3.1
