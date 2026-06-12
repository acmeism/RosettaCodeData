def mosaicMatrix:
    [range(0;.) | . % 2] as $one
  | [range(0;.) | (. + 1) % 2] as $two
  | [range(0;.) | if .%2 == 1 then $one else $two end];
