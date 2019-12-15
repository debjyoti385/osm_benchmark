#!/bin/bash
PSQL_COMMAND="sudo -u postgres psql"
DBNAME=$1

echo "WARM UP "
START=$(python -c'import time; print repr(time.time())')
$PSQL_COMMAND -d $DBNAME -f sql/warm-up.sql
END1=$(python -c'import time; print repr(time.time())')
#echo "Took: " $(bc -l <<< $END1-$START)



echo "CREATE GEAOGRAPHY "
START=$(python -c'import time; print repr(time.time())')
$PSQL_COMMAND -d $DBNAME -f sql/create_geography.sql
END1=$(python -c'import time; print repr(time.time())')
#echo "Took: " $(bc -l <<< $END1-$START)



echo "CREATE TOPOLOGIES "
START=$(python -c'import time; print repr(time.time())')
$PSQL_COMMAND -d $DBNAME -f sql/create_topology.sql
END1=$(python -c'import time; print repr(time.time())')
#echo "Took: " $(bc -l <<< $END1-$START)
