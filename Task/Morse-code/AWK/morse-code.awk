BEGIN { FS="";
 m="A.-B-...C-.-.D-..E.F..-.G--.H....I..J.---K-.-L.-..M--N-.";
 m=m "O---P.--.Q--.-R.-.S...T-U..-V...-W.--X-..-Y-.--Z--..  ";
}

{ for(i=1; i<=NF; i++)
  {
    c=toupper($i); n=1; b=".";

    while((c!=b)&&(b!=" ")) { b=substr(m,n,1); n++; }

    b=substr(m,n,1);

    while((b==".")||(b=="-")) { printf("%s",b); n++; b=substr(m,n,1); }

    printf("|");
  }
  printf("\n");
}

usage: awk -f morse.awk [inputfile]

sos sos titanic
...|---|...||...|---|...||-|..|-|.-|-.|..|-.-.|
