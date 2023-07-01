datatype 'a node = Node of 'a * bool ref * 'a node list ref * 'a node list ref

fun node x = Node (x, ref false, ref nil, ref nil)
fun mark (Node (_, r, _, _)) = !r before r := true
fun unmark (Node (_, r, _, _)) = !r before r := false

fun value (Node (x, _, _, _)) = x
fun sources (Node (_, _, ref xs, _)) = xs
fun targets (Node (_, _, _, ref ys)) = ys

fun connect (m, n) =
  let
    val Node (_, _, _, ns) = m
    val Node (_, _, ms, _) = n
  in
    ms := m :: !ms;
    ns := n :: !ns
  end

datatype 'a step = One of 'a | Many of 'a list

fun visit (ms, nil) = ms
  | visit (ms, One m :: ss) = visit (m :: ms, ss)
  | visit (ms, Many nil :: ss) = visit (ms, ss)
  | visit (ms, Many (n :: ns) :: ss) =
    if mark n then
      visit (ms, Many ns :: ss)
    else
      visit (ms, Many (targets n) :: One n :: Many ns :: ss)

fun assign (xs, nil) = xs
  | assign (xs, nil :: ss) = assign (xs, ss)
  | assign (xs, (n :: ns) :: ss) =
    if unmark n then
      assign (value n :: xs, sources n :: ns :: ss)
    else
      assign (xs, ns :: ss)

fun assigns (xs, nil) = xs
  | assigns (xs, n :: ns) =
    if unmark n then
      let
        val x = sources n :: nil
        val x = value n :: assign (nil, x)
      in
        assigns (x :: xs, ns)
      end
    else
      assigns (xs, ns)

fun kosaraju xs = assigns (nil, visit (nil, Many xs :: nil))

fun make (n, is, ijs) =
  let
    val xs = Vector.tabulate (n, node)
    fun item i = Vector.sub (xs, i)
    fun step (i, j) = connect (item i, item j)
    fun path (i :: j :: js) = (step (i, j); path (j :: js))
      | path _ = ()
  in
    map item is before app path ijs
  end

val is = 0 :: nil
val ijs =
  [0, 1, 2, 0, 3, 4, 0, 5, 7] ::
  [0, 9, 10, 11, 12, 9, 11] ::
  [1, 12] ::
  [3, 5, 6, 7, 8, 6, 15] ::
  [5, 13, 14, 13, 15] ::
  [8, 15] ::
  [10, 13] ::
  nil

val ns = make (16, is, ijs)
val xs = kosaraju ns
