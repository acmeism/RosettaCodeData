s = "hello"
say s "literal"
t = s "literal"    /* Whitespace between the two strings causes a space in the output */
say t

                        /* The above method works without spaces too */
genus="straw"
say genus"berry"        /* This outputs strawberry */
say genus || "berry"    /* Concatenation using a doublepipe does not cause spaces */
