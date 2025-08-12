begin % Knapsack problem: Continuous - based on the Algol 68 sample, which is based on the EasyLang sample %

    record Item ( string(12) name; real weight, cost );
    real procedure price ( reference(Item) value a ) ; cost(a) / weight(a);
    integer MAX_ITEMS;
    MAX_ITEMS := 9;

    begin
        reference(Item) array sackItems ( 1 :: MAX_ITEMS );
        real                  maxWeight;

        sackItems( 1 ) := Item( "beef",    3.8, 36 );sackItems( 2 ) := Item( "pork",    5.4, 43 );
        sackItems( 3 ) := Item( "ham",     3.6, 90 );sackItems( 4 ) := Item( "greaves", 2.4, 45 );
        sackItems( 5 ) := Item( "flitch",  4.0, 30 );sackItems( 6 ) := Item( "brawn",   2.5, 56 );
        sackItems( 7 ) := Item( "welt",    3.7, 67 );sackItems( 8 ) := Item( "salami",  3.0, 95 );
        sackItems( 9 ) := Item( "sausage", 5.9, 98 );

        for p := 1 until MAX_ITEMS - 1 do begin
            for q := p + 1 until MAX_ITEMS do begin
                if price( sackItems( q ) ) > price( sackItems( p ) ) then begin
                    reference(Item) t;
                    t              := sackItems( p );
                    sackItems( p ) := sackItems( q );
                    sackItems( q ) := t
                end if_price_of_q_gt_price_of_p
            end for_q
        end for_p;
        maxWeight := 15;
        for p := 1 until MAX_ITEMS do begin
            real w;
            w := if weight(sackItems(p)) > maxWeight then maxWeight else weight(sackItems(p));
            write( s_w := 0, r_format := "A", r_w := 6, r_d := 2, w, " kg ", name(sackItems(p)) );
            maxWeight := maxWeight - w;
            if maxWeight <= 0 then goto endSack
        end for_p ;
endSack:
    end
end.
