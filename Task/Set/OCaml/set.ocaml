# module IntSet = Set.Make(struct type t = int let compare = compare end);; (* Create a module for our type of set *)
module IntSet :
  sig
    type elt = int
    type t
    val empty : t
    val is_empty : t -> bool
    val mem : elt -> t -> bool
    val add : elt -> t -> t
    val singleton : elt -> t
    val remove : elt -> t -> t
    val union : t -> t -> t
    val inter : t -> t -> t
    val diff : t -> t -> t
    val compare : t -> t -> int
    val equal : t -> t -> bool
    val subset : t -> t -> bool
    val iter : (elt -> unit) -> t -> unit
    val fold : (elt -> 'a -> 'a) -> t -> 'a -> 'a
    val for_all : (elt -> bool) -> t -> bool
    val exists : (elt -> bool) -> t -> bool
    val filter : (elt -> bool) -> t -> t
    val partition : (elt -> bool) -> t -> t * t
    val cardinal : t -> int
    val elements : t -> elt list
    val min_elt : t -> elt
    val max_elt : t -> elt
    val choose : t -> elt
    val split : elt -> t -> t * bool * t
    val find : elt -> t -> elt
    val of_list : elt list -> t
  end
# IntSet.empty;; (* Empty set. A set is an abstract type that will not display in the interpreter *)
- : IntSet.t = <abstr>
# IntSet.elements (IntSet.empty);; (* Get the previous set into a list *)
- : IntSet.elt list = []
# let s1 = IntSet.of_list [1;2;3;4;3];;
val s1 : IntSet.t = <abstr>
# IntSet.elements s1;;
- : IntSet.elt list = [1; 2; 3; 4]
# let s2 = IntSet.of_list [3;4;5;6];;
val s2 : IntSet.t = <abstr>
# IntSet.elements s2;;
- : IntSet.elt list = [3; 4; 5; 6]
# IntSet.elements (IntSet.union s1 s2);; (* Union *)
- : IntSet.elt list = [1; 2; 3; 4; 5; 6]
# IntSet.elements (IntSet.inter s1 s2);; (* Intersection *)
- : IntSet.elt list = [3; 4]
# IntSet.elements (IntSet.diff s1 s2);; (* Difference *)
- : IntSet.elt list = [1; 2]
# IntSet.subset s1 s1;; (* Subset *)
- : bool = true
# IntSet.subset (IntSet.of_list [3;1]) s1;;
- : bool = true
# IntSet.equal (IntSet.of_list [3;2;4;1]) s1;; (* Equality *)
- : bool = true
# IntSet.equal s1 s2;;
- : bool = false
# IntSet.mem 2 s1;; (* Membership *)
- : bool = true
# IntSet.mem 10 s1;;
- : bool = false
# IntSet.cardinal s1;; (* Cardinality *)
- : int = 4
# IntSet.elements (IntSet.add 99 s1);; (* Create a new set by inserting *)
- : IntSet.elt list = [1; 2; 3; 4; 99]
# IntSet.elements (IntSet.remove 3 s1);; (* Create a new set by deleting *)
- : IntSet.elt list = [1; 2; 4]
