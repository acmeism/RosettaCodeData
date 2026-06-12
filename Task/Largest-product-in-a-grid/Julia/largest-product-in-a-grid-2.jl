function maxprod(mat, len)
    nrow, ncol = size(mat)
    maxprod, maxrow, maxcol, arr = 0, 0:0, 0:0, [0]
    for row in 1:nrow, col in 1:ncol
        if row < nrow - len + 2
            pro = prod(mat[row:row+len-1, col])
            if pro > maxprod
                maxprod, maxrow, maxcol, arr = pro, row:row+len-1, col:col, mat[row:row+len-1, col]
            end
        end
        if col < ncol - len + 2
            pro = prod(mat[row, col:col+len-1])
            if pro > maxprod
                maxprod, maxrow, maxcol, arr = pro, row:row, col:col+len-1, mat[row, col:col+len-1]
            end
        end
    end
    println("The maximum product is $maxprod, product of $arr at row $maxrow, col $maxcol")
end

maxprod(mat, 4)
