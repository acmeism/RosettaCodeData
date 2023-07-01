bash$ a='apples, pears ; and bananas'
bash$ b='apples, pears # and bananas'
bash$ echo ${a%%;*}
apples, pears
bash$ echo ${b%%#*}
apples, pears
bash$
