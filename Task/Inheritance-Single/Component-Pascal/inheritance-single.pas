	TYPE
		Animal = ABSTRACT RECORD (*  *) END;
		Cat = RECORD (Animal)  (*  *) END; (* final record (cannot be extended) - by default *)
		Dog = EXTENSIBLE RECORD (Animal)  (*  *) END; (* extensible record *)
		Lab = RECORD (Dog)  (*  *) END;
		Collie = RECORD (Dog)  (*  *) END;
