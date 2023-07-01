(require 'struct)
(require 'json)

;; importing data
(define cities
#<<
[{"name":"Lagos", "population":21}, {"name":"Cairo", "population":15.2}, {"name":"Kinshasa-Brazzaville", "population":11.3}, {"name":"Greater Johannesburg", "population":7.55}, {"name":"Mogadishu", "population":5.85}, {"name":"Khartoum-Omdurman", "population":4.98}, {"name":"Dar Es Salaam", "population":4.7}, {"name":"Alexandria", "population":4.58}, {"name":"Abidjan", "population":4.4}, {"name":"Casablanca", "population":3.98}]
>>#)

;; define a structure matching data
;; heterogenous  slots values
(struct city (name population))

;; convert JSON to EchoLisp instances of structures
(set! cities
	(vector-map (lambda(x) (json->struct x struct:city)) (json-import cities)))
	
;; search by name, case indifferent
(define (city-index name)
	(vector-search (lambda(x) (string-ci=? (city-name x) name)) cities))
	
;; returns first city name such as population < seuil
(define (city-pop seuil)
	(define idx (vector-search (lambda(x) (< (city-population x) seuil)) cities))
	(if idx
		(city-name (vector-ref cities idx))
		(cons seuil 'not-found)))


(city-index "Dar Es Salaam") → 6
(city-pop 5) → "Khartoum-Omdurman"
(city-pop -666) → (-666 . not-found)
(city-index "alexandra") → #f
