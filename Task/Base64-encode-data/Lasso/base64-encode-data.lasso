local(
  src = curl('http://rosettacode.org/favicon.ico'),
  srcdata = #src->result
)
#srcdata->encodebase64

// or, in one movement:
curl('http://rosettacode.org/favicon.ico')->result->encodebase64
