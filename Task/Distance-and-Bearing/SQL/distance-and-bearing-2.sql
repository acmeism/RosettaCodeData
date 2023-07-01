-- calculate distance
CREATE OR REPLACE FUNCTION calculate_distance(lat1 float, lon1 float, lat2 float, lon2 float, units varchar)
RETURNS numeric AS $dist$
    DECLARE
        dist float = 0;
        radlat1 float;
        radlat2 float;
        theta float;
        radtheta float;
    BEGIN
        IF lat1 = lat2 AND lon1 = lon2
            THEN RETURN dist;
        ELSE
            radlat1 = pi() * lat1 / 180;
            radlat2 = pi() * lat2 / 180;
            theta = lon1 - lon2;
            radtheta = pi() * theta / 180;
            dist = sin(radlat1) * sin(radlat2) + cos(radlat1) * cos(radlat2) * cos(radtheta);

            IF dist > 1 THEN dist = 1; END IF;

            dist = acos(dist);
            dist = dist * 180 / pi();

            -- Distance in Statute Miles
            dist = dist * 60 * 1.1515576;

            -- Distance in Kilometres
            IF units = 'K' THEN dist = dist * 1.609344; END IF;

            -- Distance in Nautical Miles
            IF units = 'N' THEN dist = dist * 0.868976; END IF;

            dist = dist::numeric;
            RETURN dist;
        END IF;
    END;
$dist$ LANGUAGE plpgsql;


-- calculate bearing
CREATE OR REPLACE FUNCTION calculate_bearing(lat1 float, lon1 float, lat2 float, lon2 float)
RETURNS numeric AS $bear$
    DECLARE
        bear float = NULL;
        radlat1 float;
        radlat2 float;
        raddlon float;
        y float;
        x float;

    BEGIN
        IF lat1 = lat2 AND lon1 = lon2
            THEN RETURN bear;
        ELSE
            radlat1 = pi() * lat1 / 180;
            radlat2 = pi() * lat2 / 180;
            raddlon = pi() * (lon2 - lon1) / 180;

            y = sin(raddlon) * cos(radlat2);
            x = cos(radlat1) * sin(radlat2) - sin(radlat1) * cos(radlat2) * cos(raddlon);

            bear = atan2(y, x) * 180 / pi();
            bear = (bear::numeric + 360) % 360;

            RETURN bear;
        END IF;
    END;
$bear$ LANGUAGE plpgsql;
