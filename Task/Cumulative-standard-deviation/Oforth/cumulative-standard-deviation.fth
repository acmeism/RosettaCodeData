Channel new [ ] over send drop const: StdValues

: stddev(x)
| l |
   StdValues receive x + dup ->l StdValues send drop
   #qs l map sum l size asFloat / l avg sq - sqrt ;
