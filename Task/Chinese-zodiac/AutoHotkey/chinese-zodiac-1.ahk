Chinese_zodiac(year){
	Animal		:= StrSplit("Rat,Ox,Tiger,Rabbit,Dragon,Snake,Horse,Goat,Monkey,Rooster,Dog,Pig", ",")
	AnimalCh	:= StrSplit("鼠牛虎兔龍蛇馬羊猴鸡狗豬")
	AnimalName	:= StrSplit("shǔ,niú,hǔ,tù,lóng,shé,mǎ,yáng,hóu,jī,gǒu,zhū", ",")	
	Element		:= StrSplit("Wood,Fire,Earth,Metal,Water", ",")
	ElementCh	:= StrSplit("木火土金水")
	ElementName	:= StrSplit("mù,huǒ,tǔ,jīn,shuǐ", ",")	
	StemCh		:= StrSplit("甲乙丙丁戊己庚辛壬癸")
	StemName	:= StrSplit("jiă,yĭ,bĭng,dīng,wù,jĭ,gēng,xīn,rén,gŭi", ",")
	BranchCh	:= StrSplit("子丑寅卯辰巳午未申酉戌亥")
	BranchName	:= StrSplit("zĭ,chŏu,yín,măo,chén,sì,wŭ,wèi,shēn,yŏu,xū,hài", ",")
	Mod10	:= Mod(year-4, 10)+1
	Mod12	:= Mod(year-4, 12)+1
	A	:= Animal[Mod12],
	Ac	:= AnimalCh[Mod12]
	An	:= AnimalName[Mod12]
	E	:= Element[Floor(Mod(year-4, 10)/2+1)]
	Ec	:= ElementCh[Floor(Mod(year-4, 10)/2+1)]
	En	:= ElementName[Floor(Mod(year-4, 10)/2+1)]
	YY	:= Mod(year-4, 2)=1 ? "yīn 阴" : "yáng 阳"
	Yr	:= Mod(year-4, 60)+1 "/60"
	S	:= StemCh[Mod10]
	Sn	:= StemName[Mod10]
	B	:= BranchCh[Mod12]
	Bn	:= BranchName[Mod12]
	return year "`t" S B " " Sn "-" Bn " `t" E " " Ec " " En "`t" A " " Ac " " An "`t" YY " " Yr
}
