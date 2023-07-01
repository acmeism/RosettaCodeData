gen_dict =: (({. , #)/.~@:,@:(+/&>)@:{@:(# <@:>:@:i.)~ ; ^)&x:

beating_probability =: dyad define
 'C0 P0' =. gen_dict/ x
 'C1 P1' =. gen_dict/ y
 (C0 +/@:,@:(>/&:({."1) * */&:({:"1)) C1) % (P0 * P1)
)
