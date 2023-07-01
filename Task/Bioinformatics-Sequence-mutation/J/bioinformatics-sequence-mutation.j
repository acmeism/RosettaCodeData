ACGT=: 'ACGT'
MUTS=: ;: 'del ins mut'

NB. generate sequence of size y of uniformly selected nucleotides.
NB. represent sequences as ints in range i.4 pretty printed. nuc
NB. defined separately to avoid fixing value inside mutation
NB. functions.
nuc=: monad : '?4'
dna=: nuc"0 @ i.

NB. randomly mutate nucleotide at a random index by deletion insertion
NB. or mutation of a nucleotide.
del=: {.,[:}.}.
ins=: {.,nuc@],}.
mut=: {.,nuc@],[:}.}.

NB. pretty print nucleotides in rows of 50 with numbering
seq=: [: (;~ [: (4&":"0) 50*i.@#) _50]\{&ACGT

sim=: monad define
'n k ws'=. y        NB. initial size, mutations, and weights for mutations
ws=. (% +/) ws      NB. normalize weights
A=.0$]D0=.D=. dna n NB. initial dna and history of actions

NB. k times do a random action according to weights and record it
for. i.k do.
  D=.". action=. (":?#D),' ',(":MUTS{::~(+/\ws)I.?0),' D'
  A=. action ; A
end.

echo 'actions';,. A-.a:
echo ('mutation';'probability') , MUTS ,. <"0 ws
('start';'end'),.(seq D0) ,: seq D
)

simulate=: (sim@(1 1 1&; &. |. ))`sim@.(3=#)
