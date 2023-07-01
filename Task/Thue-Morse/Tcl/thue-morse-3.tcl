package require sqlite3 ;# available with Tcl8.5+ core
sqlite3 db ""           ;# create in-memory database
set LIMIT 6
db eval {with recursive a(a) as (select '0' union all select replace(replace(hex(a),'30','01'),'31','10') from a) select a from a limit $LIMIT} {
    puts $a
}
