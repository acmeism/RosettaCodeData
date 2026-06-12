// Alphabetic sort. Nigel Galloway: July 27th., 2021
let fG n g=let g=g|>Seq.countBy id|>Map.ofSeq in [for n in n->if Map.containsKey n g then [|for g in 1..g.[n]->n|]|>System.String else ""]|>String.concat ""
let English=fG ['a';'A';'b';'B';'c';'C';'d';'D';'e';'E';'f';'F';'g';'G';'h';'H';'i';'I';'j';'J';'k';'K';'l';'L';'m';'M';'n';'N';'o';'O';'p';'P';'q';'Q';'r';'R';'s';'S';'t';'T';'u';'U';'v';'V';'w';'W';'x';'X';'y';'Y';'z';'Z']
let Turkish=fG ['a';'A';'b';'B';'c';'C';'ç';'Ç';'d';'D';'e';'E';'f';'F';'g';'G';'ğ';'Ğ';'h';'H';'ı';'I';'i';'İ';'j';'J';'k';'K';'l';'L';'m';'M';'n';'N';'o';'O';'ö';'Ö';'p';'P';'r';'R';'s';'S';'ş';'Ş';'t';'T';'u';'U';'ü';'Ü';'v';'V';'y';'Y';'z';'Z'];
let main args=use n=new System.IO.StreamWriter(System.IO.File.Create("out.txt"))
              n.WriteLine(English "baNAnaBAnaNA")
              n.WriteLine(Turkish (String.filter((<>)' ') "Meseleyi anlamağa başladı"))

