# like while/2 but emit the final term rather than the first one
def whilst(cond; update):
     def _whilst:
         if cond then update | (., _whilst) else empty end;
     _whilst;

input | whilst(true; . + 3 | .  * 0.86)
