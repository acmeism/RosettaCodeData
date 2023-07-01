type 'a DLElm = {
    mutable prev: 'a DLElm option
    data: 'a
    mutable next: 'a DLElm option
}
