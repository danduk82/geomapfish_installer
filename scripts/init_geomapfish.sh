#!/bin/bash

# this is a very rough "thing" that should never be used but is quite helpful to 
# start a new geomapfish from scratch




function init(){
    # create a new geomapfish project from scratch
    docker run --rm -ti --volume=$(pwd):/src   camptocamp/geomapfish-tools:2.5 run $(id -u) $(id -g) /src pcreate -s c2cgeoportal_create $package_name
    # and run update directly
    docker run --rm -ti --volume=$(pwd):/src   camptocamp/geomapfish-tools:2.5 run $(id -u) $(id -g) /src pcreate -s c2cgeoportal_update $package_name
    git init .
    git add .
    git commit -m "initial commit"
    sed -i "s,PGHOST=pg-cluster-master.exo.camptocamp.com,PGHOST=172.17.0.1,g" env.sample
    sed -i "s,PGHOST_SLAVE=pg-cluster-replica-0.exo.camptocamp.com,PGHOST_SLAVE=172.17.0.1,g" env.sample
    sed -i "s,PGPORT=5432,PGPORT=65432,g" env.sample
}

function create_db(){
    # start and initialize DB
    docker run --name=${package_name}_db --env=POSTGRES_PASSWORD=www-data --env=POSTGRES_USER=www-data --env=POSTGRES_DB=gmf_${package_name} --env=PGPASSWORD=www-data --env=PGUSER=www-data --env=PGDATABASE=gmf_$package_name --detach --publish=65432:5432 camptocamp/postgres:10
    until docker exec ${package_name}_db psql -c "CREATE EXTENSION IF NOT EXISTS postgis;" ; do
    	sleep 1;
    done
    docker exec ${package_name}_db psql -c "CREATE EXTENSION IF NOT EXISTS pg_trgm;"
    docker exec ${package_name}_db psql -c "CREATE EXTENSION IF NOT EXISTS hstore;"
    docker exec ${package_name}_db psql -c "CREATE SCHEMA main;"
    docker exec ${package_name}_db psql -c "CREATE SCHEMA main_static;"
}

function goto(){
    cd $package_name
}

function run(){
./build
docker-compose up -d
}

function migrate_db(){
docker-compose exec geoportal alembic --config=alembic.ini --name=main upgrade head
docker-compose exec geoportal alembic --config=alembic.ini --name=static upgrade head
}



# MAIN
function main(){
init
goto
create_db
run
migrate_db
}


package_name=${1:-"package_gmf"}
# if file is executed and not sourced
if [[ "${BASH_SOURCE[0]}" = "${0}" ]] ; then
    main
fi

