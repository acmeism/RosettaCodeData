  u = [0:360]*pi/180;
  while(1)
     s = mod(now*60*24,1)*2*pi;
     plot([0,sin(s)],[0,cos(s)],'-',sin(u),cos(u),'k-');
     pause(1);
  end;
