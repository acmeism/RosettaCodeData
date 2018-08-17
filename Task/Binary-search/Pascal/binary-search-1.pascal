function binary_search(element: real; list: array of real): integer;
var
    l, m, h: integer;
begin
    l := Low(list);
    h := High(list);
    binary_search := -1;
    while l <= h do
    begin
        m := (l + h) div 2;
        if list[m] > element then
        begin
            h := m - 1;
        end
        else if list[m] < element then
        begin
            l := m + 1;
        end
        else
        begin
            binary_search := m;
            break;
        end;
    end;
end;
