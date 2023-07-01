let copy()=let n,g=stdin,stdout
           let rec fN()=match n.ReadLine() with "EOF"->g.Write "" |i->g.WriteLine i; fN()
           fN()
copy()
