Parse Version v
Say v
fid='test.txt'
x=sysfiletree(fid,a.)
Say a.0
Say a.1
Say left(copies('123456789.',10),length(a.1))
Parse Var a.1 20 size .
Say 'file size:' size
s=charin(fid,,1000)
Say length(s)
Say 'file' fid
'type' fid
