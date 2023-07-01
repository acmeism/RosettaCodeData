-- Table to contain all the data points
CREATE TABLE points (
  c_re DOUBLE,
  c_im DOUBLE,
  z_re DOUBLE DEFAULT 0,
  z_im DOUBLE DEFAULT 0,
  znew_re DOUBLE DEFAULT 0,
  znew_im DOUBLE DEFAULT 0,
  steps INT DEFAULT 0,
  active CHAR DEFAULT 1
);

DELIMITER |

-- Iterate over all the points in the table 'points'
CREATE PROCEDURE itrt (IN n INT)
BEGIN
  label: LOOP
    UPDATE points
      SET
        znew_re=POWER(z_re,2)-POWER(z_im,2)+c_re,
        znew_im=2*z_re*z_im+c_im,
        steps=steps+1
      WHERE active=1;
    UPDATE points SET
        z_re=znew_re,
        z_im=znew_im,
        active=IF(POWER(z_re,2)+POWER(z_im,2)>4,0,1)
      WHERE active=1;
    SET n = n - 1;
    IF n > 0 THEN
      ITERATE label;
    END IF;
    LEAVE label;
  END LOOP label;
END|

-- Populate the table 'points'
CREATE PROCEDURE populate (
  r_min DOUBLE,
  r_max DOUBLE,
  r_step DOUBLE,
  i_min DOUBLE,
  i_max DOUBLE,
  i_step DOUBLE)
BEGIN
  DELETE FROM points;
  SET @rl = r_min;
  SET @a = 0;
  rloop: LOOP
    SET @im = i_min;
    SET @b = 0;
    iloop: LOOP
      INSERT INTO points (c_re, c_im)
        VALUES (@rl, @im);
      SET @b=@b+1;
      SET @im=i_min + @b * i_step;
      IF @im < i_max THEN
        ITERATE iloop;
      END IF;
      LEAVE iloop;
    END LOOP iloop;
      SET @a=@a+1;
    SET @rl=r_min + @a * r_step;
    IF @rl < r_max THEN
      ITERATE rloop;
    END IF;
    LEAVE rloop;
  END LOOP rloop;
END|

DELIMITER ;

-- Choose size and resolution of graph
--             R_min, R_max, R_step, I_min, I_max, I_step
CALL populate( -2.5,  1.5,   0.005,  -2,    2,     0.005 );

-- Calculate 50 iterations
CALL itrt( 50 );

-- Create the image (/tmp/image.ppm)
-- Note, MySQL will not over-write an existing file and you may need
-- administrator access to delete or move it
SELECT @xmax:=COUNT(c_re) INTO @xmax FROM points GROUP BY c_im LIMIT 1;
SELECT @ymax:=COUNT(c_im) INTO @ymax FROM points GROUP BY c_re LIMIT 1;
SET group_concat_max_len=11*@xmax*@ymax;
SELECT
  'P3', @xmax, @ymax, 200,
  GROUP_CONCAT(
    CONCAT(
      IF( active=1, 0, 55+MOD(steps, 200) ), ' ',
      IF( active=1, 0, 55+MOD(POWER(steps,3), 200) ), ' ',
      IF( active=1, 0, 55+MOD(POWER(steps,2), 200) ) )
    ORDER BY c_im ASC, c_re ASC SEPARATOR ' ' )
    INTO OUTFILE '/tmp/image.ppm'
  FROM points;
