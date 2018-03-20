# ffmpeg_study

https://askubuntu.com/questions/431966/build-libav-from-git-using-enable

https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

dev@dev-02:~/ffmpeg_sources/ffmpeg$ ./ffmpeg -y -hwaccel cuvid -c:v h264_cuvid -vsync 0 -i /mnt/Videos/project_video.mp4 -vf scale_npp=1280:720 -vcodec h264_nvenc /mnt/Videos/output0.264

dev@dev-02:~/ffmpeg_sources/ffmpeg$ ./ffmpeg -i /mnt/Videos/output0.264 -vcodec copy /mnt/Videos/output0.mp4
