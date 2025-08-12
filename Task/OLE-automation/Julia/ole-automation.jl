using PyCall

function demoCOM()
    # Import Python's win32com.client and time modules
    win32com = pyimport("win32com.client")

    # Initialize COM
    win32com.CoInitialize()

    # Create Word.Application object
    word = win32com.Dispatch("Word.Application")

    # set up new document
    word.Visible = true
    documents = word.Documents
    document = documents.Add()
    content = document.Content
    paragraphs = content.Paragraphs

    # add the new paragraph of text
    paragraph = paragraphs.Add()
    rnge = paragraph.Range
    rnge.Text = "This is a Rosetta Code test document."

    # wait for Windows to run the requests, then close
    sleep(5)
    document.Saved = true
    document.Close(false)

    word.Quit()
    win32com.CoUninitialize()
end

demoCOM()
