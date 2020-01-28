#!/bin/bash 

for i in $(ls images/*.tar) ; do
    docker load -i images/${i}
done
