DV:{p[x]-p[y]};DS:{sqrt[+/sq'DV[x;y]]}            / nth body position vector and magnitude
A1:{$[x=y;0;g*m[y]*DV[x;y]%pow[DS[x;y];3]]}       / nth body centripetal acceleration component
A:{+/{A1/:[x;!n]}'!n}                             / total centripetal acceleration
tmax::2*pi*rot%vs                                 / duration of simulation
N:{[dt]                                           / increment
  v0:v;v+::dt*A[];p+::dt*0.5*v+v0                 / update velocities and positions
  t+::dt;$[t>tmax;do[msg::,"[";tick::{}];0]       / update time, detect end of time
}
