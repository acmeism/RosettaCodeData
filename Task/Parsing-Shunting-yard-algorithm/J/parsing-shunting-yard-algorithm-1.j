NB. j does not have a verb based precedence.
NB. j evaluates verb noun sequences from right to left.
NB. Seriously.  18 precedence levels in C++ .

display=: ([: : (smoutput@:(, [: ; ' '&,&.>@:{:@:|:))) :: empty

Display=: adverb define
:
m display^:(0 -.@:-: x)y
)

NB. Queue, Stack, Pop: m literal name of vector to use.  verbose unless x is 0.
NB. Implementation includes display, group push and pop not available in the RC FIFO & LIFO pages
NB. As adverbs, these definitions work with any global variable.
NB. Pop needs the feature, and it helps with display as well.
Queue=: adverb define                   NB. enqueue y
('m'~)=: y ,~ (m~)
EMPTY
:
x (m,' queue')Display y
m Queue y
)

Stack=: adverb define                   NB. Stack y
('m'~)=: (|.y) , (m~)
EMPTY
:
x (m,' stack')Display y
m Stack y
)

Pop=: adverb define                     NB. Pop y items
0 m Pop y
:
y=. 0 {:@:, y                          NB. if y is empty use 0 instead
rv=. y {. (m~)
('m'~)=: y }. (m~)
x (m,' pop') Display rv
rv
)

NB. tests
TEST=: ''
'TEST'Stack'abc'
'TEST'Stack'de'
assert 'edc' -: 'TEST'Pop 3
assert 'ba' -: 'TEST'Pop 2
assert 0 (= #) TEST
'TEST'Queue'abc'
'TEST'Queue'de'
assert 'ab' -: 'TEST'Pop 2
assert 'cde' -: 'TEST'Pop 3
assert 0 (= #) TEST

any=: +./

DIGITS=: a. {~ 48+i.10                  NB. ASCII 48--57
precedence_oppression=: <;._1' +- */ ^ ( ) ',DIGITS
associativity=: 'xLLRxxL'

classify=: {:@:I.@:(1 , any@e.&>)&precedence_oppression

NB. The required tokens are also tokens in j.
NB. Use the default sequential machine ;: for lexical analysis.
rclex=: (;~ classify)"0@:;:


NB. numbers can be treated as highest precedence operators
number=: Q Queue                 NB. put numbers onto the output queue
left=: S Stack                   NB. push left paren onto the stack

NB. Until the token at the top of the stack is (, pop
NB. operators off the stack onto the output queue.
NB. Pop the left parenthesis from the stack, but not onto the output queue.
right=: 4 : 0    NB. If the token is a right parenthesis:
i=. (S~) (i. rclex) '('
if. i (= #) S~ do.
 smoutput'Check your parens!'
 throw.
end.
x Q Queue x S Pop i
x S Pop 1
EMPTY
)

NB. If the token is an operator, o1, then:
NB.
NB.  while there is  an operator token, o2, at the top  of the stack, and
NB.  either o1  is [[left-associative  and its precedence  is less  than or
NB.  equal to that  of o2]]"L*.<:", or o1 is  [[right-associative and its precedence
NB.  is less than that of o2]]"R*.<", pop o2 off the stack, onto the output queue;
NB.  [[the tally of adjacent leading truths]]"NCT"
NB.
NB.  push o1 onto the stack.
o=: 4 : 0
P=. 0 0 {:: y
L=. 'L' = P { associativity
operators=. ({.~ i.&(rclex'(')) S~
NB.    NCT          L*.<:     or       R*.<
i=. (+/@:(*./\)@:((L *. P&<:) +. ((-.L) *. P&<))@:(0&{::"1)) :: 0: operators
x Q Queue x S Pop i
x (S Stack) y
EMPTY
)

NB. terminating version of invalid
invalid=: 4 : 0
smoutput 'invalid token ',0 1 {:: y
throw.
)

NB. demonstrated invalid
invalid=: [: smoutput 'discarding invalid token ' , 0 1 {:: ]

NB. shunt_yard is a verb to implement shunt-yard parsing.
NB. verbose defaults to 0.  (quiet)
NB. use: verbosity shunt_yard_parse algebraic_string
shunt_yard_parse=: 0&$: : (4 : 0)

NB. j's data structure is array.  Rank 1 arrays (vectors)
NB. are just right for the stack and output queue.

'S Q'=: ;: 'OPERATOR OUTPUT'
('S'~)=:('Q'~)=: i.0 2

NB. Follow agenda for all tokens, result saved on global OUTPUT variable
x (invalid`o`o`o`left`right`number@.(0 0 {:: ])"2 ,:"1@:rclex) y
NB. x (invalid`o`o`o`left`right`o@.(0 0 {:: ])"2 ,:"1@:rclex) y  NB. numbers can be treated as operators
NB. check for junk on stack
if. (rclex'(') e. S~ do.
 smoutput'Check your other parens!'
 throw.
end.

NB. shift remaining operators onto the output queue
x Q Queue x S Pop # S~

NB. return the output queue
Q~
)

algebra_to_rpn=: {:@:|:@:shunt_yard_parse

fulfill_requirement=: ;@:(' '&,&.>)@:algebra_to_rpn
