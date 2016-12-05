(lib 'struct)
(lib 'sql)

(define Postal (make-table
    (struct postal (auto: id name street city state zip))))

Postal
    → #table:#struct:postal [id name street city state zip]:[0]

(table-insert Postal '(0 Gallubert "29 rue de l'Ermitage" Paris Seine 75020))
(table-insert Postal '(0 Brougnard "666 rue des Cascades " Paris Seine 75042))
(table-make-index Postal 'postal.id)
(table-print Postal)

[0]   15  Gallubert  29 rue de l'Ermitage   Paris  Seine  75020
[1]   16  Brougnard  666 rue des Cascades   Paris  Seine  75042
