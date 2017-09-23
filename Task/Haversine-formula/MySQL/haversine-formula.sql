DELIMITER $$

CREATE FUNCTION haversine (
		lat1 FLOAT, lon1 FLOAT,
		lat2 FLOAT, lon2 FLOAT
	) RETURNS FLOAT
	NO SQL DETERMINISTIC
BEGIN
	DECLARE r FLOAT unsigned DEFAULT 6372.8;
	DECLARE dLat FLOAT unsigned;
	DECLARE dLon FLOAT unsigned;
	DECLARE a FLOAT unsigned;
	DECLARE c FLOAT unsigned;
	
	SET dLat = RADIANS(lat2 - lat1);
	SET dLon = RADIANS(lon2 - lon1);
	SET lat1 = RADIANS(lat1);
	SET lat2 = RADIANS(lat2);
	
	SET a = POW(SIN(dLat / 2), 2) + COS(lat1) * COS(lat2) * POW(SIN(dLon / 2), 2);
	SET c = 2 * ASIN(SQRT(a));
	
	RETURN (r * c);
END$$

DELIMITER ;
