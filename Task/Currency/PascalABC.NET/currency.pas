##
var items := dict(arr(('hamburger', (decimal(5.5), decimal(4000000000000000))),
                      ('milkshake', (decimal(2.86), decimal(2)))));
var tax_rate := decimal(0.0765);
var total_before_tax := decimal(0);

foreach var item in items.keys do
begin
  var (price, quant) := items[item];
  var ext := price * quant;
  total_before_tax := total_before_tax + ext;
end;
WritelnFormat('Total before tax {0:f2}', total_before_tax);

var tax := tax_rate * total_before_tax;
WritelnFormat('Tax               {0:f2}', tax);

var total := total_before_tax + tax;
WritelnFormat('Total with tax   {0:f2}', total);
