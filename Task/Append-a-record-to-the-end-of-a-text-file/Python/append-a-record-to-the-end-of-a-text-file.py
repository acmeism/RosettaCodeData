#############################
# Create a passwd text file
#############################
# note that UID & gid are of type "text"
passwd_list=[
  dict(account='jsmith', password='x', UID=1001, GID=1000, # UID and GID are type int
       GECOS=dict(fullname='Joe Smith', office='Room 1007', extension='(234)555-8917',
                  homephone='(234)555-0077', email='jsmith@rosettacode.org'),
                  directory='/home/jsmith', shell='/bin/bash'),
  dict(account='jdoe', password='x', UID=1002, GID=1000,
       GECOS=dict(fullname='Jane Doe', office='Room 1004', extension='(234)555-8914',
                  homephone='(234)555-0044', email='jdoe@rosettacode.org'),
       directory='/home/jdoe', shell='/bin/bash')
]

passwd_fields="account password UID GID GECOS directory shell".split()
GECOS_fields="fullname office extension homephone email".split()

def passwd_text_repr(passwd_rec):
# convert individual fields to string type
  passwd_rec["GECOS"]=",".join([ passwd_rec["GECOS"][field] for field in GECOS_fields])
  for field in passwd_rec: # convert "int" fields
    if not isinstance(passwd_rec[field], str):
      passwd_rec[field]=`passwd_rec[field]`
  return ":".join([ passwd_rec[field] for field in passwd_fields ])

passwd_text=open("passwd.txt","w")
for passwd_rec in passwd_list:
  print >> passwd_text,passwd_text_repr(passwd_rec)
passwd_text.close()

#################################
# Load text ready for appending
#################################
passwd_text=open("passwd.txt","a+")
new_rec=dict(account='xyz', password='x', UID=1003, GID=1000,
             GECOS=dict(fullname='X Yz', office='Room 1003', extension='(234)555-8913',
                        homephone='(234)555-0033', email='xyz@rosettacode.org'),
             directory='/home/xyz', shell='/bin/bash')
print >> passwd_text,  passwd_text_repr(new_rec)
passwd_text.close()

##############################################
# Finally reopen and check record was appended
##############################################
passwd_list=list(open("passwd.txt","r"))
if "xyz" in passwd_list[-1]:
  print "Appended record:",passwd_list[-1][:-1]
