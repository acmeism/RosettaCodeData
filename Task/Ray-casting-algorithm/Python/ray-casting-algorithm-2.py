def _convert_fortran_shapes():
    point = Pt
    pts = (point(0,0), point(10,0), point(10,10), point(0,10),
           point(2.5,2.5), point(7.5,2.5), point(7.5,7.5), point(2.5,7.5),
           point(0,5), point(10,5),
           point(3,0), point(7,0), point(7,10), point(3,10))
    p = (point(5,5), point(5, 8), point(-10, 5), point(0,5), point(10,5),
         point(8,5), point(10,10) )

    def create_polygon(pts,vertexindex):
        return [tuple(Edge(pts[vertexindex[i]-1], pts[vertexindex[i+1]-1])
                       for i in range(0, len(vertexindex), 2) )]
    polys=[]
    polys += create_polygon(pts, ( 1,2, 2,3, 3,4, 4,1 ) )
    polys += create_polygon(pts, ( 1,2, 2,3, 3,4, 4,1, 5,6, 6,7, 7,8, 8,5 ) )
    polys += create_polygon(pts, ( 1,5, 5,4, 4,8, 8,7, 7,3, 3,2, 2,5 ) )
    polys += create_polygon(pts, ( 11,12, 12,10, 10,13, 13,14, 14,9, 9,11 ) )

    names = ( "square", "square_hole", "strange", "exagon" )
    polys = [Poly(name, edges)
             for name, edges in zip(names, polys)]
    print 'polys = ['
    for p in polys:
        print "  Poly(name='%s', edges=(" % p.name
        print '   ', ',\n    '.join(str(e) for e in p.edges) + '\n    )),'
    print '  ]'
 _convert_fortran_shapes()
