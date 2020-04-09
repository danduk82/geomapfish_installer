#!/bin/bash 
declare -A map_images=(
["camptocamp/tilecloud-chain:1.13"]="images/tilecloud-chain.tar"
["camptocamp/geomapfish:2.5"]="images/geomapfish.tar"
["camptocamp/geomapfish-tools:2.5"]="images/geomapfish-tools.tar"
["camptocamp/geomapfish-config:2.5"]="images/geomapfish-config.tar"
["redis:5"]="images/redis.tar"
["camptocamp/mapfish_print:3.22"]="images/mapfish_print.tar"
["camptocamp/geomapfish-qgisserver:gmf2.5-qgis3.10"]="images/qgisserver.tar"
["haproxy:1.9"]="images/haproxy.tar"
["camptocamp/postgres:10"]="images/postgresql.tar"
)

DOCKER_VERSION=19.03.5
DOCKER_COMPOSE_VERSION=1.17.0

function usage(){
    echo "usage: $0 [options]"
    echo ""
    echo "OPTIONS:"
    echo "  - h : show this help"
    echo "* INSTALL:"
    echo "  - c : check dependencies"
    echo "  - i : install the project"
    echo "  - u : unpack images"
    echo "* PACKAGING:"
    echo "  - p : pack images"
    echo "  - P : pull images"
    echo "  - g : checkout geomapfish project"
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

function check_version() {
	min_version=$1
	cur_version=$2
	res=$(python3 -c "print('$min_version' <= '$cur_version')")
	if [ "${res}" = "False" ] ; then
		echo "CRITICAL: '${3}' version not supported, please use at least version $min_version"
		echo "the current version detected on the system is : $cur_version"
		exit 1
	fi
}

function check_dependencies() {
	# check docker version
	docker_cur_version=$(docker --version| awk '{print $3}' | sed 's/,//g')
	check_version $DOCKER_VERSION $docker_cur_version docker
	docker_compose_cur_version=$(docker-compose --version| awk '{print $3}' | sed 's/,//g')
	check_version $DOCKER_COMPOSE_VERSION $docker_compose_cur_version docker-compose
}

function install() {
    check_dependencies
    unpack_images
    HERE=$PWD
    cd package_gmf
    ./scripts/initialize.sh
    cd ${HERE}
}

# MAIN
while getopts "h?icupaPg" opt; do
    case "${opt}" in
    h|\?)
        usage
        exit 0
        ;;
    c)  check_dependencies
        ;;
    i)  install
        ;;
    u)  unpack_images
        ;;
    p)  pack_images
        ;;
    P)  pull_images
        ;;
    g)  if [ -d ./package_gmf ]; then
          rm -rf ./package_gmf 
        fi
	rsync -a ../package_gmf .
        ;;
    esac
done
