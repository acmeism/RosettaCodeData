class vList {

   subset vEle of Any; # or Str

   class vSeg {
      has      $.next is rw is default(Nil) ;
      has vEle @.ele  is rw ;
   }

   has vSeg $.base   is rw is default(vSeg.new(ele=>()));
   has Int  $.offset is rw is default(0) ;

   method Index(Int $i is copy --> vEle) { # method to locate the kth element
      if $i ≥ 0 {
         loop ( $i += self.offset, $_ = self.base; $_.defined; $_ := $_.next) {
            ($i < my $len = .ele.elems) ?? return .ele[$i] !! $i -= $len
         }
      }
      die "index out of range"
   }

   method cons(vEle \a --> vList) { # method to add an element to the front
      if not self.base.ele.Bool {   # probably faster than .elems ?
         self.base.ele.push: a ;
         return self;
      } elsif self.offset == 0 {
         my \L2offset = (self.base.ele.elems * 2) - 1 ;
         my \s = vSeg.new(next => self.base, ele => flat Nil xx L2offset, a);
         return vList.new(base => s, offset => L2offset )
      }
      self.base.ele[--self.offset] = a;
      return self
   }

   # obtain a new array beginning at the second element of an old array
   method cdr(--> vList) {
      die "cdr on empty vList" unless self.base.defined;
      return self if ++self.offset < self.base.ele.elems;
      return vList.new(base => self.base.next)
   }

   method Length(--> Int) { # method to  compute the length of the list
      return 0 unless self.base.defined;
      return self.base.ele.elems*2 - self.offset - 1
   }

   method gist { # (mis)used to create output similar to Go/Kotlin
      return '[]' unless self.base.ele.Bool;
      my @sl = self.base.ele[self.offset .. *];
      loop ($_=self.base.next; $_.defined; $_:=$_.next) { @sl.append: .ele }
      return  "[" ~ @sl.Str ~ "]"
   }

   method printStructure {  # One more method for demonstration purposes
      say "offset: ", self.offset;
      loop ( $_ = self.base; $_.defined ; $_ := $_.next ) { .ele.say }
   }
}

my $v := vList.new;
say "zero value for type.  empty vList: ", $v;
$v.printStructure;
say " ";
$v := $v.cons($_.Str) for 6 … 1;
say "demonstrate cons. 6 elements added: ", $v;
$v.printStructure;
say " ";
$v := $v.cdr;
say "demonstrate cdr. 1 element removed: ", $v;
$v.printStructure;
say " ";
say "demonstrate length. length = ", $v.Length;
say " ";
say "demonstrate element access. v[3] = ", $v.Index(3) ;
say " ";
$v := $v.cdr.cdr;
say "show cdr releasing segment. 2 elements removed: ", $v;
$v.printStructure;
