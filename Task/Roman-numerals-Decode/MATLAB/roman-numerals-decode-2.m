romanNumbers = {'MMMCMXCIX', 'XLVIII', 'MMVIII'};
for n = 1 : numel(romanNumbers)
  fprintf('%10s = %4d\n',romanNumbers{n}, rom2dec(romanNumbers{n}));
end
