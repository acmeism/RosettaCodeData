NB. euler rotation matrix, left hand rule
NB. x: axis (0, 1 or 2), y: angle in radians
R=: {{ ((2 1,:1 2) o.(,-)y*_1^2|x)(,&.>/~0 1 2-.x)} =i.3 }}
X=: +/ .* NB. inner product
norm=: % %:@X~

orbitalStateVectors=: {{ 'a e i Om w f'=. y
  NB.  a: semi-major axis
  NB.  e: eccentricity
  NB.  i: inclination
  NB. Om: Longitude of the ascending node
  NB.  w: argument of Periapsis (the other "omega")
  NB.  f: true anomaly (varies with time)
  L=. a*2:`]@.*1-*:e
  'c s'=. 2{.,F=. 2 R f
  ra=. L % 1+ e*c
  rp=. s*ra*ra%L
  ijk=. F X (2 R w)X(0 R i)X(2 R Om)
  position=. ra*{.ijk
  speed=. (%:(2%ra)-%a)*norm(rp,ra,0) X ijk
  position,:speed
}}
