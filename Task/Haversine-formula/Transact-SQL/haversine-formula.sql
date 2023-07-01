CREATE FUNCTION [dbo].[Haversine](@Lat1 AS DECIMAL(9,7), @Lon1 AS DECIMAL(10,7), @Lat2 AS DECIMAL(9,7), @Lon2 AS DECIMAL(10,7))
RETURNS DECIMAL(12,7)
AS
BEGIN
	DECLARE @R	DECIMAL(11,7);
	DECLARE @dLat	DECIMAL(9,7);
	DECLARE @dLon	DECIMAL(10,7);
	DECLARE @a	DECIMAL(10,7);
	DECLARE @c	DECIMAL(10,7);

	SET @R		= 6372.8;
	SET @dLat	= RADIANS(@Lat2 - @Lat1);
	SET @dLon	= RADIANS(@Lon2 - @Lon1);
	SET @Lat1	= RADIANS(@Lat1);
	SET @Lat2	= RADIANS(@Lat2);
	SET @a		= SIN(@dLat / 2) * SIN(@dLat / 2) + SIN(@dLon / 2) * SIN(@dLon / 2) * COS(@Lat1) * COS(@Lat2);
	SET @c		= 2 * ASIN(SQRT(@a));

	RETURN @R * @c;
END
GO

SELECT dbo.Haversine(36.12,-86.67,33.94,-118.4)
