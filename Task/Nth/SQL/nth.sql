select level card,
        to_char(to_date(level,'j'),'fmjth') ord
from dual
connect by level <= 15;

select to_char(to_date(5373485,'j'),'fmjth')
from dual;
