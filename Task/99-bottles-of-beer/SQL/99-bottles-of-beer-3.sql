CREATE PROCEDURE bottles
	@bottle_count int,
	@song varchar(MAX)

AS
BEGIN

declare @bottles_text VARCHAR(MAX);


IF @bottle_count > 0
 BEGIN
    IF @bottle_count != 1
		BEGIN
		SET @bottles_text =  ' bottles of beer ';
    END
    ELSE
    BEGIN
		SET @bottles_text = ' bottle of beer ';
	END



    SET @song = @song + CAST(@bottle_count AS VARCHAR) + @bottles_text + '\n';

    SET @song = @song + CAST(@bottle_count AS VARCHAR) + @bottles_text +  'on the wall\n'
    SET @song = @song + 'Take one down, pass it around\n'
    SET @song = @song + CAST((@bottle_count - 1) AS VARCHAR) + @bottles_text +  'on the wall\n'


    SET @bottle_count = (@bottle_count - 1);




   EXEC bottles @bottle_count, @song

END
ELSE
	    select @song AS 'RESULT'
END

/*****
AND IN ORDER TO CALL PROCEDURE:
****/
EXECUTE bottles  31, '';
