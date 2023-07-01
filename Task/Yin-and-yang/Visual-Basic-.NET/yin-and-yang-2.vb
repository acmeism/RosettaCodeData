Imports System.IO

' Yep, VB.NET can import XML namespaces. All literals have xmlns changed, while xmlns:xlink is only
' declared in literals that use it directly (e.g. the output of this program has it defined in both
' of the <use /> tags and not the root, <svg />).
Imports <xmlns="http://www.w3.org/2000/svg">
Imports <xmlns:xlink="http://www.w3.org/1999/xlink">

Module Program
    Sub Main()
        Dim doc =
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg version="1.1" width="30" height="30">
    <defs>
        <g id="y">
            <circle cx="0" cy="0" r="200" stroke="black"
                fill="white" stroke-width="1"/>
            <path d="M0 -200 A 200 200 0 0 0 0 200 100 100 0 0 0 0 0 100 100 0 0 1 0 -200 z" fill="black"/>
            <circle cx="0" cy="100" r="33" fill="white"/>
            <circle cx="0" cy="-100" r="33" fill="black"/>
        </g>
    </defs>
</svg>

        ' XML literals don't support DTDs.
        Dim type As New XDocumentType(name:="svg", publicId:="-//W3C//DTD SVG 1.1//EN", systemId:="http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd", internalSubset:=Nothing)
        doc.AddFirst(type)

        Dim draw_yinyang =
            Sub(trans As Double, scale As Double) doc.Root.Add(<use xlink:href="#y" transform=<%= $"translate({trans},{trans}) scale({scale})" %>/>)

        draw_yinyang(20, 0.05)
        draw_yinyang(8, 0.02)

        Using s = Console.OpenStandardOutput(),
              sw As New StreamWriter(s)
            doc.Save(sw, SaveOptions.OmitDuplicateNamespaces)
            sw.WriteLine()
        End Using
    End Sub
End Module
