# ffmpeg_study

https://askubuntu.com/questions/431966/build-libav-from-git-using-enable

https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

dev@dev-02:~/ffmpeg_sources/ffmpeg$ ./ffmpeg -y -hwaccel cuvid -c:v h264_cuvid -vsync 0 -i /mnt/Videos/project_video.mp4 -vf scale_npp=1280:720 -vcodec h264_nvenc /mnt/Videos/output0.264

dev@dev-02:~/ffmpeg_sources/ffmpeg$ ./ffmpeg -i /mnt/Videos/output0.264 -vcodec copy /mnt/Videos/output0.mp4

dev@dev-02:~/ffmpeg_sources/ffmpeg$ ./ffmpeg -y -hwaccel cuvid -c:v h264_cuvid -vsync 0 -i /mnt/Videos/project_video.mp4 -vf scale_npp=1280:720 -vcodec hevc_nvenc /mnt/Videos/output0.265

https://trac.ffmpeg.org/wiki/HWAccelIntro


https://developer.nvidia.com/ffmpeg
Getting Started with FFmpeg/libav using NVIDIA GPUs
Using NVIDIA hardware acceleration in FFmpeg/libav requires the following steps
Download the latest FFmpeg or libav source code, by cloning the corresponding GIT repositories
FFmpeg: https://git.ffmpeg.org/ffmpeg.git
Libav: https://github.com/libav/libav
Download and install the compatible driver from NVIDIA web site
Downoad and install the CUDA Toolkit CUDA toolkit
Use the following configure command (Use correct CUDA library path in config command below) 
./configure --enable-cuda --enable-cuvid --enable-nvenc --enable-nonfree --enable-libnpp 
--extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64
Use following command for build: make -j 10
Use FFmpeg/libav binary as required. To start with FFmpeg, try the below sample command line for 1:2 transcoding
ffmpeg -y -hwaccel cuvid -c:v h264_cuvid -vsync 0 -i <input.mp4> -vf scale_npp=1920:1072
-vcodec h264_nvenc <output0.264> -vf scale_npp=1280:720 -vcodec h264_nvenc <output1.264>

http://ntown.at/de/knowledgebase/cuda-gpu-accelerated-h264-h265-hevc-video-encoding-with-ffmpeg/
Parameters
-preset slow preset for HQ encoding (see x264 preset profiles below)
-tune film preset for film content (see x264 tune profiles below)
-crf 16 constant quality factor lower is better (good values for HD are 14-19)
-a aac AAC audio codec is most common for MP4 movie files
NOTE: Use -crf if bitrate is not so important and the quality factor is more important. Choose -b:v if you need a limitation for the bitrate and size of the video.
Encoding high quality h264 video via GPU:
ffmpeg.exe -hwaccel cuvid -i inmovie.mov -c:v h264_nvenc -pix_fmt yuv420p -preset slow -rc vbr_hq -b:v 8M -maxrate:v 10M -c:a aac -b:a 224k outmovie.mp4
Parameters
-hwaccel cuvid uses NVidia CUDA GPU acceleration for decoding (also working: dxva2)
-c:v h264_nvenc uses NVidia h264 GPU Encoder
-pix_fmt yuv420p 4:2:0 color subsampling
-preset slow HQ gpu encoding
-rc vbr_hq uses RC option to enable variable bitrate encoding with GPU encoding
-qmin:v 19 -qmax:v 14 sets minimum and maximum quantization values (optional)
-b:v 6M -maxrate:v 10M sets average (target) and maximum bitrate allowed for the encoder
Encoding high quality h265/HEVC 10-bit video via GPU:
ffmpeg.exe -hwaccel cuvid -i inmovie.mov -pix_fmt p010le -c:v hevc_nvenc -preset slow -rc vbr_hq -b:v 6M -maxrate:v 10M -c:a aac -b:a 240k outmovie.mp4 
Parameters
-hwaccel cuvid uses NVidia CUDA GPU acceleration for decoding (also working: dxva2)
-pix_fmt p010le YUV 4:2:0 10-bit
-c:v hevc_nvenc uses HEVC/h265 GPU hardware encoder
-preset slow HQ gpu encoding
-rc vbr_hq uses RC option to enable variable bitrate encoding with GPU encoding
-qmin:v 19 -qmax:v 14 sets minimum and maximum quantization values (optional)
-b:v 6M -maxrate:v 10M sets average and maximum bitrate allowed for the encoder 

https://www.reddit.com/r/pcgaming/comments/6vdmv6/guide_hardware_accelerated_h265hevc_encoding_for/
Guide] Hardware accelerated H265/HEVC encoding for Nvidia GTX 950 or newer card owners with FFMPEG (self.pcgaming)
submitted 7 months ago * by liufangii5-3570K OC | RX 480 | 16GB
Lets say you have a large video file (Lagarith | h264 high bitrate | YUV | YV12 | MJPEG | RGB | FRAPS), but your bandwidth makes uploading slow, and your CPU is not powerful enough to encode it in x265? There is a solution: FFMPEG (freeware encoder) supports H265/HEVC encoding using NVENC (hardware).
Download ffmpeg: http://ffmpeg.zeranoe.com/builds/
Extract it somewhere, you basically only need ffmpeg.exe (can put it into the folder where you keep your recorded videos).
In the folder with ffmpeg.exe create ffmpeg.bat file with the following content (edit it in the notepad):
ffmpeg.exe -i ".\video.mkv" -c:v hevc_nvenc -preset hq -profile:v main10 -tier high -rc constqp -rc-lookahead 40 -no-scenecut 1 -init_qpP 23 -init_qpB 25 -init_qpI 21 -weighted_pred 1 -c:a aac -b:a 320k -ac 2 ".\video_encoded.mkv"
pause
".\video.mkv" is the source file that is to be encoded.
".\video_encoded.mkv" is the name for encoded video.
You can freely use other containers like .avi, .mp4, etc as well (ffmpeg allows container convertion without re-encoding video).
-init_qpP 23 -init_qpB 25 -init_qpI 21 are compression level controls, lesser value results in better quality but larger file, higher value results in smaller file but less quality. 23 is a good compromise of size to quality, but you may also use something like 18.
-b:a 320k is audio bitrate (which can also be 192k or 256k) - use this if your audio stream is lossless. If audio stream is already lossy - replace -c:a aac -b:a 320k -ac 2 with -c:a copy so it will just copy existing audio stream.
Leave the rest as is.
If you wonder about all command line parameters - type:
ffmpeg.exe -h encoder=hevc_nvenc
pause
You can also directly encode in HEVC_NVENC if you set OBS-Studio like this: http://imgur.com/a/0jIic , however at the moment i do not know how to pass parameters there.
