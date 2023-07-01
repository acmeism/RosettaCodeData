begin
    % create the compound data type %
    record Point( real x, y );
    % declare a Point variable %
    reference(Point) p;
    % assign a value to p %
    p := Point( 1, 0.5 );
    % access the fields of p - note Algol W uses x(p) where many languages would use p.x %
    write( x(p), y(p) )
end.
