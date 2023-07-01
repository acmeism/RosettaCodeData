( scratchpad ) CONSTANT: trits { t m f }
( scratchpad ) trits [ tnot ] map .
{ f m t }
( scratchpad ) trits [ trits swap [ tand ] curry map ] map .
{ { t m f } { m m f } { f f f } }
( scratchpad ) trits [ trits swap [ tor ] curry map ] map .
{ { t t t } { t m m } { t m f } }
( scratchpad ) trits [ trits swap [ txor ] curry map ] map .
{ { f m t } { m m m } { t m f } }
( scratchpad ) trits [ trits swap [ t= ] curry map ] map .
{ { t m f } { m m m } { f m t } }
