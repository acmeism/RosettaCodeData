let author = "Author"
let xml == """
    <?xml version="1.0"?>
    <catalog>
        <book id="bk101" empty="">
            <author>\(author)</author>
            <title>XML Developer's Guide</title>
            <genre>Computer</genre>
            <price>44.95</price>
            <publish_date>2000-10-01</publish_date>
            <description>An in-depth look at creating applications with XML.</description>
        </book>
    </catalog>
    """

println(xml)