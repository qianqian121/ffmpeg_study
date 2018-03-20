# ffmpeg_study

https://askubuntu.com/questions/431966/build-libav-from-git-using-enable

https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

dev@dev-02:~/ffmpeg_sources/ffmpeg$ ./ffmpeg -y -hwaccel cuvid -c:v h264_cuvid -vsync 0 -i /mnt/Videos/project_video.mp4 -vf scale_npp=1920:1072 -vcodec h264_nvenc /mnt/Videos/output1.264

