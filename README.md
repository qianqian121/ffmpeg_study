# ffmpeg_study

https://askubuntu.com/questions/431966/build-libav-from-git-using-enable

https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

dev@dev-02:~/ffmpeg_sources/ffmpeg$ ./ffmpeg -y -hwaccel cuvid -c:v h264_cuvid -vsync 0 -i /mnt/Videos/project_video.mp4 -vf scale_npp=1280:720 -vcodec h264_nvenc /mnt/Videos/output0.264

dev@dev-02:~/ffmpeg_sources/ffmpeg$ ./ffmpeg -i /mnt/Videos/output0.264 -vcodec copy /mnt/Videos/output0.mp4

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
