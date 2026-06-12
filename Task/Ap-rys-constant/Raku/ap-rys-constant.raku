sub postfix:<!> (Int $n) { (constant f = 1, |[\×] 1..*)[$n] }

say 'Actual value to 100 decimal places:';
say '1.2020569031595942853997381615114499907649862923404988817922715553418382057863130901864558736093352581';

say "\nFirst 1000 terms of ζ(3) truncated to 100 decimal places. (accurate to 6 decimal places):";
say (1..1000).map({FatRat.new: 1, .³}).sum.substr: 0, 102;

say "\nFirst 158 terms of Markov / Apéry representation truncated to 100 decimal places:";
say (5/2 × (1..158).map( -> \k { (-1)**(k-1) × FatRat.new: k!², ((2×k)! × k³) } ).sum).substr: 0, 102;

say "\nFirst 20 terms of Wedeniwski representation truncated to 100 decimal places:";
say (1/24 × ((^20).map: -> \k {
    (-1)**k × FatRat.new: (2×k+1)!³ × (2×k)!³ × k!³ × (126392×k⁵ + 412708×k⁴ + 531578×k³ + 336367×k² + 104000×k + 12463), (3×k+2)! × (4×k+3)!³
}).sum).substr: 0, 102;
