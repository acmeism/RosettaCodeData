/*REXX ----------------------------------------------------------------
* 09.04.2014 Walter Pachl  the REXX solution adapted for ooRexx
*                          which provides a function package rxMath
*--------------------------------------------------------------------*/
Numeric Digits 16
Numeric Fuzz   3;    pi=rxCalcpi();  a.=''
 a.1 = 'pi/4 =    rxCalcarctan(1/2,16,'R')    +    rxCalcarctan(1/3,16,'R')'
 a.2 = 'pi/4 =  2*rxCalcarctan(1/3,16,'R')    +    rxCalcarctan(1/7,16,'R')'
 a.3 = 'pi/4 =  4*rxCalcarctan(1/5,16,'R')    -    rxCalcarctan(1/239,16,'R')'
 a.4 = 'pi/4 =  5*rxCalcarctan(1/7,16,'R')    +  2*rxCalcarctan(3/79,16,'R')'
 a.5 = 'pi/4 =  5*rxCalcarctan(29/278,16,'R') +  7*rxCalcarctan(3/79,16,'R')'
 a.6 = 'pi/4 =  rxCalcarctan(1/2,16,'R')      +    rxCalcarctan(1/5,16,'R')   +    rxCalcarctan(1/8,16,'R')'
 a.7 = 'pi/4 =  4*rxCalcarctan(1/5,16,'R')    -    rxCalcarctan(1/70,16,'R')  +    rxCalcarctan(1/99,16,'R')'
 a.8 = 'pi/4 =  5*rxCalcarctan(1/7,16,'R')    +  4*rxCalcarctan(1/53,16,'R')  +  2*rxCalcarctan(1/4443,16,'R')'
 a.9 = 'pi/4 =  6*rxCalcarctan(1/8,16,'R')    +  2*rxCalcarctan(1/57,16,'R')  +    rxCalcarctan(1/239,16,'R')'
a.10 = 'pi/4 =  8*rxCalcarctan(1/10,16,'R')   -    rxCalcarctan(1/239,16,'R') -  4*rxCalcarctan(1/515,16,'R')'
a.11 = 'pi/4 = 12*rxCalcarctan(1/18,16,'R')   +  8*rxCalcarctan(1/57,16,'R')  -  5*rxCalcarctan(1/239,16,'R')'
a.12 = 'pi/4 = 16*rxCalcarctan(1/21,16,'R')   +  3*rxCalcarctan(1/239,16,'R') +  4*rxCalcarctan(3/1042,16,'R')'
a.13 = 'pi/4 = 22*rxCalcarctan(1/28,16,'R')   +  2*rxCalcarctan(1/443,16,'R') -  5*rxCalcarctan(1/1393,16,'R') - 10*rxCalcarctan(1/11018,16,'R')'
a.14 = 'pi/4 = 22*rxCalcarctan(1/38,16,'R')   + 17*rxCalcarctan(7/601,16,'R') + 10*rxCalcarctan(7/8149,16,'R')'
a.15 = 'pi/4 = 44*rxCalcarctan(1/57,16,'R')   +  7*rxCalcarctan(1/239,16,'R') - 12*rxCalcarctan(1/682,16,'R')  + 24*rxCalcarctan(1/12943,16,'R')'
a.16 = 'pi/4 = 88*rxCalcarctan(1/172,16,'R')  + 51*rxCalcarctan(1/239,16,'R') + 32*rxCalcarctan(1/682,16,'R')  + 44*rxCalcarctan(1/5357,16,'R')  + 68*rxCalcarctan(1/12943,16,'R')'
a.17 = 'pi/4 = 88*rxCalcarctan(1/172,16,'R')  + 51*rxCalcarctan(1/239,16,'R') + 32*rxCalcarctan(1/682,16,'R')  + 44*rxCalcarctan(1/5357,16,'R')  + 68*rxCalcarctan(1/12944,16,'R')'
        do j=1  while  a.j\==''        /*evaluate each of the formulas. */
        interpret  'answer='   "("   a.j   ")"      /*the heavy lifting.*/
        say  right(word('bad OK',answer+1),3)": "     space(a.j,0)
        end   /*j*/                    /* [?]  show OK | bad, formula.  */
::requires rxmath library
