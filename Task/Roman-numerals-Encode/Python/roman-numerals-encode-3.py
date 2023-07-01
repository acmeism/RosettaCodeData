roman =        "MDCLXVmdclxvi"; # UPPERCASE for thousands #
adjust_roman = "CCXXmmccxxii";
arabic =       (1000000, 500000, 100000, 50000, 10000, 5000, 1000, 500, 100, 50, 10, 5, 1);
adjust_arabic = (100000, 100000,  10000, 10000,  1000, 1000,  100, 100,  10, 10,  1, 1, 0);

def arabic_to_roman(dclxvi):
  org = dclxvi; # 666 #
  out = "";
  for scale,arabic_scale  in enumerate(arabic):
    if org == 0: break
    multiples = org / arabic_scale;
    org -= arabic_scale * multiples;
    out += roman[scale] * multiples;
    if org >= -adjust_arabic[scale] + arabic_scale:
      org -= -adjust_arabic[scale] + arabic_scale;
      out +=  adjust_roman[scale] +  roman[scale]
  return out

if __name__ == "__main__":
  test = (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,30,40,50,60,69,70,
     80,90,99,100,200,300,400,500,600,666,700,800,900,1000,1009,1444,1666,1945,1997,1999,
     2000,2008,2500,3000,4000,4999,5000,6666,10000,50000,100000,500000,1000000);
  for val in test:
    print '%d - %s'%(val, arabic_to_roman(val))
