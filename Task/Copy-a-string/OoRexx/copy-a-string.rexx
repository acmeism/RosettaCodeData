/* Rexx ***************************************************************
* 16.05.2013 Walter Pachl
**********************************************************************/

s1 = 'This is a Rexx string'
s2 = s1 /* does not copy the string */

Say 's1='s1
Say 's2='s2
i1=s1~identityhash; Say 's1~identityhash='i1
i2=s2~identityhash; Say 's2~identityhash='i2

s2 = s2~changestr('*', '*') /* creates a modified copy */

Say 's1='s1
Say 's2='s2
i1=s1~identityhash; Say 's1~identityhash='i1
i2=s2~identityhash; Say 's2~identityhash='i2
