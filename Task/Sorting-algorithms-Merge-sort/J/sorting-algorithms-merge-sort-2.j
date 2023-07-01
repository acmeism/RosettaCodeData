mergesort=: {{  r=. y [  stride=. 1
  while. stride < #r do. stride=. 2*mid=. stride
    r=. ;(-stride) (mid&}. <@merge (mid<.#) {.])\ r
  end.
}}
