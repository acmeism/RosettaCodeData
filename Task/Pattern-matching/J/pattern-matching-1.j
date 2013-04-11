help=: noun define
red-black tree
Store dictionary in red-black tree.  The keys can be any noun.

Reference:
Left-leaning Red-Black Trees
Robert Sedgewick
Department of Computer Science
Princeton University

verbs:
insert key;value  Inserts item into tree
delete key        Deletes item with key from tree
                  Deletion via the Sedgewick method is fairly simple.
                  However, I elected to remove the KEY;VALUE pair
                  rather than change the tree.
find key          Returns the associated definition or EMPTY
items any_noun    Returns all the items as a rank 1 array of KEY;VALUE pairs
keys any_noun     Returns all the keys as a rank 1 array of boxes
values any_noun   Returns all the values as a rank 1 array of boxes

J stores all data as arrays.
I chose to use array indexes to implement pointers.
An "index" is a rank 0 length 1 array.

Internal data structure:

T This rank 2 array stores indexes of left and right at each branch point.
C rank 1 array of node color.
H rank 1 array of the hash value of each key.
R rank 0 array stores the root index.
D rank 1 array of boxes.  In each box is a rank 2 array of key value
  pairs associated with the hash value.  Hash collision invokes direct
  lookup by key among the keys having same hash.

Additional test idea (done):
  Changing the hash to 0: or 2&| rapidly tests
  hash collision code for integer keys.
)

bitand=: (#. 1  0 0 0 1)b.
bitxor=: (#. 1  0 1 1 0)b.
hash=: [: ((4294967295) bitand (bitxor 1201&*))/ 846661 ,~ ,@:(a.&i.)@:":
NB. hash=: ] [ 1&bitand NB. can choose simple hash functions for tests

setup=: 3 : 0
T=: i. 0 2                              NB. Tree
H=: D=: C=: i. 0                        NB. Hashes, Data, Color
R=: _                                   NB. Root
'BLACK RED'=: i. 2
EMPTY
)

setup''

flipColors=: monad def 'C=: -.@:{`[`]}&C (, {&T) y'

3 : 0 'test flipColors'
DD=.D=: ,/<@:(;3j1&":)"0 i.3
TT=.T=: _ _,0 2,:_ _
CC=.C=: 1 0 1
RR=.R=: 1
HH=.H=: i.3
flipColors R
assert C -: -. CC
assert HH -: H
assert TT -: T
assert DD -: D
assert RR -: R
)

getColor=: monad def 'C ({~ :: (BLACK"_))"_ 0 y' NB. y the node

rotateTree=: dyad define                NB. x left or right, y node
I=. x <@:(, -.)~ y
X=. I { T                               NB. x = root.otherside
J=. X <@:, x
T=: (J { T) I} T
T=: y J} T
C=: y (RED ,~ {)`(X , [)`]} C
X
)

3 : 0 'test rotateTree'
DD=.D=:,/<@:(;3j1&":)"0 i.5
TT=.T=:_ _,0 2,_ _,1 4,:_ _
CC=.C=:0 1 0 0 0
R=:3
HH=.H=:i.5
assert R = rotateTree/0 1 , R
assert DD -: D
assert CC -: C
assert HH -: H
assert TT -: T
)

setup''

insert_privately=: adverb define
:
ROOT=. m
HASH=. x
ITEM=. y
if. _ -: ROOT do.                       NB. new key
 ROOT=. # H
 H=: H , HASH
 T=: T , _ _
 D=: D , < ,: , ITEM
 C=: C , RED
elseif. HASH = ROOT { H do.       NB. change a value or hash collision
 STACK=. ROOT >@:{ D
 I=. STACK i.&:({."1) ITEM
 STACK=. ITEM <@:(I}`,@.(I = #@])) STACK
 D=: STACK ROOT } D
elseif. do.          NB. Follow tree
 NB. if both children are red then flipColors ROOT
 flipColors^:((,~ RED) -: getColor@:({&T)) ROOT
 I=. <@:(, HASH > {&H) ROOT
 TEMP=. HASH (I { T) insert_privately y
 T=:  TEMP I } T
 NB.if (isRed(h.right) && !isRed(h.left)) h = rotateLeft(h)
 ROOT=. 0&rotateTree^:((BLACK,RED) -: getColor@:({&T)) ROOT
 NB.if (isRed(h.left) && isRed(h.left.left)) h = rotateRight(h)
 if. RED -: getColor {. ROOT { T do.
  if. (RED -: (getColor@:(([: {&T <@:,&0)^:2) :: (BLACK"_))) ROOT do.
   ROOT=. 1 rotateTree ROOT
  end.
 end.
end.
ROOT
)

insert=: monad define"1
assert 'boxed' -: datatype y
R=: (R insert_privately~ hash@:(0&{::)) y
C=: BLACK R } C
y
)

find_hash_index=: monad define          NB. y is the hash
if. 0 = # T do. '' return. end.         NB. follow the tree
I=. R                                   NB. instead of
while. y ~: I { H do.                   NB. direct search
 J=. <@:(, y > {&H) I
 if. _ > II=. J { T do. I=. II else. '' return. end.
end.
)

find=: monad define
if. '' -: I=. find_hash_index hash y do. EMPTY return. end.
LIST=. I {:: D
K=. {. |: LIST
LIST {::~ ::empty 1 ,~ K i. < y
)

delete=: 3 : 0
if. '' -: I=. find_hash_index hash y do. EMPTY return. end.
LIST=. I {:: D
K=. {. |: LIST
J=. K i. < y
RESULT=. J ({::~ ,&1)~ LIST
STACK=. J <@:({. , (}.~ >:)~) LIST
D=. LIST I } D
RESULT
)

getPathsToLeaves=: a:&$: : (4 : 0) NB. PATH getPathsToLeaves ROOT  use: getPathsToLeaves R
if. 0 = # y do. getPathsToLeaves R return. end.
PATH=. x ,&.> y
if. _ -: y do. return. end.
PATH getPathsToLeaves"0 y { T
)

check=: 3 : 0
COLORS=. getColor"0&.> a: -.~ ~. , getPathsToLeaves ''
result=. EMPTY
if. 0&e.@:(= {.) +/@:(BLACK&=)@>COLORS do. result=. result,<'mismatched black count' end.
if. 1 e. 1&e.@:(*. (= 1&|.))@:(RED&=)@>COLORS do. result=. result,<'successive reds' end.
>result
)

getPath=: 3 : 0                        NB. get path to y, the key
if. 0 = # H do. EMPTY return. end.
HASH=. hash y
PATH=. , I=. R
while. HASH ~: I { H do.
 J=. <@:(, HASH > {&H) I
 PATH=. PATH , II=. J { T
 if. _ > II do. I=. II else. EMPTY return. end.
end.
PATH
)

items=: 3 :';D'
keys=: 3 :'0{"1 items y'
values=: 3 :'1{"1 items y'
