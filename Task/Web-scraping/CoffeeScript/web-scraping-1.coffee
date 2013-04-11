http = require 'http'

CONFIG =
  host: 'tycho.usno.navy.mil'
  path: '/cgi-bin/timer.pl'

# Web scraping code tends to be brittle, and this is no exception.
# The tycho time page does not use highly structured markup, so
# we do a real dirty scrape.
scrape_tycho_ust_time = (text) ->
  for line in text.split '\n'
    matches = line.match /(.*:\d\d UTC)/
    if matches
      console.log matches[0].replace '<BR>', ''
      return
  throw Error("unscrapable page!")

# This is low-level-ish code to get data from a URL. It's
# pretty general purpose, so you'd normally tuck this away
# in a library (or use somebody else's library).
wget = (host, path, cb) ->
  options =
    host: host
    path: path
    headers:
      "Cache-Control": "max-age=0"

  req = http.request options, (res) ->
    s = ''
    res.on 'data', (chunk) ->
      s += chunk
    res.on 'end', ->
      cb s
  req.end()

# Do our web scrape
do ->
  wget CONFIG.host, CONFIG.path, (data) ->
    scrape_tycho_ust_time data
