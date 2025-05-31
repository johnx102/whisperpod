FROM runpod/base:0.6.2-cuda12.4.1

SHELL ["/bin/bash", "-c"]
WORKDIR /

# Update and upgrade the system packages (Worker Template)
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends ffmpeg wget git libcudnn9 libcudnn9-dev build-essential python3-dev cmake libopenblas-dev libomp-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create cache directories
RUN mkdir -p /cache/models
RUN mkdir -p /root/.cache/torch

# Upgrade pip and install base Python packages needed early
RUN python3 -m pip install --upgrade pip hf_transfer numpy==1.24.2

# Install PyTorch from source
RUN git clone --recursive --branch v2.3.1 https://github.com/pytorch/pytorch.git /pytorch
WORKDIR /pytorch

ENV USE_CUDA=1
ENV USE_CUDNN=1
ENV TORCH_CUDA_ARCH_LIST="7.5;8.0;8.6;8.9;9.0"
ENV MAX_JOBS=4

RUN python3 setup.py install

# Install TorchVision and TorchAudio from source
RUN python3 -m pip install 'git+https://github.com/pytorch/vision.git@v0.18.1'
RUN python3 -m pip install 'git+https://github.com/pytorch/audio.git@v2.3.1'

WORKDIR /

# Copy only requirements file first to leverage Docker cache
COPY builder/requirements.txt /builder/requirements.txt

# Install remaining Python dependencies
RUN python3 -m pip install -r /builder/requirements.txt

# Copy the local VAD model to the expected location
COPY models/whisperx-vad-segmentation.bin /root/.cache/torch/whisperx-vad-segmentation.bin

# Copy the rest of the builder files
COPY builder /builder

# Download Faster Whisper Models
RUN chmod +x /builder/download_models.sh
RUN /builder/download_models.sh

# Copy source code
COPY src .

CMD [ "python3", "-u", "/rp_handler.py" ]
