include get.e

sequence array
integer height,width,i,j

height = floor(prompt_number("Enter height: ",{}))
width = floor(prompt_number("Enter width: ",{}))

array = repeat(repeat(0,width),height)

i = floor(height/2+0.5)
j = floor(width/2+0.5)
array[i][j] = height + width

printf(1,"array[%d][%d] is %d\n", {i,j,array[i][j]})
