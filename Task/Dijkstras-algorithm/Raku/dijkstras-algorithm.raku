class Graph {
  has (%.edges, %.nodes);

  method new(*@args){
    my (%edges, %nodes);
    for @args {
      %edges{.[0] ~ .[1]} = $_;
      %nodes{.[0]}.push( .[0] ~ .[1] );
      %nodes{.[1]}.push( .[0] ~ .[1] );
    }
    self.bless(edges => %edges, nodes => %nodes);
  }

  method neighbours ($source) {
    my (%neighbours, $edges);
    $edges = self.nodes{$source};
    for @$edges -> $x {
      for self.edges{$x}[0..1] -> $y {
        if $y ne $source {
          %neighbours{$y} = self.edges{$x}
        }
      }
    }
    return %neighbours
  }

  method dijkstra ($source, $dest) {
    my (%node_data, $v, $u);
    my @q = self.nodes.keys;

    for self.nodes.keys {
      %node_data{$_}{'dist'} = Inf;
      %node_data{$_}{'prev'} = '';
    }
    %node_data{$source}{'dist'} = 0;

    while @q {
      # %node_data.perl.say;
      my ($mindist, $idx) =
        @((map {[%node_data{@q[$_]}{'dist'},$_]},^@q).min(*[0]));
      $u = @q[$idx];

      if $mindist eq Inf {
        return ()
      }
      elsif $u eq $dest {
        my @s;
        while %node_data{$u}{'prev'} {
          @s.unshift($u);
          $u = %node_data{$u}{'prev'}
        }
        @s.unshift($source);
        return @s;
      }
      else {
        @q.splice($idx,1);
      }

      for self.neighbours($u).kv -> $v, $edge {
        my $alt = %node_data{$u}{'dist'} + $edge[2];
        if $alt < %node_data{$v}{'dist'} {
          %node_data{$v}{'dist'} = $alt;
          %node_data{$v}{'prev'} = $u
        }
      }
    }
  }
}

my $a = Graph.new([
  ["a", "b",  7],
  ["a", "c",  9],
  ["a", "f", 14],
  ["b", "c", 10],
  ["b", "d", 15],
  ["c", "d", 11],
  ["c", "f",  2],
  ["d", "e",  6],
  ["e", "f",  9]
]).dijkstra('a', 'e').say;
