open System.Xml
open System.Xml.Schema
open System.IO

let xml = @"<root>
<!--Start of schema-->
<xs:schema id='an-element' targetNamespace='example' xmlns:mstns='example' xmlns='example' xmlns:xs='http://www.w3.org/2001/XMLSchema' attributeFormDefault='unqualified' elementFormDefault='qualified'>
  <xs:element name='an-element'>
    <xs:complexType>
      <xs:sequence minOccurs='0' maxOccurs='unbounded'>
        <xs:element name='another-element' nillable='true'>
          <xs:complexType>
            <xs:simpleContent>
              <xs:extension base='xs:string'>
                <xs:attribute name='an-attribute' form='unqualified' type='xs:boolean' />
              </xs:extension>
            </xs:simpleContent>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>
<!--End of schema-->
<an-element xmlns='example'>
    <another-element an-attribute='false'>...</another-element>
    <another-element an-attribute='wrong'>123</another-element>
</an-element>
</root>"

let validationData withWarnings =
    let errors = ref 0
    let warnings = ref 0
    fun input ->
        match input with
        | Some(msg, severity) ->
            if severity = XmlSeverityType.Error then
                errors := !errors + 1
                printfn "Validation error: %s" msg
            elif withWarnings then
                warnings := !warnings + 1
                printfn "Validation warning: %s" msg
            None
        | None ->
            if withWarnings then
                Some(dict[XmlSeverityType.Error, !errors; XmlSeverityType.Warning, !warnings])
            else
                Some(dict[XmlSeverityType.Error, !errors])

[<EntryPoint>]
let main argv =
    let withWarnings = argv.Length > 0 && argv.[0] = "-w"
    let vData = validationData withWarnings
    let validationEvent = new ValidationEventHandler(fun _ e ->
        vData (Some(e.Message, e.Severity)) |> ignore)
    let settings = new XmlReaderSettings()
    settings.ValidationType <- ValidationType.Schema
    settings.ValidationEventHandler.AddHandler(validationEvent)
    settings.ValidationFlags <- settings.ValidationFlags ||| XmlSchemaValidationFlags.ProcessInlineSchema ||| XmlSchemaValidationFlags.ReportValidationWarnings
    let reader = XmlReader.Create(new StringReader(xml), settings);
    while reader.Read() do ()
    printfn "%A" (Seq.toList (vData None).Value)
    0
