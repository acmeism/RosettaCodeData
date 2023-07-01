USING: io locals math.vectors prettyprint ;

:: intersection-point ( rdir rpt pnorm ppt -- loc )
    rpt rdir pnorm rpt ppt v- v. v*n rdir pnorm v. v/n v- ;

"The ray intersects the plane at " write
{ 0 -1 -1 } { 0 0 10 } { 0 0 1 } { 0 0 5 } intersection-point .
