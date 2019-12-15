#!/bin/bash
PSQL_COMMAND="sudo -u postgres psql"
DBNAME=$1
INPUT_BBOX=$2
ITERATIONS=$3
echo "DBNAME:  $DBNAME"
echo "TIMES:  $ITERATIONS"
echo "INPUT BBOX:  $INPUT_BBOX"
new_bbox=""
new_point=""

overwrite() { echo -e "\r\033[1A\033[0K$@"; }

random_bbox(){
    STR1=$1
    STR2=`echo $STR1 | sed 's/ /,/g'`
    coord=($STR2)

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
    STR1=$1
    STR2=`echo $STR1 | sed 's/ /,/g'`
    coord=($STR2)

    left=${coord[0]}
    bottom=${coord[1]}
    right=${coord[2]}
    top=${coord[3]}
    lon=`awk -v min=$left -v max=$right -v seed="$RANDOM" 'BEGIN { srand(seed); printf("%.4f\n", min+rand()*(max-min) ) }'`
    lat=`awk -v min=$bottom -v max=$top -v seed="$RANDOM" 'BEGIN { srand(seed); printf("%.4f\n", min+rand()*(max-min) ) }'`
    new_point="$lon $lat"

}


echo "BOUNDING BOX QUERIES"
for i in $(seq 1 $ITERATIONS); do 
    random_bbox $INPUT_BBOX
    overwrite "$i QUERY BBOX: $new_bbox"
    $PSQL_COMMAND -d $DBNAME -v bbox="$new_bbox, 4326" -f sql/test_bbox.sql > /dev/null  
done

echo "CLOSEST POINT QUERIES "
for i in $(seq 1 $ITERATIONS); do 
    random_point $INPUT_BBOX
    overwrite "$i QUERY POINT: $new_point"
    $PSQL_COMMAND -d $DBNAME -v point="'SRID=4326;POINT($new_point)'" -f sql/test_closestpoint.sql > /dev/null
done

echo "GML QUERIES "
for i in $(seq 1 $ITERATIONS); do 
    random_bbox $INPUT_BBOX
    overwrite "$i QUERY BBOX: $new_bbox"
    $PSQL_COMMAND -d $DBNAME -v bbox="$new_bbox, 4326" -f sql/test_gml.sql > /dev/null  
done

echo "ROUTE FINDING QUERIES "
for i in $(seq 1 $ITERATIONS); do 
    random_point $INPUT_BBOX
    first_point=$new_point
    random_point $INPUT_BBOX
    second_point=$new_point
    overwrite "$i QUERY POINTS: $first_point and $second_point"
    $PSQL_COMMAND -d $DBNAME -v start="'SRID=4326;POINT($first_point)'" -v end="'SRID=4326;POINT($second_point)'" -f sql/test_route.sql > /dev/null
done
