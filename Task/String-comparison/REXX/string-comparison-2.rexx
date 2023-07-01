/* REXX ***************************************************************
* 16.05.2013 Walter Pachl
**********************************************************************/
Call test 'A','<','a'
Call test 'A','=',' a'
Call test 'A','==',' a'
Call test 'Walter','<',' Wolter'
Exit

test: Procedure
Parse Arg o1,op,o2
Say q(o1) op q(o2) '->' clcompare(o1,op,o2)
Return

clcompare: Procedure
/* caseless comparison of the operands */
Parse Arg opd1,op,opd2
opd1u=translate(opd1)
opd2u=translate(opd2)
Interpret 'res=opd1u' op 'opd2u'
Return res

q: Return '"'arg(1)'"'
