my Int:D $i = 1; # if $i has to be defined you must provide a default value
multi sub foo(Int:D $i where * != 0){ (0..100).roll / $i } # we will never divide by 0
multi sub foo(Int:U $i){ die 'WELP! $i is undefined' } # because undefinedness is deadly
multi sub foo(Int:_ where * == 0){ die q{I'm sorry, Dave, I'm afraid I can't do that.} }

with $i { say 'defined' } # as "if" is looking for Bool::True, "with" is looking for *.defined
with 0 { say '0 may not divide but it is defined' }
