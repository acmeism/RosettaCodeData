160 Number Class newPriority: Quaternion(a, b, c, d)

Quaternion method: _a  @a ;
Quaternion method: _b  @b ;
Quaternion method: _c  @c ;
Quaternion method: _d  @d ;

Quaternion method: initialize  := d := c := b := a ;
Quaternion method: <<  '(' <<c @a << ',' <<c @b << ',' <<c @c << ',' <<c @d << ')' <<c ;

Integer method: asQuaternion  self 0 0 0 Quaternion new ;
Float   method: asQuaternion  self 0 0 0 Quaternion new ;

Quaternion method: ==(q)  q _a @a == q _b @b == and q _c @c == and q _d @d == and ;
Quaternion method: norm   @a sq @b sq + @c sq + @d sq + sqrt ;
Quaternion method: conj   @a  @b neg  @c neg  @d neg Quaternion new ;
Quaternion method: +(q)   Quaternion new(q _a @a +, q _b @b +, q _c @c +, q _d @d +) ;
Quaternion method: -(q)   Quaternion new(q _a @a -, q _b @b -, q _c @c -, q _d @d -) ;

Quaternion method: *(q)
   Quaternion new(q _a @a * q _b @b * - q _c @c * - q _d @d * -,
                  q _a @b * q _b @a * + q _c @d * + q _d @c * -,
                  q _a @c * q _b @d * - q _c @a * + q _d @b * +,
                  q _a @d * q _b @c * + q _c @b * - q _d @a * + ) ;
