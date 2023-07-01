with temp as(select name,row_number() over() as rownum from african_capitals) select rownum from temp where name="Dar Es Salaam";
