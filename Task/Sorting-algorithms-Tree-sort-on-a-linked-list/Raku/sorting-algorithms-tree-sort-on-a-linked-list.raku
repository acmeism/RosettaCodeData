# 20231201 Raku programming solution

class BinaryTree { has ($.node, $.leftSubTree, $.rightSubTree) is rw;

   method insert($item) {
      if not $.node.defined {
         $.node = $item;
         ($.leftSubTree, $.rightSubTree)>>.&{ $_ = BinaryTree.new }
      } elsif $item cmp $.node < 0 {
         $.leftSubTree.insert($item);
      } else {
         $.rightSubTree.insert($item);
      }
   }

   method inOrder(@ll) {
      return unless $.node.defined;
      $.leftSubTree.inOrder(@ll);
      @ll.push($.node);
      $.rightSubTree.inOrder(@ll);
   }
}

sub treeSort(@ll) {
   my $searchTree = BinaryTree.new;
   for @ll -> $i { $searchTree.insert($i) }
   $searchTree.inOrder(my @ll2);
   return @ll2
}

sub printLinkedList(@ll, Str $fmt, Bool $sorted) {
   for @ll -> $i { printf "$fmt ", $i }
   $sorted ?? say() !! print "-> "
}

my @ll  = <5 3 7 9 1>;
#my @ll = [37, 88, 13, 18, 72, 77, 29, 93, 21, 97, 37, 42, 67, 22, 29, 2];
printLinkedList(@ll, "%d", False);
my @lls = treeSort(@ll);
printLinkedList(@lls, "%d", True);

my @ll2 = <d c e b a>;
#my @ll2 = <one two three four five six seven eight nine ten>;
printLinkedList(@ll2, "%s", False);
my @lls2 = treeSort(@ll2);
printLinkedList(@lls2, "%s", True);
