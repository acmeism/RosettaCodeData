whack <- function(s) {
  paste( rev( unlist(strsplit(s, " "))), collapse=' ' ) }

poem <- unlist( strsplit(
'------------ Eldorado ----------

... here omitted lines ...

Mountains the "Over
Moon, the Of
Shadow, the of Valley the Down
ride," boldly Ride,
replied,--- shade The
Eldorado!" for seek you "If

Poe Edgar -----------------------', "\n"))

for (line in poem) cat( whack(line), "\n" )
