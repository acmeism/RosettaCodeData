SET NOCOUNT ON;

-- Doors can be open or closed.
DECLARE @open CHAR(1) = 'O';
DECLARE @closed CHAR(1) = 'C';

-- There are 100 doors in a row that are all initially closed.
DECLARE @doorsCount INT = 100;
DECLARE @doors TABLE (doorKey INT PRIMARY KEY, doorState CHAR(1));
WITH sample100 AS (
    SELECT TOP(100) object_id
    FROM sys.objects
)
INSERT @doors
  SELECT ROW_NUMBER() OVER (ORDER BY A.object_id) AS doorKey,
    @closed AS doorState
  FROM sample100 AS A
      CROSS JOIN sample100 AS B
      CROSS JOIN sample100 AS C
      CROSS JOIN sample100 AS D
  ORDER BY 1
  OFFSET 0 ROWS
  FETCH NEXT @doorsCount ROWS ONLY;

-- You make 100 passes by the doors, visiting every door and toggle the door (if
-- the door is closed, open it; if it is open, close it), according to the rules
-- of the task.
DECLARE @pass INT = 1;
WHILE @pass <= @doorsCount BEGIN
  UPDATE @doors
  SET doorState = CASE doorState WHEN @open THEN @closed ELSE @open END
  WHERE doorKey >= @pass
    AND doorKey % @pass = 0;

  SET @pass = @pass + 1;
END;

-- Answer the question: what state are the doors in after the last pass?
-- The answer as the query result is:
SELECT doorKey, doorState FROM @doors;
-- The answer as the console output is:
DECLARE @log VARCHAR(max);
DECLARE @doorKey INT = (SELECT MIN(doorKey) FROM @doors);
WHILE @doorKey <= @doorsCount BEGIN
  SET @log = (
      SELECT TOP(1) CONCAT('Doors ', doorKey, ' are ',
        CASE doorState WHEN @open THEN ' open' ELSE 'closed' END, '.')
      FROM @doors
      WHERE doorKey = @doorKey
    );
  RAISERROR (@log, 0, 1) WITH NOWAIT;

  SET @doorKey = (SELECT MIN(doorKey) FROM @doors WHERE doorKey > @doorKey);
END;

-- Which are open, which are closed?
-- The answer as the query result is:
SELECT doorKey, doorState FROM @doors WHERE doorState = @open;
SELECT doorKey, doorState FROM @doors WHERE doorState = @closed;
-- The answer as the console output is:
SET @log = (
  SELECT CONCAT('These are open doors: ',
    STRING_AGG(CAST(doorKey AS VARCHAR(max)), ', '), '.')
  FROM @doors
  WHERE doorState = @open
);
RAISERROR (@log, 0, 1) WITH NOWAIT;
SET @log = (
  SELECT CONCAT('These are closed doors: ',
    STRING_AGG(CAST(doorKey AS VARCHAR(max)), ', '), '.')
  FROM @doors
  WHERE doorState = @closed
);
RAISERROR (@log, 0, 1) WITH NOWAIT;

-- Assert:
DECLARE @expected TABLE (doorKey INT PRIMARY KEY);
SET @doorKey = 1;
WHILE @doorKey * @doorKey <= @doorsCount BEGIN
  INSERT @expected VALUES (@doorKey * @doorKey);
  SET @doorKey = @doorKey + 1;
END;
IF NOT EXISTS (
    SELECT doorKey FROM @doors WHERE doorState = @open
    EXCEPT
    SELECT doorKey FROM @expected
  )
  AND NOT EXISTS (
    SELECT doorKey FROM @expected
    EXCEPT
    SELECT doorKey FROM @doors WHERE doorState = @open
  )
  PRINT 'The task is solved.';
ELSE
  THROW 50000, 'These aren''t the doors you''re looking for.', 1;
