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

cat = 'A cat is a lion in a jungle of small bushes.'
                                       /*assigns a literal ───►  CAT    */

call value 'CAT', "When the cat's away, the mice will play."
                                       /*assigns a literal ───►  CAT    */
yyy='CAT'
call value yyy, "Honest as the Cat when the meat's out of reach."
                                       /*assigns a literal ───►  CAT    */
