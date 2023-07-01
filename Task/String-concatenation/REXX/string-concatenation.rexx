s = "hello"
say s "literal"
t = s "literal"         /*whitespace between the two strings causes a space in the output.*/
say t
                        /*the above method works without spaces too.*/

genus= "straw"
say genus"berry"        /*this outputs strawberry.*/
say genus || "berry"    /*concatenation using a double-pipe does not cause spaces.*/
