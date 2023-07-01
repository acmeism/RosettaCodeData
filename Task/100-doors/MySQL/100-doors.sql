DROP PROCEDURE IF EXISTS one_hundred_doors;

DELIMITER |

CREATE PROCEDURE one_hundred_doors (n INT)
BEGIN
  DROP TEMPORARY TABLE IF EXISTS doors;
  CREATE TEMPORARY TABLE doors (
    id INTEGER NOT NULL,
    open BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (id)
  );

  SET @i = 1;
  create_doors: LOOP
    INSERT INTO doors (id, open) values (@i, FALSE);
    SET @i = @i + 1;
    IF @i > n THEN
      LEAVE create_doors;
    END IF;
  END LOOP create_doors;

  SET @i = 1;
  toggle_doors: LOOP
    UPDATE doors SET open = NOT open WHERE MOD(id, @i) = 0;
    SET @i = @i + 1;
    IF @i > n THEN
      LEAVE toggle_doors;
    END IF;
  END LOOP toggle_doors;

  SELECT id FROM doors WHERE open;
END|

DELIMITER ;

CALL one_hundred_doors(100);
