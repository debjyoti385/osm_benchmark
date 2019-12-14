#!/bin/bash


PSQL_COMMAND="sudo -u postgres psql"
DBNAME=$1
input_bbox=$2
times=$3



new_bbox=""
new_point=""

overwrite() { echo -e "\r\033[1A\033[0K$@"; }

random_bbox(){
    IFS=', ' read -r -a coord <<< "$1"
    left=${coord[0]}
    bottom=${coord[1]}
    right=${coord[2]}
    top=${coord[3]}
    new_left=`awk -v min=$left -v max=$right -v seed="$RANDOM" 'BEGIN { srand(seed); printf("%.4f\n", min+rand()*(max-min) ) }'`
    new_bottom=`awk -v min=$bottom -v max=$top -v seed="$RANDOM" 'BEGIN { srand(seed); printf("%.4f\n", min+rand()*(max-min) ) }'`
    new_right=`awk -v min=$new_left -v max=$right -v seed="$RANDOM" 'BEGIN { srand(seed); printf("%.4f\n", min+rand()*(max-min) ) }'`
    new_top=`awk -v min=$new_bottom -v max=$top -v seed="$RANDOM" 'BEGIN { srand(seed); printf("%.4f\n", min+rand()*(max-min) ) }'`
    new_bbox=$new_left,$new_bottom,$new_right,$new_top
}

random_point(){
    IFS=', ' read -r -a coord <<< "$1"
    left=${coord[0]}
    bottom=${coord[1]}
    right=${coord[2]}
    top=${coord[3]}
    lon=`awk -v min=$left -v max=$right -v seed="$RANDOM" 'BEGIN { srand(seed); printf("%.4f\n", min+rand()*(max-min) ) }'`
    lat=`awk -v min=$bottom -v max=$top -v seed="$RANDOM" 'BEGIN { srand(seed); printf("%.4f\n", min+rand()*(max-min) ) }'`
    new_point="$lon $lat"

}


echo "BOUNDING BOX QUERIES "
START=$(python -c'import time; print repr(time.time())')
echo "BOUNDING BOX QUERIES"
for i in $(seq 1 $times); do 
    random_bbox $input_bbox
    overwrite "$i QUERY BBOX: $new_bbox"
    $PSQL_COMMAND -d $DBNAME -v bbox="$new_bbox, 4326" -f sql/test_bbox.sql > /dev/null  
done
END1=$(python -c'import time; print repr(time.time())')
echo "Took: " $(bc -l <<< $END1-$START)

echo "CLOSEST POINT QUERIES "
START=$(python -c'import time; print repr(time.time())')
echo "POINT DISTANCE QUERIES"
for i in $(seq 1 $times); do 
    random_point $input_bbox
    overwrite "$i QUERY POINT: $new_point"
    $PSQL_COMMAND -d $DBNAME -v point="'SRID=4326;POINT($new_point)'" -f sql/test_closestpoint.sql > /dev/null
done
END1=$(python -c'import time; print repr(time.time())')
echo "Took: " $(bc -l <<< $END1-$START)

echo "GML QUERIES "
START=$(python -c'import time; print repr(time.time())')
echo "BOUNDING BOX QUERIES"
for i in $(seq 1 $times); do 
    random_bbox $input_bbox
    overwrite "$i QUERY BBOX: $new_bbox"
#    $PSQL_COMMAND -d $DBNAME -v bbox="$new_bbox, 4326" -f sql/test_gml.sql > /dev/null  
done
END1=$(python -c'import time; print repr(time.time())')
echo "Took: " $(bc -l <<< $END1-$START)

echo "ROUTE FINDING QUERIES "
START=$(python -c'import time; print repr(time.time())')
echo "POINT DISTANCE QUERIES"
for i in $(seq 1 $times); do 
    random_point $input_bbox
    first_point=$new_point
    random_point $input_bbox
    second_point=$new_point
    overwrite "$i QUERY POINTS: $first_point and $second_point"
    $PSQL_COMMAND -d $DBNAME -v start="'SRID=4326;POINT($first_point)'" -v end="'SRID=4326;POINT($second_point)'" -f sql/test_route.sql > /dev/null
done
END1=$(python -c'import time; print repr(time.time())')
echo "Took: " $(bc -l <<< $END1-$START)
