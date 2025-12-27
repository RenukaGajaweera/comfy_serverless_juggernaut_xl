# start from a clean base image (replace <version> with the desired release)
FROM runpod/worker-comfyui:5.1.0-base

# install custom nodes using comfy-cli
RUN comfy-node-install comfyui-kjnodes comfyui_essentials ComfyUI-Impact-Pack ComfyUI-rgthree ComfyUI-Inspire-Pack ComfyUI-Crystools

# download the correct checkpoint model
RUN comfy model download --url https://huggingface.co/RunDiffusion/Juggernaut-XL-Lightning/resolve/main/juggernautXL_v9Rdphoto2Lightning.safetensors --relative-path models/checkpoints --filename xl/juggernautXL_v9Rdphoto2Lightning.safetensors

# download upscale model
RUN comfy model download --url https://github.com/n00mkrad/upscaler-models/raw/main/4x_NMKD-Siax_200k.pth --relative-path models/upscale_models --filename 4x_NMKD-Siax_200k.pth

# download SAM model for face detailer
RUN comfy model download --url https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth --relative-path models/sams --filename sam_vit_b_01ec64.pth

# download Ultralytics detector model
RUN comfy model download --url https://huggingface.co/Bingsu/adetailer/resolve/main/models/bbox/Eyeful_v1.pt --relative-path models/adetailer --filename bbox/Eyeful_v1.pt

# Create LoRA directory structure
# RUN mkdir -p /comfyui/models/loras/xl

# Copy local LoRA files (build context should be from parent directory: tutorial_2/)
# Build command: docker build -f comfy_serverless_juggernaut_xl/dockerfile -t comfyui-juggernaut-xl .
# COPY add-detail-xl.safetensors /comfyui/models/loras/xl/add-detail-xl.safetensors
# COPY aesthetic_anime_v1s.safetensors /comfyui/models/loras/xl/aesthetic_anime_v1s_xl.safetensors
