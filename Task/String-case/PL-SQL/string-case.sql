declare
    vc  VARCHAR2(40) := 'alphaBETA';
    ivc VARCHAR2(40);
    lvc VARCHAR2(40);
    uvc VARCHAR2(40);
begin
    ivc := INITCAP(vc); -- 'Alphabeta'
    lvc := LOWER(vc);   -- 'alphabeta'
    uvc := UPPER(vc);   -- 'ALPHABETA'
end;
