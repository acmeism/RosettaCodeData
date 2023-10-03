(let ascii (map char-code (range 127)))

(.. str "Upper-case: " (filter upper? ascii) "
Lower-case: " (filter lower? ascii))
