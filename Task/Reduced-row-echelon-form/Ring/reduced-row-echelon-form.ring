# Project : Reduced row echelon form
# Date    : 2017/12/27
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

matrix = [[1, 2, -1, -4],
              [2, 3, -1, -11],
              [ -2, 0, -3, 22]]
ref(matrix)
for row = 1 to 3
     for col = 1 to 4
           if matrix[row][col] = -0
              see "0 "
           else
              see "" + matrix[row][col] + " "
           ok
     next
     see nl
next

func ref(m)
nrows = 3
ncols = 4
lead = 1
for r = 1 to nrows
      if lead >= ncols
         exit
      ok
      i = r
      while m[i][lead] = 0
                i = i + 1
                if i = nrows
                   i = r
                   lead = lead + 1
                   if lead = ncols
                      exit 2
                   ok
                ok
      end
      for j = 1 to ncols
           temp = m[i][j]
           m[i][j] = m[r][j]
           m[r][j] = temp
      next
      n = m[r][lead]
      if n != 0
         for j = 1 to ncols
              m[r][j] = m[r][j] / n
         next
      ok
      for i = 1 to nrows
           if i != r
              n = m[i][lead]
              for j = 1 to ncols
                   m[i][j] = m[i][j] - m[r][j] * n
              next
           ok
      next
     lead = lead + 1
next
