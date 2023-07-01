divert(-1)

# Get a random number from 0 to one less than $1.
# (Note that this is not a very good RNG. Also it writes a file.)
#
# Usage: randnum(N)   (Produces a random integer in 0..N-1)
#
define(`randnum',
  `syscmd(`echo $RANDOM > __random_number__')eval(include(__random_number__) % ( $1 ))')

# The *target* specified in the Rosetta Code task.
define(`target',`METHINKS IT IS LIKE A WEASEL')

define(`alphabet',`ABCDEFGHIJKLMNOPQRSTUVWXYZ ')
define(`random_letter',`substr(alphabet,randnum(len(alphabet)),1)')

define(`create_primogenitor',`_$0(`')')
define(`_create_primogenitor',`ifelse(len(`$1'),len(target),`$1',
                                      `$0(`$1'random_letter)')')

# The *parent* specified in the Rosetta Code task.
define(`parent',`'create_primogenitor)

#
# Usage: mutate_letter(STRING,INDEX)
#
define(`mutate_letter',
  `substr(`$1',0,`$2')`'random_letter`'substr(`$1',incr(`$2'))')

#
# Usage: mutate_letter_at_rate(STRING,INDEX,MUTATION_RATE)
#
define(`mutate_letter_at_rate',
  `ifelse(eval(randnum(100) < ($3)),1,`mutate_letter(`$1',`$2')',`$1')')

# The *mutate* procedure specified in the Rosetta Code task. The
# mutation rate is given in percents.
#
# Usage: mutate(STRING,MUTATION_RATE)
#
define(`mutate',`_$0(`$1',`$2',len(`$1'))')
define(`_mutate',
  `ifelse($3,0,`$1',
          `$0(mutate_letter_at_rate(`$1',decr($3),`$2'),`$2',decr($3))')')

# The *fitness* procedure specified in the Rosetta Code
# task. "Fitness" here is simply how many letters match.
#
# Usage: fitness(STRING)
#
define(`fitness',`_$0(`$1',target,0)')
define(`_fitness',
  `ifelse(`$1',`',$3,
      `ifelse(`'substr(`$1',0,1),`'substr(`$2',0,1),
                  `$0(`'substr(`$1',1),`'substr(`$2',1),incr($3))',
                  `$0(`'substr(`$1',1),`'substr(`$2',1),$3)')')')

#
# Usage: have_child(PARENT,MUTATION_RATE)
#
# The result is either the parent or the child: whichever has the
# greater fitness. If they are equally fit, one is chosen arbitrarily.
# (Note that, in the current implementation, fitnesses are not
# memoized.)
#
define(`have_child',
`pushdef(`_child_',mutate(`$1',`$2'))`'dnl
ifelse(eval(fitness(`'_child_) < fitness(`$1')),1,`$1',`_child_')`'dnl
popdef(`_child_')')

#
# Usage: next_parent(PARENT,NUM_CHILDREN,MUTATION_RATE)
#
# Note that a string is discarded as soon as it is known it will not
# be in the next generation. If some strings have the same highest
# fitness, one of them is chosen arbitrarily.
#
define(`next_parent',`_$0(`$1',`$2',`$3',`$1')')
define(`_next_parent',
  `ifelse(`$2',0,`$1',
          `$0(`'have_child(`$4',`$3'),decr(`$2'),`$3',`$4')')')

define(`repeat_until_equal',
  `ifelse(`$1',`'target,`[$1]',
`pushdef(`_the_horta_',`'next_parent(`$1',`$2',`$3'))`'dnl
[_the_horta_]
$0(`'_the_horta_,`$2',`$3')`'dnl
popdef(`_the_horta_')')')

divert`'dnl
[parent]
repeat_until_equal(parent,10,10)
