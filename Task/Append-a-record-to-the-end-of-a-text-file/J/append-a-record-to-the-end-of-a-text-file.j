require'strings ~system/packages/misc/xenos.ijs'
record=: [:|: <@deb;._1@(':',]);._2@do bind '0 :0'

passfields=: <;._1':username:password:gid:uid:gecos:home:shell'

passrec=: LF,~ [: }.@;@ , ':';"0 (passfields i. {. ) { a:,~ {:

R1=: passrec record''
   username: jsmith
   password: x
   gid: 1001
   uid: 1000
   gecos: Joe Smith,Room 1007,(234)555-8917,(234)555-0077,jsmith@rosettacode.org
   home: /home/jsmith
   shell: /bin/bash
)

R2=: passrec record''
   username: jdoe
   password: x
   gid: 1002
   uid: 1000
   gecos: Jane Doe,Room 1004,(234)555-8914,(234)555-0044,jdoe@rosettacode.org
   home: /home/jdoe
   shell: /bin/bash
)

R3=: passrec record''
   username: xyz
   password: x
   gid: 1003
   uid: 1000
   gecos: X Yz,Room 1003,(234)555-8913,(234)555-0033,xyz@rosettacode.org
   home: /home/xyz
   shell: /bin/bash
)

passwd=: <'/tmp/passwd.txt'  NB. file needs to be writable on implementation machine

(R1,R2) fwrite passwd
R3 fappend passwd

assert 1 e. R3 E. fread passwd
