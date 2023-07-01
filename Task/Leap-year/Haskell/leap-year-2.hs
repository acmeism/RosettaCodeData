isleap = foldl1 ((&&).not).flip map [400, 100, 4]. ((0==).).mod
