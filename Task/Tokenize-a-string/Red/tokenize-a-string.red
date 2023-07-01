str: "Hello,How,Are,You,Today"
>> tokens: split str ","
>> probe tokens
["Hello" "How" "Are" "You" "Today"]

>> periods: replace/all form tokens " " "."        ;The word FORM converts the list series to a string removing quotes.
>> print periods                                            ;then REPLACE/ALL spaces with period
Hello.How.Are.You.Today
