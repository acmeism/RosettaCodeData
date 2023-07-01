palindromify=: [: , ((,~ |.@}.) ; (,~ |.))&>
gapful=: (0 = (|~ ({.,{:)&.(10&#.inv)))&>
task2_cartesian_products=: [: , [: { ((i. 10) ; (>: i. 9)) #~ ,&1
task2_palindromes=: [: 10&#.&> [: palindromify task2_cartesian_products
task2_gapfuls=: [: /:~ [: ; [: (#~ gapful)@task2_palindromes&.> >:@i.
