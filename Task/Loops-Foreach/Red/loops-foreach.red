>> blk: ["John" 23 "dave" 30 "bob" 20 "Jeff" 40]
>> foreach item blk [print item]
John
23
dave
30
bob
20
Jeff
40
>>  foreach [name age] blk [print [name "is" age "years old"]]
John is 23 years old
dave is 30 years old
bob is 20 years old
Jeff is 40 years old

>> forall blk [print blk]
John 23 dave 30 bob 20 Jeff 40
23 dave 30 bob 20 Jeff 40
dave 30 bob 20 Jeff 40
30 bob 20 Jeff 40
bob 20 Jeff 40
20 Jeff 40
Jeff 40
40
