odd=: i. |."_1&|:^:2 >:@i.@,~
strachey2=: (odd +/~ (0 2,:3 1) * *:)@-:
exchange=: (* -.) + (* |.)~
columns=: {: | i.
strachey3=: exchange (,:~1 0) * ((2%~1-~{:) > columns)@$
strachey4=: exchange (,:~0 1) * ((2%~1+{:)< columns)@$
strachey5=: exchange (,:~1 0) */ (i.@,~@{: e. ((]*0 1+[)-:@<:)@{:)@$

strachey=: [: ,/ [: ,./"3 strachey5 @ strachey4 @ strachey3 @ strachey2
