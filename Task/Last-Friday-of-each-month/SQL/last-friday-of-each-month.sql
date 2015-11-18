select
to_char( max( trunc( to_date ( :yr, 'yyyy' ), 'yyyy' ) + level - 1 ),
'yyyy-mm-dd Dy' ) lastfriday
from dual
where
to_char ( trunc( to_date ( :yr, 'yyyy' ), 'yyyy' ) + level - 1, 'Dy' ) = 'Fri'
connect by level < trunc( to_date ( :yr + 1 , 'yyyy' ), 'yyyy')
- trunc( to_date ( :yr, 'yyyy' ) ,'yyyy' ) + 1
group by
to_char(  trunc( to_date ( :yr, 'yyyy' ), 'yyyy' ) + level - 1, 'yyyymm' )
order by 1
