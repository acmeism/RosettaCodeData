   wrap=: {{'<',m,'>',y,'</',(;{.;:m),'>' }}(L:0)("1)
   'table.htm'fwrite~'<style>tr:nth-child(even){color:blue}</style>','table' wrap ,'tr' wrap ;"1 'td' wrap din5008"1 sampledata
1660
   launch browser,' table.htm'
