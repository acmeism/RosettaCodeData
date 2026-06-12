ukgram=: /:~@uk&.>

sample=: I.(e. ~. #~ 1<#/.~)ukgram i. 1e6
sam1e3=: I.(e. ~. #~ 1<#/.~)ukgram i. 1e3
sam1e4=: I.(e. ~. #~ 1<#/.~)ukgram i. 1e4

largegroups=: {{
   tokens=. /:~@uk&.> y
   utokens=. ~. tokens
   ucounts=. #/.~ tokens
   uids=. utokens #~ (=>./) ucounts
   >}.y </.~ uids i. tokens
}}
