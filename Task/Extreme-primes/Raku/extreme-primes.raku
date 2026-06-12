use Lingua::EN::Numbers;

say $_».&comma».fmt("%7s").batch(10).join: "\n" for
(([\+] (^∞).grep: &is-prime).grep: &is-prime)[^30,999,1999,2999,3999,4999];
