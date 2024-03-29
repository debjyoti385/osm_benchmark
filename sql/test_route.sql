-- shortest path based on node id
CREATE OR REPLACE FUNCTION get_network_id (text) RETURNS INTEGER AS $$
  DECLARE
    -- Declare aliases for user input.
    ewkt ALIAS FOR $1;  
    -- Declare a variable to hold the customer ID number.
    id integer;
  BEGIN
    -- Retrieve the node ID closest to the input-coordinate
    Select source_id, ST_DistanceSpheroid(pt, ST_ClosestPoint(line,pt), 'SPHEROID["WGS 84",6378137,298.257223563]') AS dist INTO id
FROM (SELECT ST_GeomFromEWKT(ewkt)::geometry AS pt, the_geom AS line, source AS source_id from network) AS Points ORDER BY dist LIMIT 1;
    -- Return the ID number
    RAISE NOTICE 'Found closest node: %',id;
    RETURN CAST (id AS INTEGER);
  END;
$$ LANGUAGE 'plpgsql';

-- SELECT SUM(cost) AS distance FROM shortest_path('SELECT gid AS id, source, target, length AS cost FROM network', get_network_id(:start), get_network_id(:end),false,false);
SELECT SUM(cost) AS distance FROM pgr_dijkstra('SELECT gid AS id, source, target, length AS cost, length AS reverse_cost FROM network', get_network_id(:start), get_network_id(:end),false);
