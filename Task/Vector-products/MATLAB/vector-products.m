%    Create a named function/subroutine/method to compute the dot product of two vectors.
        dot(a,b)
%    Create a function to compute the cross product of two vectors.
        cross(a,b)
%    Optionally create a function to compute the scalar triple product of three vectors.
        dot(a,cross(b,c))
%    Optionally create a function to compute the vector triple product of three vectors.
        cross(a,cross(b,c))
%    Compute and display: a • b
        cross(a,b)
%    Compute and display: a x b
        cross(a,b)
%    Compute and display: a • b x c, the scaler triple product.
        dot(a,cross(b,c))
%    Compute and display: a x b x c, the vector triple product.
        cross(a,cross(b,c))
