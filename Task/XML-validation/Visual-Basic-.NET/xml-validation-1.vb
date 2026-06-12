Option Compare Binary
Option Explicit On
Option Infer On
Option Strict On

Imports System.Xml
Imports System.Xml.Schema

Module Program
    Function GetValidationErrors(doc As XDocument, schemaSet As XmlSchemaSet) As IList(Of ValidationEventArgs)
        GetValidationErrors = New List(Of ValidationEventArgs)
        doc.Validate(schemaSet, Sub(sender, e) GetValidationErrors.Add(e))
    End Function

    Sub Main()
        ' These functions are declared in another module found below.
        Dim schema = GetSchema()
        Dim document = GetDocument()

        Dim schemaSet As New XmlSchemaSet()
        schemaSet.Add(XmlSchema.Read(schema.CreateReader(), Nothing))

        Dim errors = GetValidationErrors(document, schemaSet)
        For Each e In errors
            Console.WriteLine($"Validation {e.Severity}:{vbCrLf}{e.Message}")
        Next

        If errors.Count = 0 Then Console.WriteLine("The document is valid.")
    End Sub
End Module
