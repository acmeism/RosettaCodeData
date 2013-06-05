-- variable table
DROP TABLE IF EXISTS var;
CREATE temp TABLE var (	VALUE VARCHAR(1000) );
INSERT INTO var(VALUE) SELECT '1A2B3C4D5E6F';

-- select
WITH recursive
ints(num) AS
(
	SELECT 1
	UNION ALL
	SELECT num+1
	FROM ints
	WHERE num+1 <= LENGTH((SELECT VALUE FROM var))
)
,
chars(num,chr,nextChr) AS
(
	SELECT tmp.*
	FROM (
	SELECT num,
		SUBSTRING((SELECT VALUE FROM var), num, 1) chr,
		(SELECT SUBSTRING((SELECT VALUE FROM var), num+1, 1)) nextChr
	FROM ints
	) tmp
)
,
charsWithGroup(num,chr,nextChr,group_no) AS
(
	SELECT *,(SELECT COUNT(*)
		FROM chars chars2
		WHERE chars2.chr !~ '[0-9]' AND
		chars2.num < chars.num) group_No
	FROM chars
)
,
charsWithGroupAndLetter(num,chr,nextChr,group_no,group_letter) AS
(
	SELECT *,(SELECT chr
		FROM charsWithGroup g2
		where g2.group_no = charsWithGroup.group_no
		ORDER BY num DESC
		LIMIT 1)
	FROM charsWithGroup
)
,
lettersWithCount(group_no,amount,group_letter) AS
(
	SELECT group_no, string_agg(chr, '' ORDER BY num), group_letter
	FROM charsWithGroupAndLetter
	WHERE chr ~ '[0-9]'
	GROUP BY group_no, group_letter
)
,
lettersReplicated(group_no,amount,group_letter, replicated_Letter) AS
(
	SELECT *, rpad(group_letter, cast(amount as int), group_letter)
	FROM lettersWithCount
)
select (SELECT value FROM var) rle_encoded,
	string_agg(replicated_Letter, '' ORDER BY group_no) decoded_string
FROM lettersReplicated
