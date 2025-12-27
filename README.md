# ComfyUI Serverless Worker - Juggernaut XL Lightning

A Docker-based serverless worker for running the Juggernaut XL Lightning workflow on ComfyUI.

## Overview

This Docker image includes all the necessary custom nodes, models, and dependencies required to run the Juggernaut XL Lightning workflow. The workflow uses Stable Diffusion XL architecture with Lightning scheduling for fast generation.

## Custom Nodes Installed

The following custom node packages are installed:

- **comfyui-kjnodes** - Additional utility nodes
- **comfyui_essentials** - Essential custom nodes including LoRA Stacker and CR nodes
- **ComfyUI-Impact-Pack** - Required for UltimateSDUpscale, FaceDetailerPipe, ToDetailerPipe, SAMLoader, and UltralyticsDetectorProvider
- **ComfyUI-rgthree** - Provides the Seed (rgthree) node
- **ComfyUI-Inspire-Pack** - Required for MediaPipeFaceMeshDetectorProvider
- **ComfyUI-Crystools** - Provides utility nodes like Primitive boolean and Switch nodes

## Models Included

### Checkpoint
- **Juggernaut XL Lightning** (`xl/juggernautXL_v9Rdphoto2Lightning.safetensors`)
  - Located in `models/checkpoints/`
  - Main SDXL checkpoint with Lightning scheduling

### Upscale Models
- **4x_NMKD-Siax_200k.pth**
  - Located in `models/upscale_models/`
  - Used by UltimateSDUpscale node

### Face Detailer Models
- **SAM Model** (`sam_vit_b_01ec64.pth`)
  - Located in `models/sams/`
  - Used by SAMLoader for face detection

- **Eyeful Detector** (`bbox/Eyeful_v1.pt`)
  - Located in `models/adetailer/`
  - Ultralytics-based face detector for FaceDetailerPipe

### LoRA Files

The following LoRA files are included via local COPY in the Dockerfile:

- `xl/add-detail-xl.safetensors` - Detail enhancement LoRA (strength: 0.9)
- `xl/aesthetic_anime_v1s_xl.safetensors` - Aesthetic anime style LoRA (strength: 0.8)

These files are copied from the build context directory (`tutorial_2/`) into `/comfyui/models/loras/xl/` during the Docker build process.

**Note**: The workflow previously included a third LoRA (`Ais_Wallenstein_Bunny_xl_75_25_fp16.safetensors`), but it has been removed from the workflow and is no longer required.

## Building the Docker Image

1. Ensure you have Docker installed
2. Ensure the LoRA files (`add-detail-xl.safetensors` and `aesthetic_anime_v1s.safetensors`) are in the `tutorial_2/` directory
3. Build the image from the `tutorial_2/` directory:

```bash
cd tutorial_2
docker build -f comfy_serverless_juggernaut_xl/dockerfile -t comfyui-juggernaut-xl-lightning .
```

**Important**: The build context must be from the `tutorial_2/` directory so that the COPY commands can access the LoRA files.

## Usage

### Running with RunPod

This Dockerfile is designed for RunPod's serverless worker. To use it:

1. Push the image to a container registry (Docker Hub, etc.)
2. Configure RunPod serverless worker to use this image
3. Load the workflow file: `Juggernaut XL Lightning Workflow.json`
4. Set up your input prompts and run the workflow

### Local Testing

To test locally:

```bash
docker run -p 8188:8188 comfyui-juggernaut-xl-lightning
```

Then access ComfyUI at `http://localhost:8188`

## Workflow Features

The Juggernaut XL Lightning workflow includes:

- **Text-to-Image Generation** using Juggernaut XL Lightning checkpoint
- **LoRA Stacking** - Multiple LoRAs can be applied simultaneously
- **Face Detailer** - Automatic face detection and enhancement
- **Ultimate SD Upscale** - Advanced upscaling with control
- **Aspect Ratio Control** - SDXL aspect ratio presets
- **Seed Control** - Advanced seed management with rgthree nodes

## Input Requirements

The workflow expects:
- **Positive Prompt**: Main description of what you want to generate
- **Negative Prompt**: What to avoid in the generation
- **Aspect Ratio**: Selected via CR SDXL Aspect Ratio node
- **Seed**: Optional seed value for reproducibility

## Notes

- LoRA files are copied from the local `tutorial_2/` directory during build
- The `aesthetic_anime_v1s.safetensors` file will be renamed to `aesthetic_anime_v1s_xl.safetensors` in the Docker image to match the workflow expectations
- Ensure you have sufficient disk space for all models (~10GB+ recommended)
- The workflow uses SDXL format, so outputs will be larger than standard SD 1.5 workflows

## Troubleshooting

- **Missing LoRA errors**: Ensure LoRA files are downloaded and placed in `models/loras/xl/`
- **Missing node errors**: Verify all custom node packages are installed correctly
- **Model path errors**: Check that model files are in the correct subdirectories as specified in the Dockerfile
