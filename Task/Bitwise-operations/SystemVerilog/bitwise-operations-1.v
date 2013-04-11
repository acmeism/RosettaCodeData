program main;

  initial begin
    bit [52:0] a,b,c;
    a = 53'h123476547890fe;
    b = 53'h06453bdef23ca6;

    c = a & b; $display("%h & %h = %h", a,b,c);
    c = a | b; $display("%h | %h = %h", a,b,c);
    c = a ^ b; $display("%h ^ %h = %h", a,b,c);
    c = ~ a;   $display("~%h = %h", a, c);

    c = a << 5; $display("%h << 5 = %h", a, c);
    c = a >> 5; $display("%h >> 5 = %h", a, c);

    c = { a[53-23:0], a[52-:23] }; $display("%h rotate-left 23 = %h", a, c);
    c = { a[1:0], a[52:2] }; $display("%h rotate-right 2 = %h", a, c);
  end

endprogram
