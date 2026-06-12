# 20250901 Raku programming solution

class Point { has Int ( $.x, $.y );
   method rotate90  { Point.new(x =>  self.y, y => -self.x) }
   method rotate180 { Point.new(x => -self.x, y => -self.y) }
   method rotate270 { Point.new(x => -self.y, y =>  self.x) }
   method reflect   { Point.new(x => -self.x, y =>  self.y) }
}

sub normalize-points(@cells --> Array[Point]) {
   my $minx   = @cells.map(*.x).min;
   my $miny   = @cells.map(*.y).min;
   my @sorted = @cells.map({ Point.new(x => .x - $minx, y => .y - $miny) })
                   .sort({ $^a.y <=> $^b.y || $^a.x <=> $^b.x });
   return Array[Point].new: @sorted
}

sub points-to-key(@points --> Str) { @points.map({ "{.x},{.y}" }).join(';') }

sub key-to-points(Str $key --> Array[Point]) {
   return Array[Point].new: gather for $key.split(';') {
      given .split(',') { take Point.new: x => +.[0], y => +.[1] }
   }
}

sub transforms(@cells --> Seq) {
   return gather {
      my @p = @cells;
      take @p;                       # identity
      take @p .= map(*.rotate90);    # 90 deg
      take @p .= map(*.rotate90);    # 180 deg
      take @p .= map(*.rotate90);    # 270 deg
      @p = @cells.map(*.reflect);
      take @p;                       # reflection
      take @p .= map(*.rotate90);    # reflect + 90
      take @p .= map(*.rotate90);    # reflect + 180
      take @p .= map(*.rotate90);    # reflect + 270
   }
}

sub canonical(@cells --> Str) {
   state %canon-cache;
   my $initial-key = points-to-key(normalize-points(@cells));
   return %canon-cache{$initial-key} if %canon-cache{$initial-key}:exists;

   my $best = transforms(@cells).map({points-to-key(normalize-points($_))}).max;
   return %canon-cache{$initial-key} = $best;
}

sub neighbors(@cells --> SetHash) {
   my SetHash $in .= new: @cells.map: { "{.x},{.y}" };
   state @dirs = ( [1,0], [-1,0], [0,1], [0,-1] );
   my SetHash $nbrs .= new;
   for @cells X @dirs -> ($c,@d) {
      my $key = "{$c.x + @d[0]},{$c.y + @d[1]}";
      $nbrs{$key} = True unless $in{$key}:exists;
   }
   return $nbrs
}

sub grow-one(Str $canon-key --> SetHash) {
   my @cells = key-to-points($canon-key);
   my SetHash $out .= new;
   for neighbors(@cells).keys -> $kk {
      my ($nx, $ny) = $kk.split(',');
      my @new = |@cells, Point.new: x => +$nx, y => +$ny;
      $out{ canonical(@new) } = True;
   }
   return $out
}

sub parse-canonical-for-render(Str $canon --> Array) {
   $canon.split(';').map({ [ .split(',')>>.Int ] }).Array
}

sub render(Str $canon --> Str) {
   my @cells = parse-canonical-for-render($canon);
   my $maxx  = @cells.map(*[0]).max // 0;
   my $maxy  = @cells.map(*[1]).max // 0;
   my @rows  = ' ' x ($maxx + 1) xx ($maxy + 1);
   for @cells -> @c { @rows[@c[1]].substr-rw(@c[0], 1) = '#' }
   while ([&&] @rows.map({ .starts-with(' ') })) { @rows .= map({.substr(1)}) }
   while ([&&] @rows.map({   .ends-with(' ') })) { @rows .= map({ .chop })    }
   return @rows.join("\n")
}

sub (Int $n) {
   my @levels = [ my $level = { '0,0' => True }.SetHash ];

   for 2..$n -> $size {
      my SetHash $next .= new;
      for $level.keys -> $canon-key {
         for grow-one($canon-key).keys -> $child { $next{$child} = True }
      }
      @levels.push($level = $next);
   }

   for 2..$n -> $i {
      my $L = @levels[$i-1];
      printf "rank: %2d  count: %d\n\n", $i, $L.elems;
      if $L.elems <= 12 {
         my @keys   = $L.keys.sort;
         my @grids  = @keys.map(&render);
         my @widths = @grids.map({given .lines { $_ ?? $_[0].chars + 1 !! 1 }});
         my $fmt    = @widths.map({ "%{$_}s" }).join('') ~ "\n";
         my $max_h  = @grids.map({ .lines.elems }).max;
         for ^$max_h -> $row {
            print "  ";
            printf $fmt, @grids.map({ .lines[$row] // '' });
         }
         print "\n\n";
      }
   }
}(10)
