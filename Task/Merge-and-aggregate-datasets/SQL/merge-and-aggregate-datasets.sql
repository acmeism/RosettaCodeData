-- drop tables
DROP TABLE IF EXISTS tmp_patients;
DROP TABLE IF EXISTS tmp_visits;

-- create tables
CREATE TABLE tmp_patients(
	PATIENT_ID INT,
	LASTNAME VARCHAR(20)
);

CREATE TABLE tmp_visits(
	PATIENT_ID INT,
	VISIT_DATE DATE,
	SCORE NUMERIC(4,1)
);

-- load data from csv files
/*
-- Note: LOAD DATA LOCAL requires `local-infile` enabled on both the client and server else you get error "#1148 command is not allowed.."
LOAD DATA LOCAL INFILE '/home/csv/patients.csv' INTO TABLE `tmp_patients` FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE '/home/csv/visits.csv' INTO TABLE `tmp_visits` FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;
*/

-- load data hard coded
INSERT INTO tmp_patients(PATIENT_ID, LASTNAME)
VALUES
(1001, 'Hopper'),
(4004, 'Wirth'),
(3003, 'Kemeny'),
(2002, 'Gosling'),
(5005, 'Kurtz');

INSERT INTO tmp_visits(PATIENT_ID, VISIT_DATE, SCORE)
VALUES
(2002, '2020-09-10', 6.8),
(1001, '2020-09-17', 5.5),
(4004, '2020-09-24', 8.4),
(2002, '2020-10-08', NULL),
(1001, NULL, 6.6),
(3003, '2020-11-12', NULL),
(4004, '2020-11-05', 7.0),
(1001, '2020-11-19', 5.3);

-- join tables and group
SELECT
	p.PATIENT_ID,
	p.LASTNAME,
	MAX(VISIT_DATE) AS LAST_VISIT,
	SUM(SCORE) AS SCORE_SUM,
	CAST(AVG(SCORE) AS DECIMAL(10,2)) AS SCORE_AVG
FROM
	tmp_patients p
	LEFT JOIN tmp_visits v
		ON v.PATIENT_ID = p.PATIENT_ID
GROUP BY
	p.PATIENT_ID,
	p.LASTNAME
ORDER BY
	p.PATIENT_ID;
