# 20200609 Raku programming solution

subset vEle of Any;

class Node {
   has vEle $.value  is rw is default(Nil) ;
   has Node $.parent is rw ;
   has Node $.child  is rw ;
   has Node $.prev   is rw ;
   has Node $.next   is rw ;
   has Int  $.rank   is rw is default(0) ;
   has Bool $.mark   is rw is default(False) ;
}

multi infix:<⪡>(vEle \a, vEle \b) { a le b } # custom defined 'less than'

class Heap {

   has Node $.root is rw ;

   method MakeHeap { self.root = Node.new }

   method Insert(vEle \v) {
      my $x = Node.new: value => v;
      if self.root.value ~~ Nil {
         $x.next = $x;
         $x.prev = $x;
         self.root = $x
      } else {
         meld1(self.root, $x);
         self.root = $x if $x.value ⪡ self.root.value
      }
      return $x
   }

   method Union(Heap $h2) {
      if not self.root.defined {
         self.root = $h2.root
      } elsif $h2.root.defined { 		
         meld2(self.root, $h2.root);
         self.root = $h2.root if $h2.root.value ⪡ self.root.value
      }
      $h2.root = Nil;
   }

   method Minimum() {
      return unless self.root.defined;
      return self.root.value
   }

   method ExtractMin() {
      return Nil unless self.root.defined;
      my \min = self.root.value;
      my %roots;

      sub add (Node \r) {
         r.prev = r;
         r.next = r;
         loop {
            (defined my \x = %roots{r.rank}) or last;
            %roots{r.rank}:delete;
            (r, x) = (x, r) if x.value ⪡ r.value ;
            x.parent = r ;
            x.mark = False ;
            if not r.child.defined {
               x.next = x;
               x.prev = x;
               r.child = x
            } else {
               meld1(r.child, x)
            }
            r.rank++
         }
         %roots{r.rank} = r ;
      }

      loop (my \r = self.root.next ; not r ~~ self.root ; ) {
         my $n = r.next;
         add(r);
         r = $n ;
      }
      if defined (my \c = self.root.child ) {
         c.parent = Nil;
         r = c.next;
         add(c);
         while not r ~~ c {
            my $n = r.next;
            r.parent = Nil;
            add(r);
            r = $n;
         }
      }

      unless %roots.defined {
         self.root = Nil;
         return min
      }
      my Node $mv = %roots{my $d = %roots.keys.first};
      %roots{$d}:delete;
      $mv.next = $mv;
      $mv.prev = $mv;
      %roots.values.map: {
         $_.prev = $mv;
         $_.next = $mv.next;
         $mv.next.prev = $_;
         $mv.next = $_;
         $mv = $_ if $_.value ⪡ $mv.value
      }
      self.root = $mv;
      return min
   }


   method DecreaseKey(\n, \v) {
      die "DecreaseKey new value greater than existing value" if n.value ⪡ v;
      n.value = v;
      return Nil if n ~~ self.root;
      my \p = n.parent;
      unless p.defined {
         self.root = n if v ⪡ self.root.value;
         return Nil
      }
      self.cutAndMeld(n);
      return Nil
   }

   method cutAndMeld(\x) {
      self.cut(x);
      x.parent = Nil;
      meld1(self.root, x)
   }

   method cut(\x) {
      my \p = x.parent;
      return Nil unless p.defined;
      p.rank--;
      if p.rank == 0 {
         p.child = Nil
      } else {
         p.child = x.next;
         x.prev.next = x.next;
         x.next.prev = x.prev
      }
      return Nil unless p.parent.defined;
      unless p.mark {
        p.mark = True;
        return Nil
      }
      self.cutAndMeld(p)
   }

   method Delete(\n) {
      my \p = n.parent;
      if not p.defined {
         self.ExtractMin() and return if n ~~ self.root ;
         n.prev.next = n.next;
         n.next.prev = n.prev
      } else {
         self.cut(n)
      }
      my \c = n.child;
      return Nil unless c.defined;
      loop ( c.parent = Nil, c = c.next ; c ~~ n.child ; c = c.next ) {}
      meld2(self.root, c)
   }

   method Vis() {

      if self.root.value ~~ Nil { say "<empty>" and return }

      sub f(Node $n, Str $pre) {
         loop ( my $pc = "│ ", my $x = $n ; ; $x = $x.next) {
            if !($x.next ~~ $n) {
               print $pre, "├─"
            } else {
               print $pre, "└─";
               $pc = "  "
            }
            if not $x.child.defined {
               say "╴", $x.value
            } else {
               say "┐", $x.value;
               f($x.child, $pre~$pc)
            }
            last if $x.next ~~ $n
         }
      }
      f(self.root, "")
   }
}

sub meld1(\list, \single) {
   list.prev.next = single;
   single.prev = list.prev;
   single.next = list;
   list.prev = single;
}

sub meld2(\a, \b) {
   a.prev.next = b;
   b.prev.next = a;
   ( a.prev, b.prev ) = ( b.prev, a.prev )
}

say "MakeHeap:";
my $h = Heap.new;
$h.MakeHeap;
$h.Vis;

say "\nInsert:";
$h.Insert("cat");
$h.Vis;

say "\nUnion:";
my $h2 = Heap.new;
$h2.MakeHeap;
$h2.Insert("rat");
$h.Union($h2);
$h.Vis;

say "\nMinimum:";
my \m = $h.Minimum();
say m;

say "\nExtractMin:";
$h.Insert("bat");
my $x = $h.Insert("meerkat");
say "extracted: ", my $mm = $h.ExtractMin();
$h.Vis;

say "\nDecreaseKey:";
$h.DecreaseKey($x, "gnat");
$h.Vis;

say "\nDelete:";
$h.Insert("bobcat");
$h.Insert("bat");
say "deleting: ", $x.value;
$h.Delete($x);
$h.Vis;
