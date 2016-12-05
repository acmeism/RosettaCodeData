select to_char( next_day( last_day( add_months( to_date(
        :yr||'01','yyyymm' ),level-1))-7,'Fri') ,'yyyy-mm-dd Dy') lastfriday
from dual
connect by level <= 12;
