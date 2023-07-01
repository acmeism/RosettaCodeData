local matrix = require "matrix" -- https://github.com/davidm/lua-matrix

local function cramer(mat, vec)
  -- Check if matrix is quadratic
  assert(#mat == #mat[1], "Matrix is not square!")
  -- Check if vector has the same size of the matrix
  assert(#mat == #vec, "Vector has not the same size of the matrix!")
	
  local size = #mat
  local main_det = matrix.det(mat)

  local aux_mats = {}
  local dets = {}
  local result = {}
  for i = 1, size do
    -- Construct the auxiliary matrixes
    aux_mats[i] = matrix.copy(mat)
    for j = 1, size do
      aux_mats[i][j][i] = vec[j]
    end

    -- Calculate the auxiliary determinants
    dets[i] = matrix.det(aux_mats[i])

    -- Calculate results
    result[i] = dets[i]/main_det
  end

  return result
end

-----------------------------------------------

local A = {{ 2, -1,  5,  1},
           { 3,  2,  2, -6},
           { 1,  3,  3, -1},
           { 5, -2, -3,  3}}
local b = {-3, -32, -47, 49}

local result = cramer(A, b)
print("Result: " .. table.concat(result, ", "))
