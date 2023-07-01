/* OLE_automation.wren */

class Ole {
    foreign static coInitialize(p)
    foreign static coUninitialize()
}

class OleUtil {
    static createObject(programID) {
        return IUnknown.new(programID)
    }

    foreign static putProperty(disp, name, param)
    foreign static mustGetProperty(disp, name)
    foreign static mustCallMethod(disp, name)
    foreign static mustCallMethod2(disp, name, param)
}

foreign class GUID {
    construct new(guid) {}
}

var IID_DISPATCH = GUID.new("{00020400-0000-0000-C000-000000000046}")

foreign class IUnknown {
    construct new(programID) {}

    foreign queryInterface(iid, name)
    foreign static release(name)
}

class Time {
    foreign static sleep(secs)
}

Ole.coInitialize(0)
var unknown = OleUtil.createObject("Word.application")
var word = unknown.queryInterface(IID_DISPATCH, "word")
OleUtil.putProperty(word, "Visible", true)
var documents  = OleUtil.mustGetProperty(word, "Documents")
var document   = OleUtil.mustCallMethod(documents, "Add")
var content    = OleUtil.mustGetProperty(document, "Content")
var paragraphs = OleUtil.mustGetProperty(content, "Paragraphs")
var paragraph  = OleUtil.mustCallMethod(paragraphs, "Add")
var range      = OleUtil.mustGetProperty(paragraph, "Range")

OleUtil.putProperty(range, "Text", "This is a Rosetta Code test document.")

Time.sleep(10)

OleUtil.putProperty(document, "Saved", true)
OleUtil.mustCallMethod2(document, "Close", false)
OleUtil.mustCallMethod(word, "Quit")
IUnknown.release(word)

Ole.coUninitialize()
