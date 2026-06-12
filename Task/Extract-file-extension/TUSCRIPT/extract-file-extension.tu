$$ MODE DATA
$$ testcases=*
http://example.com/download.tar.gz
CharacterModel.3DS
.desktop
document
document.txt_backup
/etc/pam.d/login
picture.jpg
http://mywebsite.com/picture/image.png
myuniquefile.longextension
IamAFileWithoutExtension
path/to.my/file
file.odd_one
thisismine

$$ MODE TUSCRIPT,{}

BUILD C_GROUP A0 = *
DATA {&a}
DATA {\0}

BUILD S_TABLE legaltokens=*
DATA :.{1-00}{C:A0}{]}:

LOOP testcase=testcases
 extension=STRINGS (testcase,legaltokens,0,0)
 IF (extension=="") CYCLE
 PRINT testcase, " has extension ", extension
ENDLOOP
