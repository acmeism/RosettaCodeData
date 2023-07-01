CREATE FUNCTION gcd (
  @ui INT,
  @vi INT
) RETURNS INT

AS

BEGIN
    DECLARE @t INT
    DECLARE @u INT
    DECLARE @v INT
	
    SET @u = @ui
    SET @v = @vi

    WHILE @v > 0
    BEGIN
        SET @t = @u;
        SET @u = @v;
        SET @v = @t % @v;
    END;
    RETURN abs( @u );
END

GO

CREATE TABLE tbl (
  u INT,
  v INT
);

INSERT INTO tbl ( u, v ) VALUES ( 20, 50 );
INSERT INTO tbl ( u, v ) VALUES ( 21, 50 );
INSERT INTO tbl ( u, v ) VALUES ( 21, 51 );
INSERT INTO tbl ( u, v ) VALUES ( 22, 50 );
INSERT INTO tbl ( u, v ) VALUES ( 22, 55 );

SELECT u, v, dbo.gcd ( u, v )
  FROM tbl;

DROP TABLE tbl;

DROP FUNCTION gcd;
