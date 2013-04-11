kk = '123'x                            /*assigns hex  00000123 ───► KK  */
kk = 'dead beaf'X                      /*assigns hex  deadbeaf ───► KK  */
ll = '0000 0010'b                      /*assigns blank ───► LL  (ASCII) */
mm = '0000 0100'B                      /*assigns blank ───► MM  (EBCDIC)*/

xxx = '11 2. 333 -5'
parse var xxx   nn oo pp qq rr
                                       /*assigns     11    ───►  NN     */
                                       /*assigns     2.    ───►  OO     */
                                       /*assigns    333    ───►  PP     */
                                       /*assigns     ─5    ───►  QQ     */
                                       /*assigns   "null"  ───►  RR     */
