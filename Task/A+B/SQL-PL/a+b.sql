CREATE OR REPLACE FUNCTION splitadd (instring VARCHAR(255))
	RETURNS INTEGER
	NO EXTERNAL ACTION
F1: BEGIN ATOMIC

	declare first INTEGER;
	declare second INTEGER;
	
	set first = REGEXP_SUBSTR(instring, '[0-9]+',1,1);
	set second = REGEXP_SUBSTR(instring, '[0-9]+',1,2);

	return first + second;
END
