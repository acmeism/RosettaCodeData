>> answer = vpi(5)^(vpi(4)^(vpi(3)^vpi(2)));
>> numDigits = order(answer) + 1

numDigits =

      183231

>> [sprintf('%d',leadingdigit(answer,20)) '...' sprintf('%d',trailingdigit(answer,20))]
%First and Last 20 Digits

ans =

62060698786608744707...92256259918212890625
