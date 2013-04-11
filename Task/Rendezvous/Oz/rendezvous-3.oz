  Main = {NewActiveSync Printer init(id:1 backup:Reserve)}
  Reserve = {NewActiveSync Printer init(id:2)}
in
  %% task Humpty Dumpty
  thread
     try
	{Main print("Humpty Dumpty sat on a wall.")}
	{Main print("Humpty Dumpty had a great fall.")}
	{Main print("All the king's horses and all the king's men")}
	{Main print("Couldn't put Humpty together again.")}
     catch outOfInk then
	{System.showInfo "      Humpty Dumpty out of ink!"}
     end
  end

  %% task Mother Goose
  thread
     try
	{Main print("Old Mother Goose")}
	{Main print("When she wanted to wander,")}
	{Main print("Would ride through the air")}
	{Main print("On a very fine gander.")}
	{Main print("Jack's mother came in,")}
	{Main print("And caught the goose soon,")}
	{Main print("And mounting its back,")}
	{Main print("Flew up to the moon.")}
     catch outOfInk then
	{System.showInfo "      Mother Goose out of ink!"}
     end
  end
