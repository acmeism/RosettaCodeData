-- create table airports with 14 columns
CREATE TABLE airports (
    Airport_ID serial PRIMARY KEY,
    Name VARCHAR NOT NULL,
    City VARCHAR,
    Country VARCHAR NOT NULL,
    IATA VARCHAR,
    ICAO VARCHAR,
    Latitude double precision NOT NULL,
    Longitude double precision NOT NULL,
    Altitude SMALLINT,
    Timezone VARCHAR,
    DST VARCHAR,
    Tz_Olson VARCHAR,
    Type VARCHAR,
    Source VARCHAR
);

-- copy CSV airports.dat from URL
COPY airports FROM
PROGRAM 'curl "https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat"'
WITH (FORMAT csv);
