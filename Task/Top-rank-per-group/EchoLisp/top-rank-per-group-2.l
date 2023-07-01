(define emps_file
'(("Tyler Bennett" E10297 32000 D101)
("John Rappl" E21437 47000 D050)
("George Woltman" E00127 53500 D101)
("Adam Smith" E63535 18000 D202)
("Claire Buckman" E39876 27800 D202)
("David McClellan" E04242 41500 D101)
("Rich Holcomb" E01234 49500 D202)
("Simon Gallubert" E00000 42 D666)
("Nathan Adams" E41298 21900 D050)
("Richard Potter" E43128 15900 D101)
("David Motsinger" E27002 19250 D202)
("Tim Sampair" E03033 27000 D101)
("Kim Arlich" E10001 57000 D190)
("Timothy Grove" E16398 29900 D190)))

(list->table emps_file emps ) ;; load the table

(get-high 2 high)
(table-print high)

[0]   D050  John Rappl       47000
[1]   D050  Nathan Adams     21900
[2]   D101  George Woltman   53500
[3]   D101  David McClellan  41500
[4]   D190  Kim Arlich       57000
[5]   D190  Timothy Grove    29900
[6]   D202  Rich Holcomb     49500
[7]   D202  Claire Buckman   27800
[8]   D666  Simon Gallubert  42

(sql-delete from high)
(get-high 1 high)
(table-print high)
[0]   D050  John Rappl       47000
[1]   D101  George Woltman   53500
[2]   D190  Kim Arlich       57000
[3]   D202  Rich Holcomb     49500
[4]   D666  Simon Gallubert  42
