USING: dns io kernel sequences ;

"www.kame.net" [ dns-A-query ] [ dns-AAAA-query ] bi
[ message>names second print ] bi@
