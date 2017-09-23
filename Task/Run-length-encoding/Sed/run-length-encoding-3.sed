sed -rf encode.sed <<< "foo oops"
# 1f2o1 2o1p1s

sed -rf decode.sed <<< "1f2o1 2o1p1s"
# foo oops

(sed -rf decode.sed | sed -rf encode.sed) <<< 1000.
# 1000.
