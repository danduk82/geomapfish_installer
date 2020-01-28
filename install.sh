#!/bin/bash 
declare -A map_images=(
["camptocamp/tilecloud-chain:1.13"]="images/tilecloud-chain.tar"
["camptocamp/geomapfish:2.5"]="images/geomapfish.tar"
["camptocamp/geomapfish-tools:2.5"]="images/geomapfish-tools.tar"
["camptocamp/geomapfish-config:2.5"]="images/geomapfish-config.tar"
["redis:5"]="images/redis.tar"
["camptocamp/mapfish_print:3.21"]="images/mapfish_print.tar"
["camptocamp/geomapfish-qgisserver:gmf2.5-qgis3.10"]="images/qgisserver.tar"
["haproxy:1.9"]="images/haproxy.tar"
["camptocamp/postgres:10"]="images/postgresql.tar"
)

function usage(){
    echo "some help"
}

function pull_images(){
    for i in ${!map_images[@]}; do
        docker pull $i
    done
}

function pack_images(){
    if [ ! -d images ]; then
        mkdir images
    fi
    for i in ${!map_images[@]}; do
        docker save $i > ${map_images[$i]}
    done
}

function unpack_images(){
    for i in $(ls images/*.tar) ; do
        docker load -i ${i}
    done
}

# MAIN
while getopts "h?vx:upP" opt; do
    case "${opt}" in
    h|\?)
        usage
        exit 0
        ;;
    x)  output_file=$OPTARG
        ;;
    u)  unpack_images
        ;;
    p)  pack_images
        ;;
    P)  pull_images
        ;;
    esac
done
