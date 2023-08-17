#!/bin/bash -xe
set -xe

user=$(whoami)
uid=$(id -u)
gid=$(id -g)
email=${user}@foobar.com
curdir=$(pwd)
dockerimage="nvidia-jetson-orin"
dockertag="v1"
dockerimagetargz=${1:-/media/sf_D_DRIVE/${dockerimage}.${dockertag}.tar.gz}

docker_loaded=$(docker image ls "${dockerimage}:${dockertag}" | grep "${dockerimage}") && true
echo "aaa"
if [ "$docker_loaded" == "" ]; then
   if [ ! -f "${dockerimagetargz}" ]; then
      set +x 
      echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
      echo "./enter-docker.sh <path/to/${dockerimage}.${dockertag}.tar.gz>"
      echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
      exit -1
   fi
   docker load < "${dockerimagetargz}"
fi

mkdir -p tmp
rm -fr tmp/*
sudo cp /etc/passwd /etc/group /etc/shadow /etc/sudoers tmp/
sudo chown $(id -u):$(id -g) tmp/*
mv tmp/passwd tmp/etc.passwd
mv tmp/group tmp/etc.group
mv tmp/shadow tmp/etc.shadow
mv tmp/sudoers tmp/etc.sudoers
cat tmp/etc.sudoers | sed -r 's|@includedir /etc/sudoers.d|#@includedir /etc/sudoers.d|g' > tmp/~etc.sudoers
echo "$(whoami) ALL=(ALL) NOPASSWD:ALL" >> tmp/~etc.sudoers
mv -f tmp/~etc.sudoers tmp/etc.sudoers
sudo chmod 440 tmp/etc.sudoers
sudo chown 0:0 tmp/*

docker run -it --rm --sysctl fs.mqueue.msg_max=512 -e DOCKERUSER=${user} -e USER=${user} -e UID=${uid} -e GID=${gid} -e DISPLAY=:0 -e GDK_BACKEND=wayland -e QT_QPA_PLATFORM=wayland -e SDL_VIDEODRIVER=wayland -e XDG_RUNTIME_DIR=/run/user/1000 -e WAYLAND_DISPLAY= -e GITUSER=${user} -e GITEMAIL=${email} -e SDK_DIR=/opt/usr_data/sdk -v /home/${user}:/home/${user} -v ${curdir}/tmp/etc.passwd:/etc/passwd -v ${curdir}/tmp/etc.group:/etc/group -v ${curdir}/tmp/etc.shadow:/etc/shadow -v ${curdir}/tmp/etc.sudoers:/etc/sudoers -v /tmp/.X11-unix:/tmp/.X11-unix -v /home/${user}/.Xauthority:/home/${user}/.Xauthority -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket -v /run/user/1000:/run/user/1000 -v /dev/bus/usb:/dev/bus/usbs -v /media/isgdev/1885b256-daf3-4ea6-b95b-d4d23af9a578:/media/isgdev/1885b256-daf3-4ea6-b95b-d4d23af9a578 --device /dev/snd:/dev/snd --user 1000:1000 --workdir=${curdir} --memory=7.8g --memory-swap=7.8g --name jambamamba.${dockerimage}.${dockertag}  --cap-add=SYS_PTRACE --privileged=true -it ${dockerimage}:${dockertag} bash
