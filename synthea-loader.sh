#!/bin/bash

rm -rf output

if [ -z "$1" ];
then
    numberOfPatients=10
else
    numberOfPatients=$1
    #numberOfPatients=10
fi

docker run --rm -v $PWD/data:/output --name synthea-docker intersystemsdc/irisdemo-base-synthea:version-1.3.4 -p $numberOfPatients

