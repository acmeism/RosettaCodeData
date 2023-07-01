LeftRec := RECORD
  UNSIGNED1 Age;
  STRING6   Name;
END;

LeftFile := DATASET([{27,'Jonah'},{18,'Alan'},{28,'Glory'},{18,'Popeye'},{28,'Alan'}],LeftRec);

RightRec := RECORD
  STRING6   Name;
  STRING7   Nemesis;
END;
	
RightFile := DATASET([{'Jonah','Whales'},{'Jonah','Spiders'},{'Alan','Ghosts'},{'Alan','Zombies'},{'Glory','Buffy'}],
                     RightRec);
										
HashJoin := JOIN(LeftFile,RightFile,Left.Name = RIGHT.Name,HASH);

HashJoin;


//The HASH JOIN is built-in to the ECL JOIN by using the HASH JOIN Flag

/*
OUTPUT:
Age Name  Nemesis
18  Alan  Ghosts
18  Alan  Zombies
28  Alan  Ghosts
28  Alan  Zombies
28  Glory Buffy
27  Jonah Whales
27  Jonah Spiders
*/
