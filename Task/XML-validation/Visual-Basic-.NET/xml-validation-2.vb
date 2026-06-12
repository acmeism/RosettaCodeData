    Function GetValidationErrorsXmlReader(doc As XDocument, schemaSet As XmlSchemaSet, warnings As Boolean) As IList(Of ValidationEventArgs)
        GetValidationErrorsReader = New List(Of ValidationEventArgs)

        Dim settings As New XmlReaderSettings()
        With settings
            .ValidationType = ValidationType.Schema
            .Schemas = schemaSet
            If warnings Then .ValidationFlags = .ValidationFlags Or XmlSchemaValidationFlags.ReportValidationWarnings
        End With

        AddHandler settings.ValidationEventHandler, Sub(sender, e) GetValidationErrorsReader.Add(e)

        Using reader = XmlReader.Create(doc.CreateReader(), settings)
            Do While reader.Read() : Loop
        End Using
    End Function
