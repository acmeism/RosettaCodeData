list := "abc,def,gh,ijklmnop,hello,world"
StringSplit list, list, `,
Random, randint, 1, %list0%
MsgBox % List%randint%
