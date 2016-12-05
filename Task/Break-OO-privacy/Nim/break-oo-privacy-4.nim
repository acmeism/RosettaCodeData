import typeinfo

for key, val in fields(toAny(x)):
  echo "Key ", key
  case val.kind
  of akString:
    echo "  is a string with value: ", val.getString
  of akInt..akInt64, akUint..akUint64:
    echo "  is an integer with value: ", val.getBiggestInt
  else:
    echo "  is an unknown with value: ", val.repr
