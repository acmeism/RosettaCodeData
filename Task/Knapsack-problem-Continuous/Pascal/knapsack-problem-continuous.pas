program Knapsack;
{$mode delphi}
uses
  SysUtils, Math, Generics.Collections, Generics.Defaults;

type
  TItem = record
    Name: string;
    Weight, Value, Price: Double;
    constructor Make(const n: string; w, v: Double);
  end;

constructor TItem.Make(const n: string; w, v: Double);
begin
  Name := n;
  Weight := w;
  Value := v;
  Price := v/w;
end;

function ItemCmp(constref L, R: TItem): Integer;
begin
  Result := CompareValue(R.Price, L.Price);
end;

var
  Items: array of TItem;
  MaxWeight: Double;
  I: Integer;
begin
  Items := [
    TItem.Make('beef',    3.8, 36),
    TItem.Make('pork',    5.4, 43),
    TItem.Make('ham',     3.6, 90),
    TItem.Make('greaves', 2.4, 45),
    TItem.Make('flitch',  4.0, 30),
    TItem.Make('brawn',   2.5, 56),
    TItem.Make('welt',    3.7, 67),
    TItem.Make('salami',  3.0, 95),
    TItem.Make('sausage', 5.9, 98)
  ];
  TArrayHelper<TItem>.Sort(Items, TComparer<TItem>.Construct(ItemCmp));
  MaxWeight := 15.0;
  I := 0;
  repeat
    Items[I].Weight := Min(Items[I].Weight, MaxWeight);
    MaxWeight := MaxWeight - Items[I].Weight;
    WriteLn(Format('%-8s %.1f kg', [Items[I].Name, Items[I].Weight]));
    Inc(I);
  until (MaxWeight <= 0)or(I = Length(Items));
end.
