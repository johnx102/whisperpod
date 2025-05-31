FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Dépendances système
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.9 python3.9-dev python3.9-distutils python3-pip \
    git ffmpeg wget curl build-essential cmake \
    libopenblas-dev libomp-dev ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Fix Python/Pip
RUN ln -sf /usr/bin/python3.9 /usr/bin/python3 && \
    ln -sf /usr/bin/pip3 /usr/bin/pip && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3

# Upgrade pip
RUN pip install --upgrade pip

# PyTorch + cu121 (compatible avec GPU RunPod)
RUN pip install torch==2.3.1+cu121 torchvision==0.18.1+cu121 torchaudio==2.3.1+cu121 \
    --extra-index-url https://download.pytorch.org/whl/cu121

# WhisperX (dernière version)
RUN pip install git+https://github.com/m-bain/whisperx.git

# Autres dépendances
RUN pip install \
    runpod==1.7.10 \
    pydub \
    cog \
    speechbrain==0.5.16 \
    huggingface-hub \
    numpy==1.24.2 \
    cryptography<43.0.0 \
    ctranslate2==4.3.1
