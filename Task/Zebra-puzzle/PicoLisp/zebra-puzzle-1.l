(be match (@House @Person @Drink @Pet @Cigarettes)
   (permute (red blue green yellow white) @House)
   (left-of @House white  @House green)

   (permute (Norwegian English Swede German Dane) @Person)
   (has @Person English  @House red)
   (equal @Person (Norwegian . @))
   (next-to @Person Norwegian  @House blue)

   (permute (tea coffee milk beer water) @Drink)
   (has @Drink tea  @Person Dane)
   (has @Drink coffee  @House green)
   (equal @Drink (@ @ milk . @))

   (permute (dog birds cats horse zebra) @Pet)
   (has @Pet dog  @Person Swede)

   (permute (Pall-Mall Dunhill Blend Blue-Master Prince) @Cigarettes)
   (has @Cigarettes Pall-Mall  @Pet birds)
   (has @Cigarettes Dunhill  @House yellow)
   (next-to @Cigarettes Blend  @Pet cats)
   (next-to @Cigarettes Dunhill  @Pet horse)
   (has @Cigarettes Blue-Master  @Drink beer)
   (has @Cigarettes Prince  @Person German)

   (next-to @Drink water  @Cigarettes Blend) )

(be has ((@A . @X) @A (@B . @Y) @B))
(be has ((@ . @X) @A (@ . @Y) @B)
   (has @X @A @Y @B) )

(be right-of ((@A . @X) @A (@ @B . @Y) @B))
(be right-of ((@ . @X) @A (@ . @Y) @B)
   (right-of @X @A @Y @B) )

(be left-of ((@ @A . @X) @A (@B . @Y) @B))
(be left-of ((@ . @X) @A (@ . @Y) @B)
   (left-of @X @A @Y @B) )

(be next-to (@X @A @Y @B) (right-of @X @A @Y @B))
(be next-to (@X @A @Y @B) (left-of @X @A @Y @B))
