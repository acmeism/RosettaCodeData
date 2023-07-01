class String; def brk; split(/(?=[A-Z])/); end; end
men,drinks,colors,pets,smokes = "NorwegianGermanDaneSwedeEnglish
  MilkTeaBeerWaterCoffeeGreenWhiteRedYellowBlueZebraDogCatsHorseBirds
  PallmallDunhillBlendBluemasterPrince".delete(" \n").
  brk.each_slice(5).map{|e| e.permutation.to_a};
men.select!{|x| "Norwegian"==x[0]};
drinks.select!{|x| "Milk"==x[2]};
colors.select!{|x| x.join[/GreenWhite/]};

dis = proc{|s,*a| s.brk.map{|w| a.map{|p| p.index(w)}.
  compact[0]}.each_slice(2).map{|a,b| (a-b).abs}}

men.each{|m| colors.each{|c|
  next unless dis["RedEnglishBlueNorwegian",c,m]==[0,1]
  drinks.each{|d| next unless dis["DaneTeaCoffeeGreen",m,d,c]==[0,0]
    smokes.each{|s|
      next unless dis["YellowDunhillBluemasterBeerGermanPrince",
                      c,s,d,m]==[0,0,0]
      pets.each{|p|
        next unless dis["SwedeDogBirdsPallmallCatsBlendHorseDunhill",
                        m,p,s]==[0,0,1,1]
        x = [p,m,c,d,s].transpose
        puts "The #{x.find{|y|y[0]=="Zebra"}[1]} owns the zebra.",
          x.map{|y| y.map{|z| z.ljust(11)}.join}}}}}}
