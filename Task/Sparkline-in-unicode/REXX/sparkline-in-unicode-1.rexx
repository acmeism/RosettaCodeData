/* Rexx */

parse arg aaa
call runSample aaa
return

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sparkline:
  procedure
  parse arg spark
  spark = changestr(',', spark, ' ')
  bars = '▁ ▂ ▃ ▄ ▅ ▆ ▇ █'
  barK = words(bars)
  nmin = word(spark, 1)
  nmax = nmin
  -- get min & max values
  do iw = 1 to words(spark)
    nval = word(spark, iw)
    nmin = min(nval, nmin)
    nmax = max(nval, nmax)
    end iw
  range = nmax - nmin + 1
  slope = ''
  do iw = 1 to words(spark)
    point = ceiling((word(spark, iw) - nmin + 1) / range * barK)
    slope = slope || word(bars, point)
    end iw
  return slope nmin nmax range

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ceiling:
procedure
  parse arg ceil
  return trunc(ceil) + (ceil > 0) * (ceil \= trunc(ceil))
floor:
procedure
  parse arg flor
  return trunc(flor) - (flor < 0) * (flor \= trunc(flor))

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
runSample:
procedure
  -- sample data setup
  parse arg vals
  sparks = 0
  sparks.0 = 0
  if vals = '' then do
    si = sparks.0 + 1; sparks.0 = si; sparks.si = 1 2 3 4 5 6 7 8 7 6 5 4 3 2 1
    si = sparks.0 + 1; sparks.0 = si; sparks.si = '1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5'
    end
  else do
    do until vals = ''
      -- split input on a ! character
      parse var vals lst '!' vals
      si = sparks.0 + 1; sparks.0 = si; sparks.si = lst
      end
    end
  -- run the samples
  do si = 1 to sparks.0
    vals = sparks.si
    parse value sparkline(vals) with slope .
    say 'Input:        ' vals
    say 'Sparkline:    ' slope
    say
    end si

  return
