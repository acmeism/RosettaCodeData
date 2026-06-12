#lang racket

(define extractor-rx
  (pregexp (string-append "^(.*?)\\s+((?:"
                          "(?:\\d+[-/]\\d+)"
                          "|(?:(?!1940|1945)\\d+[a-zI. /]*\\d*)"
                          ")$)")))

(define adressen
  "Plataanstraat 5
   Straat 12
   Straat 12 II
   Straat 1940 II
   Dr. J. Straat   40
   Dr. J. Straat 12 a
   Dr. J. Straat 12-14
   Laan 1940 – 1945 37
   Plein 1940 2
   1213-laan 11
   16 april 1944 Pad 1
   1e Kruisweg 36
   Laan 1940-’45 66
   Laan ’40-’45
   Langeloërduinen 3 46
   Marienwaerdt 2e Dreef 2
   Provincialeweg N205 1
   Rivium 2e Straat 59.
   Nieuwe gracht 20rd
   Nieuwe gracht 20rd 2
   Nieuwe gracht 20zw /2
   Nieuwe gracht 20zw/3
   Nieuwe gracht 20 zw/4
   Bahnhofstr. 4
   Wertstr. 10
   Lindenhof 1
   Nordesch 20
   Weilstr. 6
   Harthauer Weg 2
   Mainaustr. 49
   August-Horch-Str. 3
   Marktplatz 31
   Schmidener Weg 3
   Karl-Weysser-Str. 6")

(define (splits-adressen str)
  (regexp-match extractor-rx str))

(for ([str (in-list (string-split adressen #rx" *\r?\n *"))])
  (printf "~s -> ~s\n" str
          (cond [(splits-adressen str) => cdr]
                [else '???])))
