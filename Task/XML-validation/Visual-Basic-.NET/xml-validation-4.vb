Module Constants
    Function GetDocument() As XDocument
        Return _
        <?xml version="1.0"?>
        <an-element xmlns="example">
            <another-element an-attribute="false">...</another-element>
            <another-element an-attribute="wrong"> 123</another-element>
        </an-element>
    End Function

    Function GetSchema() As XDocument
        Return _
        <?xml version="1.0"?>
        <xs:schema id="an-element" targetNamespace="example" xmlns:mstns="example" xmlns="example" xmlns:xs="http://www.w3.org/2001/XMLSchema" attributeFormDefault="unqualified" elementFormDefault="qualified">
            <xs:element name="an-element">
                <xs:complexType>
                    <xs:sequence minOccurs="0" maxOccurs="unbounded">
                        <xs:element name="another-element" nillable="true">
                            <xs:complexType>
                                <xs:simpleContent>
                                    <xs:extension base="xs:string">
                                        <xs:attribute name="an-attribute" form="unqualified" type="xs:boolean"/>
                                    </xs:extension>
                                </xs:simpleContent>
                            </xs:complexType>
                        </xs:element>
                    </xs:sequence>
                </xs:complexType>
            </xs:element>
        </xs:schema>
    End Function
End Module
