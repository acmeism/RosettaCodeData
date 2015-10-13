with
function nl ( s in varchar2 )
return varchar2
is
begin
        return chr(10) || s;
end nl;
function v ( d number, x number, g in varchar2 )
return varchar2
is
begin
        return
        case when d >= x then nl (g) end;
end v;
select 'On the '
        || case level
        when 1 then 'first'
        when 2 then 'second'
        when 3 then 'third'
        when 4 then 'fourth'
        when 5 then 'fifth'
        when 6 then 'sixth'
        when 7 then 'seventh'
        when 8 then 'eighth'
        when 9 then 'ninth'
        when 10 then 'tenth'
        when 11 then 'eleventh'
        when 12 then 'twelfth'
        end
        || ' of Christmas,'
        || nl( 'My true love gave to me:')
        || v ( level, 12, 'Twelve drummers drumming' )
        || v ( level, 11, 'Eleven pipers piping' )
        || v ( level, 10, 'Ten lords a-leaping' )
        || v ( level, 9, 'Nine ladies dancing' )
        || v ( level, 8, 'Eight maids a-milking' )
        || v ( level, 7, 'Seven swans a-swimming' )
        || v ( level, 6, 'Six geese a-laying' )
        || v ( level, 5, 'Five golden rings!' )
        || v ( level, 4, 'Four calling birds' )
        || v ( level, 3, 'Three French hens' )
        || v ( level, 2, 'Two turtle doves' )
        || v ( level, 1, case level when 1 then 'A' else 'And a' end || ' partridge in a pear tree.' )
        || nl(null)
        "The Twelve Days of Christmas"
from dual
connect by level <= 12
/
