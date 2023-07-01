$$ MODE TUSCRIPT
tablefile="table.html"
ERROR/STOP CREATE (tablefile,FDF-o,-std-)
ACCESS d: WRITE/ERASE/RECORDS/utf8 $tablefile s,tablecontent
tablecontent=*
WRITE d "<!DOCTYPE html system>"
WRITE d "<html><head><title>create html table</title></head>"
WRITE d "<body><table><thead align='right'>"
WRITE d "<tr><th>&nbsp;</th><th>x</th><th>y</th><th>z</th></tr>"
WRITE d "</thead>"
WRITE d "<tbody align='right'>"
LOOP n=1,5
x=RANDOM_NUMBERS (1,9999,1)
y=RANDOM_NUMBERS (1,9999,1)
z=RANDOM_NUMBERS (1,9999,1)
WRITE d "<tr><td>{n}</td><td>{x}</td><td>{y}</td><td>{z}</td></tr>"
ENDLOOP
WRITE d "</tbody></table></body></html>"
ENDACCESS d
BROWSE $tablefile
