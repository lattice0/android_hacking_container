xhost +
docker run -v $PWD:/home/project --privileged \
-v /dev/bus/usb:/dev/bus/usb \
-v ~/.android_aos_docker:/root/.android \
-v ~/.bash_history_aos_docker:/root/.bash_history \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-e DISPLAY=unix$DISPLAY -it \
-it aos /bin/bash -c "/bin/bash"
xhost -