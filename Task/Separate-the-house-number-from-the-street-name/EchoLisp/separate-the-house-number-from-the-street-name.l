(lib 'struct)
(lib 'sql)

(define adresses (make-table (struct adresse (name number))))

;; parse street<space>number| II...
(define extractor (make-regexp
	"^(.*?)\\s(\\d+$|\\d+.*$|II*$)"))
	
;; making our best with the special names
(define specials '("1940" "1945" "'45" "'40"))

(define (rep-special str specials)
		(for/fold (ostr str) ((special specials))
		(string-replace ostr special (string-append "@" special))))
		
(define (un-rep-special record)
	(set-car! record (string-replace (car record) "/@/g" "" )))		



(define (task)
(for-each (lambda (x)
	(table-insert adresses
	(un-rep-special
    (or*  (regexp-exec extractor (rep-special x specials))
          (list x '❓❓❓))))) adressen))

(define adressen '(
"Plataanstraat 5"
"Straat 12"
"Straat 12 II"
"Straat 1940 II"
"Dr. J. Straat   40"
"Dr. J. Straat 12 a"
"Dr. J. Straat 12-14"
"Laan 1940 – 1945 37"
"Plein 1940 2"
"1213-laan 11"
"16 april 1944 Pad 1"
"1e Kruisweg 36"
"Laan 1940-'45 66"
"Laan '40-'45"
"Langeloërduinen 3 46"
"Marienwaerdt 2e Dreef 2"
"Provincialeweg N205 1"
"Rivium 2e Straat 59."
"Nieuwe gracht 20rd"
"Nieuwe gracht 20rd 2"
"Nieuwe gracht 20zw /2"
"Nieuwe gracht 20zw/3"
"Nieuwe gracht 20 zw/4"
"Bahnhofstr. 4"
"Wertstr. 10"
"Lindenhof 1"
"Nordesch 20"
"Weilstr. 6"
"Harthauer Weg 2"
"Mainaustr. 49"
"August-Horch-Str. 3"
"Marktplatz 31"
"Schmidener Weg 3"
"Karl-Weysser-Str. 6"))
