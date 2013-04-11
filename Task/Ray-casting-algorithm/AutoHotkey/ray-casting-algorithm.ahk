PiP(P,N) ; P is point, N is number of sides
{
 count := 0
 Loop %N%
  If ray_intersects_segment(P,A_Index)
   count++
 if mod(count,2)
  return false ; P isn't in the polygon
 else
  return true  ; P is in the polygon
}
