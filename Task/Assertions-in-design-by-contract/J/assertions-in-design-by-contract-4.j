IntegralResult =: adverb define
 RESULT =. u y
 'use extended precision!' assert (<datatype RESULT) e. ;:'extended integer'
 RESULT
:
 RESULT =. x u y
 'use extended precision!' assert (<datatype RESULT) e. ;:'extended integer'
 RESULT
)

exact_factorial =: !IntegralResult

   !50
3.04141e64
   !50x
30414093201713378043612608166064768844377641568960512000000000000
   exact_factorial 50x
30414093201713378043612608166064768844377641568960512000000000000
   exact_factorial 50
|use extended precision!: assert
|   'use extended precision!'    assert(<datatype RESULT)e.;:'extended integer'
