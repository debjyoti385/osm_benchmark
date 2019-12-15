## OSM Benchmark with PostgreSQL

Data:
```
      DATABASE                       AREA                                   BOUNDING BOX
1. los_angeles_county : Los Angeles County, California, USA    -118.8927,33.6964,-117.5078,34.8309 
2. new_york_county    : New York County, New York, USA         -74.047225,40.679319,-73.906159,40.882463 
3. salt_lake_county   : Salt Lake Couty, Utah, USA             -112.260184,40.414864,-111.560498,40.921879
4. los_angeles_city   : Los Angeles City, California, USA      -118.6682,33.7036,118.1553,34.3373
5. new_york_city      : New York City, New York, USA           -74.25909,40.477399,-73.700181,40.916178
6. salt_lake_city     : Salt Lake City, Utah, USA              -112.101607,40.699893,-111.739476,40.85297
```



Run:
```
./import.sh <DATA_DIR>
./prepare_routing.sh <DATABASE>
./run_benchmark.sh <DATABASE> <BOUNDING BOX> <ITERATIONS>
```

Prerequisite:
```
sudo apt-get install -y postgresql-10-postgis-2.4 postgresql-10-postgis-scripts postgis postgresql-10-pgrouting osmosis osm2pgsql
````
