# allow both upper and lower-case characters
def hex2integer:
  explode
  | reverse
  | map(if . > 96  then . - 87 elif . > 64 then . - 55 else . - 48 end)
  | reduce .[] as $c
      # state: [power, ans]
      ([1,0]; (.[0] * 16) as $b | [$b, .[1] + (.[0] * $c)])
  | .[1];

select(length>0) | hex2integer / pow(16;length)
