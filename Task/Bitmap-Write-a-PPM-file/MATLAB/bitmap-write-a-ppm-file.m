R=[255,0,0;255,255,0];
G=[0,255,0;255,255,0];
B=[0,0,255;0,0,0];


r = R'; r(:);
g = R'; g(:);
b = R'; b(:);
fid=fopen('p6.ppm','w');
fprintf(fid,'P6\n%i %i\n255\n',size(R));
fwrite(fid,[r,g,b]','uint8');
fclose(fid);
