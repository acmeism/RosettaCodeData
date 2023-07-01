    array a1 = ({ "a", "b", "c" });
    array a2 = ({ "A", "B", "C" });
    array a3 = ({ "1", "2", "3" });

    foreach(a1; int index; string char_dummy)
        write("%s%s%s\n", a1[index], a2[index], a3[index]);
