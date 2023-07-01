USE rosettacode;
GO

SET NOCOUNT ON;
GO

CREATE TABLE dbo.numbers (n INT PRIMARY KEY);
GO

-- NOTE If you want to play more than 10000 games, you need to extend the query generating the numbers table by adding
-- next cross joins. Now the table contains enough values to solve the task and it takes less processing time.

WITH sample100 AS (
    SELECT TOP(100) object_id
    FROM master.sys.objects
)
INSERT numbers
    SELECT ROW_NUMBER() OVER (ORDER BY A.object_id) AS n
    FROM sample100 AS A
        CROSS JOIN sample100 AS B;
GO

CREATE TABLE dbo.drawers (drawer INT PRIMARY KEY, card INT);
GO

CREATE TABLE dbo.results (strategy VARCHAR(10), game INT, result BIT, PRIMARY KEY (game, strategy));
GO

CREATE PROCEDURE dbo.shuffleDrawers @prisonersCount INT
AS BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT * FROM drawers)
        INSERT drawers (drawer, card)
        SELECT n AS drawer, n AS card
        FROM numbers
        WHERE n <= @prisonersCount;

    DECLARE @randoms TABLE (n INT, random INT);
    DECLARE @n INT = 1;
    WHILE @n <= @prisonersCount BEGIN
        INSERT @randoms VALUES (@n, ROUND(RAND() * (@prisonersCount - 1), 0) + 1);

        SET @n = @n + 1;
    END;

    WITH ordered AS (
        SELECT ROW_NUMBER() OVER (ORDER BY random ASC) AS drawer,
            n AS card
        FROM @randoms
    )
    UPDATE drawers
    SET card = o.card
    FROM drawers AS s
        INNER JOIN ordered AS o
            ON o.drawer = s.drawer;
END
GO

CREATE PROCEDURE dbo.find @prisoner INT, @strategy VARCHAR(10)
AS BEGIN
    -- A prisoner can open no more than 50 drawers.
    DECLARE @drawersCount INT = (SELECT COUNT(*) FROM drawers);
    DECLARE @openMax INT = @drawersCount / 2;

    -- Prisoners start outside the room.
    DECLARE @card INT = NULL;
    DECLARE @open INT = 1;
    WHILE @open <= @openMax BEGIN
        -- A prisoner tries to find his own number.
        IF @strategy = 'random' BEGIN
            DECLARE @random INT = ROUND(RAND() * (@drawersCount - 1), 0) + 1;
            SET @card = (SELECT TOP(1) card FROM drawers WHERE drawer = @random);
        END
        IF @strategy = 'optimal' BEGIN
            IF @card IS NULL BEGIN
                SET @card = (SELECT TOP(1) card FROM drawers WHERE drawer = @prisoner);
            END ELSE BEGIN
                SET @card = (SELECT TOP(1) card FROM drawers WHERE drawer = @card);
            END
        END

        -- A prisoner finding his own number is then held apart from the others.
        IF @card = @prisoner
            RETURN 1;

        SET @open = @open + 1;
    END

    RETURN 0;
END
GO

CREATE PROCEDURE dbo.playGame @gamesCount INT, @strategy VARCHAR(10), @prisonersCount INT = 100
AS BEGIN
    SET NOCOUNT ON;

    IF @gamesCount <> (SELECT COUNT(*) FROM results WHERE strategy = @strategy) BEGIN
        DELETE results
        WHERE strategy = @strategy;

        INSERT results (strategy, game, result)
        SELECT @strategy AS strategy, n AS game, 0 AS result
        FROM numbers
        WHERE n <= @gamesCount;
    END

    UPDATE results
    SET result = 0
    WHERE strategy = @strategy;

    DECLARE @game INT = 1;
    WHILE @game <= @gamesCount BEGIN
        -- A room having a cupboard of 100 opaque drawers numbered 1 to 100, that cannot be seen from outside.
        -- Cards numbered 1 to 100 are placed randomly, one to a drawer, and the drawers all closed; at the start.
        EXECUTE shuffleDrawers @prisonersCount;

        -- A prisoner tries to find his own number.
        -- Prisoners start outside the room.
        -- They can decide some strategy before any enter the room.
        DECLARE @prisoner INT = 1;
        DECLARE @found INT = 0;
        WHILE @prisoner <= @prisonersCount BEGIN
            EXECUTE @found = find @prisoner, @strategy;
            IF @found = 1
                SET @prisoner = @prisoner + 1;
            ELSE
                BREAK;
        END;

        -- If all 100 findings find their own numbers then they will all be pardoned. If any don't then all sentences stand.
        IF @found = 1
            UPDATE results SET result = 1 WHERE strategy = @strategy AND game = @game;

        SET @game = @game + 1;
    END
END
GO

CREATE FUNCTION dbo.computeProbability(@strategy VARCHAR(10))
RETURNS decimal (18, 2)
AS BEGIN
    RETURN (
        SELECT (SUM(CAST(result AS INT)) * 10000 / COUNT(*)) / 100
        FROM results
        WHERE strategy = @strategy
    );
END
GO

-- Simulate several thousand instances of the game:
DECLARE @gamesCount INT = 2000;

-- ...where the prisoners randomly open drawers.
EXECUTE playGame @gamesCount, 'random';

-- ...where the prisoners use the optimal strategy mentioned in the Wikipedia article.
EXECUTE playGame @gamesCount, 'optimal';

-- Show and compare the computed probabilities of success for the two strategies.
DECLARE @log VARCHAR(max);
SET @log = CONCAT('Games count: ', @gamesCount);
RAISERROR (@log, 0, 1) WITH NOWAIT;
SET @log = CONCAT('Probability of success with "random" strategy: ', dbo.computeProbability('random'));
RAISERROR (@log, 0, 1) WITH NOWAIT;
SET @log = CONCAT('Probability of success with "optimal" strategy: ', dbo.computeProbability('optimal'));
RAISERROR (@log, 0, 1) WITH NOWAIT;
GO

DROP FUNCTION dbo.computeProbability;
DROP PROCEDURE dbo.playGame;
DROP PROCEDURE dbo.find;
DROP PROCEDURE dbo.shuffleDrawers;
DROP TABLE dbo.results;
DROP TABLE dbo.drawers;
DROP TABLE dbo.numbers;
GO
