babel> ("Here" "are" "some" "sample" "strings" "to" "be" "sorted") {str2ar} over ! {strcmp 0 lt?} lssort ! {ar2str} over ! lsstr !
( "Here" "are" "be" "some" "sample" "sorted" "strings" "to" )
babel>  ("Here" "are" "some" "sample" "strings" "to" "be" "sorted") {str2ar} over ! {arcmp 0 lt?} lssort ! {ar2str} over ! lsstr !
( "be" "to" "are" "Here" "some" "sample" "sorted" "strings" )
