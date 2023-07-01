Object Class new: Complex(re, im)

Complex method: re  @re ;
Complex method: im  @im ;

Complex method: initialize   := im := re ;
Complex method: <<  '(' <<c @re << ',' <<c @im << ')' <<c  ;

0 1 Complex new const: I

Complex method: ==(c -- b )
    c re @re == c im @im == and ;

Complex method: norm -- f
    @re sq @im sq + sqrt ;

Complex method: conj -- c
    @re @im neg Complex new ;

Complex method: +(c -- d )
    c re @re +  c im @im + Complex new ;

Complex method: -(c -- d )
    c re @re -  c im @im - Complex new ;

Complex method: *(c -- d)
    c re @re * c im @im * -  c re @im * @re c im * + Complex new ;

Complex method: inv
| n |
   @re sq @im sq + >float ->n
   @re n /   @im neg n / Complex new
;

Complex method: /( c -- d )
   c self inv * ;

Integer method: >complex  self 0 Complex new ;
Float   method: >complex  self 0 Complex new ;
