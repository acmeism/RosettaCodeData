# num=`expr $num + 1` # This may error if num is an empty string
num=`expr "$num" + 1` # The quotes are an improvement
