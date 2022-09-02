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
```


If you are using this tool, please cite the following paper.

```
@article{10.14778/3503585.3503600,
  author = {Paul, Debjyoti and Cao, Jie and Li, Feifei and Srikumar, Vivek},
  title = {Database Workload Characterization with Query Plan Encoders},
  year = {2021},
  issue_date = {December 2021},
  publisher = {VLDB Endowment},
  volume = {15},
  number = {4},
  issn = {2150-8097},
  url = {https://doi.org/10.14778/3503585.3503600},
  doi = {10.14778/3503585.3503600},
  journal = {Proc. VLDB Endow.},
  month = {dec},
  pages = {923–935},
  numpages = {13}
}
```
