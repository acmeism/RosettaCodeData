circle_sort =: post  power_of_2_length@pre    NB. the main sorting verb
power_of_2_length =: even_length_iteration^:_ NB. repeat while the answer changes
even_length_iteration =: (<./ (,&$: |.) >./)@(-:@# ({. ,: |.@}.) ])^:(1<#)
pre =: ,   (-~ >.&.(2&^.))@# # >./            NB. extend data to next power of 2 length
post =: ({.~ #)~                              NB. remove the extra data
