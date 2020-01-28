#!/bin/bash 

docker save camptocamp/geomapfish:2.5 > images/geomapfish.tar
docker save camptocamp/geomapfish-tools:2.5 > images/geomapfish-tools.tar
docker save camptocamp/geomapfish-config:2.5 > images/geomapfish-config.tar
docker save redis:5 > images/redis.tar
docker save camptocamp/mapfish_print:3.21 > images/mapfish_print.tar
docker save camptocamp/geomapfish-qgisserver:gmf2.5-qgis3.10 > images/qgisserver.tar
docker save haproxy:1.9 > images/haproxy.tar
docker save camptocamp/postgres:10 > images/postgresql.tar
