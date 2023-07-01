' Shoelace formula for polygonal area - VBScript
    Dim points, x(),y()
    points = Array(3,4, 5,11, 12,8, 9,5, 5,6)
    n=(UBound(points)+1)\2
    Redim x(n+1),y(n+1)
    j=0
    For i = 1 To n
        x(i)=points(j)
        y(i)=points(j+1)
        j=j+2
    Next 'i
    x(i)=points(0)
    y(i)=points(1)
    For i = 1 To n
        area = area + x(i)*y(i+1) - x(i+1)*y(i)
    Next 'i
    area = Abs(area)/2
    msgbox area,,"Shoelace formula"
