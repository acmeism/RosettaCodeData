select extract(year from dt) as year_with_xmas_on_sunday
from   (
         select  add_months(date '2008-12-25', 12 * (level - 1)) as dt
         from    dual
         connect by level <= 2121 - 2008 + 1
       )

where  to_char(dt, 'Dy', 'nls_date_language=English') = 'Sun'
order  by 1
;
