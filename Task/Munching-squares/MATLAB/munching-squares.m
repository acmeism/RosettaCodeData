size = 256;
[x,y] = meshgrid([0:size-1]);

c = bitxor(x,y);

colormap bone(size);
image(c);
axis equal;
