$max_pixel_value=255;
$top=0; $bottom=479;
$left=0; $right=639;

# Populate pixels with simple sine-derived pattern
for $y ($top .. $bottom) {
  for $x ($left .. $right) {
    $pixel[$x][$y]=$max_pixel_value*(0.5+0.5*sin($x/100+$y/300)*sin($y/100));
  }
}

# Find closest palette color
sub find_closest_palette_color() {
  return int(shift(@_)/$max_pixel_value)+0.5)*$max_pixel_value
}

# dither!
for $y ($top .. $bottom) {
  for $x ($left .. $right) {
    my $oldpixel=$pixel[$x][$y];
    my $newpixel=find_closest_palette_color($oldpixel);
    $pixel[$x][$y]=newpixel;
    $quant_error=$oldpixel-$newpixel;
    $pixel[$x+1][$y+0]=$pixel[$x+1][$y+0]+$quant_error*7/16;
    $pixel[$x-1][$y+1]=$pixel[$x-1][$y+1]+$quant_error*3/16;
    $pixel[$x+0][$y+1]=$pixel[$x+0][$y+1]+$quant_error*5/16;
    $pixel[$x+1][$y+1]=$pixel[$x+1][$y+1]+$quant_error*1/16;
  }
}
