#!/bin/bash -xe
set -xe

#This script should be run on the ORIN device

function main(){
    local imagesdir=/home/isgdev/repos/jetson-inference/data/images
    mkdir -p ${imagesdir}/test/
    rm -f ${imagesdir}/test/*
    pushd /home/isgdev/bin

# Image classification:
# https://github.com/dusty-nv/jetson-inference/blob/master/docs/imagenet-console-2.md
    ./imagenet ${imagesdir}/orange_0.jpg ${imagesdir}/test/output_0.jpg #default model network is googlenet
    ./imagenet ${imagesdir}/strawberry_0.jpg ${imagesdir}/test/strawberry_0.jpg
    ./imagenet --network=resnet-18 ${imagesdir}/jellyfish.jpg ${imagesdir}/test/jellyfish.jpg #using different resnet-18 network

    #video
    # ./imagenet --network=resnet-18 jellyfish.mkv ${imagesdir}/test/jellyfish_resnet18.mkv

# Object Detection:
# https://github.com/dusty-nv/jetson-inference/blob/master/docs/detectnet-console-2.md

    ./detectnet --network=ssd-mobilenet-v2 ${imagesdir}/peds_0.jpg ${imagesdir}/test/peds_0.jpg     # --network flag is optional
    ./detectnet ${imagesdir}/peds_1.jpg ${imagesdir}/test/peds_1.jpg
    # ./detectnet --network=ssd-inception-v2 input.jpg output.jpg

# Semantic Segmentation:
# https://github.com/dusty-nv/jetson-inference/blob/master/docs/segnet-console-2.md

    ./segnet ${imagesdir}/orange_0.jpg ${imagesdir}/test/orange_0_segmentation.jpg
    ./segnet --network=fcn-resnet18-cityscapes ${imagesdir}/city_0.jpg ${imagesdir}/test/city_0.jpg

# Pose estimation
# https://github.com/dusty-nv/jetson-inference/blob/master/docs/posenet.md
    ./posenet "${imagesdir}/humans_*.jpg" ${imagesdir}/test/pose_humans_%i.jpg
    
    popd

    set +x
    echo "=================================================="
    echo "Finished running all examples"
    echo "All output is here: ${imagesdir}/test/"
    ls -lah ${imagesdir}/test/
    echo "=================================================="
    set -x

}

main