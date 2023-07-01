string all = Stdio.read_file("README.md");
mapping res = ([]);
foreach(all/1, string char)
    res[char]++;
write("%O\n", res);
