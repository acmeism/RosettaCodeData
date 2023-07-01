import algorithm, sequtils, strutils

type OID = distinct string

# Borrow the `$` procedure from the base string type.
proc `$`(oid: OID): string {.borrow.}


template toSeqInt(oid: OID): seq[int] =
  ## Convert an OID into a sequence of integers.
  oid.string.split('.').map(parseInt)


proc oidCmp(a, b: OID): int =
  ## Compare two OIDs. Return 0 if OIDs are equal, -1 if the first is
  ## less than the second, +1 is the first is greater than the second.
  let aseq = a.toSeqInt
  let bseq = b.toSeqInt
  for i in 0..<min(aseq.len, bseq.len):
    result = cmp(aseq[i], bseq[i])
    if result != 0: return
  result = cmp(aseq.len, bseq.len)


when isMainModule:

  const OIDS = [OID"1.3.6.1.4.1.11.2.17.19.3.4.0.10",
                OID"1.3.6.1.4.1.11.2.17.5.2.0.79",
                OID"1.3.6.1.4.1.11.2.17.19.3.4.0.4",
                OID"1.3.6.1.4.1.11150.3.4.0.1",
                OID"1.3.6.1.4.1.11.2.17.19.3.4.0.1",
                OID"1.3.6.1.4.1.11150.3.4.0"]

  for oid in OIDS.sorted(oidCmp):
    echo oid
