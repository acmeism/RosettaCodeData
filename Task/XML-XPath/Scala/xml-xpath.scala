scala> val xml: scala.xml.Elem =
     | <inventory title="OmniCorp Store #45x10^3">
     |   <section name="health">
     |     <item upc="123456789" stock="12">
     |       <name>Invisibility Cream</name>
     |       <price>14.50</price>
     |       <description>Makes you invisible</description>
     |     </item>
     |     <item upc="445322344" stock="18">
     |       <name>Levitation Salve</name>
     |       <price>23.99</price>
     |       <description>Levitate yourself for up to 3 hours per application</description>
     |     </item>
     |   </section>
     |   <section name="food">
     |     <item upc="485672034" stock="653">
     |       <name>Blork and Freen Instameal</name>
     |       <price>4.95</price>
     |       <description>A tasty meal in a tablet; just add water</description>
     |     </item>
     |     <item upc="132957764" stock="44">
     |       <name>Grob winglets</name>
     |       <price>3.56</price>
     |       <description>Tender winglets of Grob. Just add water</description>
     |     </item>
     |   </section>
     | </inventory>

scala> val firstItem = for {
     |   firstSection <- (xml \ "section").headOption
     |   firstItem <- (firstSection \ "item").headOption
     | } yield firstItem
firstItem: Option[scala.xml.Node] =
Some(<item upc="123456789" stock="12">
             <name>Invisibility Cream</name>
             <price>14.50</price>
             <description>Makes you invisible</description>
           </item>)

scala> val prices = for {
     |   section <- (xml \ "section")
     |   item <- (section \ "item")
     |   price <- (item \ "price")
     | } yield scala.math.BigDecimal(price.text)
prices: List[scala.math.BigDecimal] = List(14.50, 23.99, 4.95, 3.56)

scala> val salesTax = prices.sum * 0.05
salesTax: scala.math.BigDecimal = 2.3500

scala> println(salesTax.setScale(2, BigDecimal.RoundingMode.HALF_UP))
2.35

scala> val names = for {
     |   section <- (xml \ "section").toArray
     |   item <- (section \ "item")
     |   name <- (item \ "name")
     | } yield name.text
names: Array[String] = Array(Invisibility Cream, Levitation Salve, Blork and Freen Instameal, Grob winglets)
