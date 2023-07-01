import algorithm, sequtils, strutils

type OID = object
  value: string
  list: seq[int]

proc initOID(s: string): OID =
  OID(value: s, list: s.split('.').map(parseInt))

proc `$`(oid: OID): string =
  oid.value

proc oidCmp(a, b: OID): int =
  ## Compare two OIDs. Return 0 if OIDs are equal, -1 if the first is
  ## less than the second, +1 is the first is greater than the second.
  for i in 0..<min(a.list.len, b.list.len):
    result = cmp(a.list[i], b.list[i])
    if result != 0: return
  result = cmp(a.list.len, b.list.len)


when isMainModule:

  const OIDS = [initOID("1.3.6.1.4.1.11.2.17.19.3.4.0.10"),
                initOID("1.3.6.1.4.1.11.2.17.5.2.0.79"),
                initOID("1.3.6.1.4.1.11.2.17.19.3.4.0.4"),
                initOID("1.3.6.1.4.1.11150.3.4.0.1"),
                initOID("1.3.6.1.4.1.11.2.17.19.3.4.0.1"),
                initOID("1.3.6.1.4.1.11150.3.4.0")]

  for oid in OIDS.sorted(oidCmp):
    echo oid
