	str1 := "abcdefghijklmnopqrstuvwxyz";
        str3 := str1; (* don't compile, incompatible assignement *)
        str3 := str1$; (* runtime error, string too long *)
        str2 := str1$; (* OK *)
