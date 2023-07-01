area=: [:| 0.5-/ .*@,.+. NB. signed area of triangle
I3=: =i.3 NB. identity matrix
inside=: {{ (area y)=+/area"1|:(I3*x)+(1-I3)*y }}
