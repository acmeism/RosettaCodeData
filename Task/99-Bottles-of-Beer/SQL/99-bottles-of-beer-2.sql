DELIMITER $$
DROP PROCEDURE IF EXISTS bottles_$$
CREATE pROCEDURE `bottles_`(inout bottle_count int, inout song  text)
BEGIN
declare bottles_text varchar(30);


IF bottle_count > 0   THEN


    if bottle_count != 1 then
    set bottles_text :=  ' bottles of beer ';
    else set bottles_text = ' bottle of beer ';
    end if;

    SELECT concat(song, bottle_count, bottles_text, ' \n') INTO song;
    SELECT concat(song, bottle_count, bottles_text,  'on the wall\n') INTO song;
    SELECT concat(song, 'Take one down, pass it around\n') into song;
    SELECT concat(song, bottle_count -1 , bottles_text,  'on the wall\n\n') INTO song;
    set bottle_count := bottle_count -1;
    CALL bottles_( bottle_count, song);
  END IF;
END$$

set @bottles=99;
set max_sp_recursion_depth=@bottles;
set @song='';
call bottles_( @bottles, @song);
select @song;
