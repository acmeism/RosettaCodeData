with Ada.Text_IO, Ada.Finalization, Ada.Unchecked_Deallocation;

procedure Main is

   generic
      type Key_Type is private;
      with function "<"(a, b : Key_Type) return Boolean is <>;
      with function "="(a, b : Key_Type) return Boolean is <>;
      with function "<="(a, b : Key_Type) return Boolean is <>;
   package AVL_Tree is
      type Tree is tagged limited private;
      function insert(self : in out Tree; key : Key_Type) return Boolean;
      procedure delete(self : in out Tree; key : Key_Type);
      procedure print_balance(self : in out Tree);

   private
      type Height_Amt is range -1 .. Integer'Last;

      -- Since only one key is inserted before each rebalance, the balance of
      -- all trees/subtrees will stay in range -2 .. 2
      type Balance_Amt is range -2 .. 2;

      type Node;
      type Node_Ptr is access Node;
      type Node is new Ada.Finalization.Limited_Controlled with record
         left, right, parent : Node_Ptr := null;
         key : Key_Type;
         balance : Balance_Amt := 0;
      end record;
      overriding procedure Finalize(self : in out Node);
      subtype Node_Parent is Ada.Finalization.Limited_Controlled;

      type Tree is new Ada.Finalization.Limited_Controlled with record
         root : Node_Ptr := null;
      end record;
      overriding procedure Finalize(self : in out Tree);

   end AVL_Tree;

   package body AVL_Tree is

      procedure Free_Node is new Ada.Unchecked_Deallocation(Node, Node_Ptr);

      overriding procedure Finalize(self : in out Node) is
      begin
         Free_Node(self.left);
         Free_Node(self.right);
      end Finalize;

      overriding procedure Finalize(self : in out Tree) is
      begin
         Free_Node(self.root);
      end Finalize;


      function height(n : Node_Ptr) return Height_Amt is
      begin
         if n = null then
            return -1;
         else
            return 1 + Height_Amt'Max(height(n.left), height(n.right));
         end if;
      end height;

      procedure set_balance(n : not null Node_Ptr) is
      begin
         n.balance := Balance_Amt(height(n.right) - height(n.left));
      end set_balance;

      procedure update_parent(parent : Node_Ptr; new_child : Node_Ptr; old_child : Node_Ptr) is
      begin
         if parent /= null then
            if parent.right = old_child then
               parent.right := new_child;
            else
               parent.left := new_child;
            end if;
         end if;
      end update_parent;

      function rotate_left(a : not null Node_Ptr) return Node_Ptr is
         b : Node_Ptr := a.right;
      begin
         b.parent := a.parent;
         a.right := b.left;
         if a.right /= null then
            a.right.parent := a;
         end if;
         b.left := a;
         a.parent := b;
         update_parent(parent => b.parent, new_child => b, old_child => a);

         set_balance(a);
         set_balance(b);
         return b;
      end rotate_left;

      function rotate_right(a : not null Node_Ptr) return Node_Ptr is
         b : Node_Ptr := a.left;
      begin
         b.parent := a.parent;
         a.left := b.right;
         if a.left /= null then
            a.left.parent := a;
         end if;
         b.right := a;
         a.parent := b;
         update_parent(parent => b.parent, new_child => b, old_child => a);

         set_balance(a);
         set_balance(b);
         return b;
      end rotate_right;

      function rotate_left_right(n : not null Node_Ptr) return Node_Ptr is
      begin
         n.left := rotate_left(n.left);
         return rotate_right(n);
      end rotate_left_right;

      function rotate_right_left(n : not null Node_Ptr) return Node_Ptr is
      begin
         n.right := rotate_right(n.right);
         return rotate_left(n);
      end rotate_right_left;

      procedure rebalance(self : in out Tree; n : not null Node_Ptr) is
         new_n : Node_Ptr := n;
      begin
         set_balance(new_n);
         if new_n.balance = -2 then
            if height(new_n.left.left) >= height(new_n.left.right) then
               new_n := rotate_right(new_n);
            else
               new_n := rotate_left_right(new_n);
            end if;
         elsif new_n.balance = 2 then
            if height(new_n.right.right) >= height(new_n.right.left) then
               new_n := rotate_left(new_n);
            else
               new_n := rotate_right_left(new_n);
            end if;
         end if;

         if new_n.parent /= null then
            rebalance(self, new_n.parent);
         else
            self.root := new_n;
         end if;
      end rebalance;

      function new_node(key : Key_Type) return Node_Ptr is
        (new Node'(Node_Parent with key => key, others => <>));

      function insert(self : in out Tree; key : Key_Type) return Boolean is
         curr, parent : Node_Ptr;
         go_left : Boolean;
      begin
         if self.root = null then
            self.root := new_node(key);
            return True;
         end if;

         curr := self.root;
         while curr.key /= key loop
            parent := curr;
            go_left := key < curr.key;
            curr := (if go_left then curr.left else curr.right);
            if curr = null then
               if go_left then
                  parent.left := new_node(key);
                  parent.left.parent := parent;
               else
                  parent.right := new_node(key);
                  parent.right.parent := parent;
               end if;
               rebalance(self, parent);
               return True;
            end if;
         end loop;
         return False;
      end insert;

      procedure delete(self : in out Tree; key : Key_Type) is
         successor, parent, child : Node_Ptr := self.root;
         to_delete : Node_Ptr := null;
      begin
         if self.root = null then
            return;
         end if;

         while child /= null loop
            parent := successor;
            successor := child;
            child := (if successor.key <= key then successor.right else successor.left);
            if successor.key = key then
               to_delete := successor;
            end if;
         end loop;

         if to_delete = null then
            return;
         end if;
         to_delete.key := successor.key;
         child := (if successor.left = null then successor.right else successor.left);
         if self.root.key = key then
            self.root := child;
         else
            update_parent(parent => parent, new_child => child, old_child => successor);
            rebalance(self, parent);
         end if;
         Free_Node(successor);
      end delete;

      procedure print_balance(n : Node_Ptr) is
      begin
         if n /= null then
            print_balance(n.left);
            Ada.Text_IO.Put(n.balance'Image);
            print_balance(n.right);
         end if;
      end print_balance;

      procedure print_balance(self : in out Tree) is
      begin
         print_balance(self.root);
      end print_balance;
   end AVL_Tree;

   package Int_AVL_Tree is new AVL_Tree(Integer);

   tree : Int_AVL_Tree.Tree;
   success : Boolean;
begin
   for i in 1 .. 10 loop
      success := tree.insert(i);
   end loop;
   Ada.Text_IO.Put("Printing balance: ");
   tree.print_balance;
   Ada.Text_IO.New_Line;
end Main;
