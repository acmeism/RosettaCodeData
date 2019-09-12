package main

import (
    "time"
    ole "github.com/go-ole/go-ole"
    "github.com/go-ole/go-ole/oleutil"
)

func main() {
    ole.CoInitialize(0)
    unknown, _ := oleutil.CreateObject("Word.Application")
    word, _ := unknown.QueryInterface(ole.IID_IDispatch)
    oleutil.PutProperty(word, "Visible", true)
    documents := oleutil.MustGetProperty(word, "Documents").ToIDispatch()
    document := oleutil.MustCallMethod(documents, "Add").ToIDispatch()
    content := oleutil.MustGetProperty(document, "Content").ToIDispatch()
    paragraphs := oleutil.MustGetProperty(content, "Paragraphs").ToIDispatch()
    paragraph := oleutil.MustCallMethod(paragraphs, "Add").ToIDispatch()
    rnge := oleutil.MustGetProperty(paragraph, "Range").ToIDispatch()
    oleutil.PutProperty(rnge, "Text", "This is a Rosetta Code test document.")

    time.Sleep(10 * time.Second)

    oleutil.PutProperty(document, "Saved", true)
    oleutil.CallMethod(document, "Close", false)
    oleutil.CallMethod(word, "Quit")
    word.Release()

    ole.CoUninitialize()
}
