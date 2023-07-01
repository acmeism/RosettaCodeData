⍝load the library module
]load HttpCommand

⍝ define a direct function (dfn) to look up a single MAC address
vendorLookup1 ← { (HttpCommand.Get 'http://api.macvendors.com/',⍕⍵).Data }

⍝ define a traditional function to look up all the MAC addresses in a list with
⍝ a delay between calls

⍝ The header says that the function is named vendorLookup, it takes a single
⍝ parameter which we call macList, and the value of the local variable
⍝ vendors will become the function's return value
∇ vendors  ← vendorLookup macList
    ⍝ look up the first vendor and put it into an array in our return var
    vendors ← ⊆vendorLookup1 1↑macList

    ⍝ Loop over the rest of the array
    :For burger :In 1↓macList
       ⎕DL 2                              ⍝ wait 2 seconds
       vendors ⍪← ⊆vendorLookup1 burger   ⍝ then look up the next vendor and append
    :EndFor
∇

⍝ demo data
macList ←  '88:53:2E:67:07:BE' 'D4:F4:6F:C9:EF:8D' 'FC:FB:FB:01:FA:21'
macList ⍪← '4c:72:b9:56:fe:bc' '00-14-22-01-23-45'

⍝ look up the vendors (takes a while with the 2-second delay between lookups)
vendorList ← vendorLookup macList

⍝ the result is an array (a 1-row by N-column matrix). to print out one vendor
⍝ per line, we reshape it to be N rows by 1 column instead.
{(1⌷⍴⍵) 1 ⍴ ⍵} vendorList
