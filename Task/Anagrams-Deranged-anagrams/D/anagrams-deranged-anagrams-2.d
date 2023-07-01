    string[][ubyte[]] anags;
    foreach (const w; "unixdict.txt".readText.split)
        anags[w.dup.representation.sort().release.assumeUnique] ~= w;
