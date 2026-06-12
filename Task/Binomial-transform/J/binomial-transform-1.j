forward=: {{ y +/ .* !/~ i.#y }}
reverse=: {{ y +/ .* (!/~ * _1^+/~) i.#y }}
selfinv=: {{ y +/ .* (!/~ * _1^]) i.#y }}
