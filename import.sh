#!/bin/bash
BENCHMARK_DATA_DIR=$1
echo "#######################################################################"
echo "DOWNLOADING OSM DATA"
echo "#######################################################################"
wget https://download.geofabrik.de/north-america/us/california-latest.osm.pbf -O ${BENCHMARK_DATA_DIR}/california-latest.osm.pbf
wget https://download.geofabrik.de/north-america/us/new-york-latest.osm.pbf -O ${BENCHMARK_DATA_DIR}/new-york-latest.osm.pbf
wget https://download.geofabrik.de/north-america/us/utah-latest.osm.pbf -O ${BENCHMARK_DATA_DIR}/utah-latest.osm.pbf

LA_COUNTY_OSM_FILE=${BENCHMARK_DATA_DIR}/osm/la_county.osm
NY_COUNTY_OSM_FILE=${BENCHMARK_DATA_DIR}/osm/ny_county.osm
SL_COUNTY_OSM_FILE=${BENCHMARK_DATA_DIR}/osm/sl_county.osm
LA_CITY_OSM_FILE=${BENCHMARK_DATA_DIR}/osm/la.osm
NY_CITY_OSM_FILE=${BENCHMARK_DATA_DIR}/osm/nyc.osm
SL_CITY_OSM_FILE=${BENCHMARK_DATA_DIR}/osm/slc.osm

osmosis --read-pbf file=${BENCHMARK_DATA_DIR}/california-latest.osm.pbf --tf reject-relations  --bounding-box left=-118.8927 bottom=33.6964 right=-117.5078 top=34.8309 clipIncompleteEntities=true --write-xml file=$LA_COUNTY_OSM_FILE

osmosis --read-pbf file=${BENCHMARK_DATA_DIR}/new-york-latest.osm.pbf --tf reject-relations  --bounding-box left=-74.047225  bottom=40.679319 right=-73.906159 top=40.882463 clipIncompleteEntities=true --write-xml file=$NY_COUNTY_OSM_FILE

osmosis --read-pbf file=${BENCHMARK_DATA_DIR}/utah-latest.osm.pbf --tf reject-relations  --bounding-box left=-112.260184 bottom=40.414864 right=-111.560498 top=40.921879 clipIncompleteEntities=true --write-xml file=$SL_COUNTY_OSM_FILE

osmosis --read-pbf file=${BENCHMARK_DATA_DIR}/california-latest.osm.pbf --tf reject-relations  --bounding-box left=-118.6682 bottom=33.7036 right=-118.1553 top=34.3373 clipIncompleteEntities=true --write-xml file=$LA_CITY_OSM_FILE

osmosis --read-pbf file=${BENCHMARK_DATA_DIR}/new-york-latest.osm.pbf --tf reject-relations  --bounding-box left=-74.25909  bottom=40.477399 right=-73.700181 top=40.916178 clipIncompleteEntities=true --write-xml file=$NY_CITY_OSM_FILE

osmosis --read-pbf file=${BENCHMARK_DATA_DIR}/utah-latest.osm.pbf --tf reject-relations  --bounding-box left=-112.101607 bottom=40.699893 right=-111.739476 top=40.85297 clipIncompleteEntities=true --write-xml file=$SL_CITY_OSM_FILE

echo "IMPORT OSM DATA"
echo "#######################################################################"

echo "IMPORT NEW YORK CITY"
echo "#######################################################################"
sudo scripts/create_db_osm.sh los_angeles_county $LA_COUNTY_OSM_FILE
sudo scripts/create_db_osm.sh new_york_county $NY_COUNTY_OSM_FILE
sudo scripts/create_db_osm.sh salt_lake_county $SL_COUNTY_OSM_FILE
sudo scripts/create_db_osm.sh los_angeles_city $LA_CITY_OSM_FILE
sudo scripts/create_db_osm.sh new_york_city $NY_CITY_OSM_FILE
sudo scripts/create_db_osm.sh salt_lake_city $SL_CITY_OSM_FILE
