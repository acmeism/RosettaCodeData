∇ WindowedApplication

⍝ define a form with a label and a button
'Frm'⎕WC'Form' 'Clicks' (40 35) (10 15)
'Lbl'Frm.⎕WC'Label' 'There have been no clicks yet.' (10 10)
'Btn'Frm.⎕WC'Button' 'Click Me' (35 35) (25 25) ('Event' 'Select' 'Click')

⍝ callback function
Frm.Clicks←0
Frm.Click←{
    Clicks+←1
    p0←(1+Clicks=1)⊃'have' 'has'
    p1←(1+Clicks=1)⊃'clicks' 'click'
    Lbl.Value←'There ',p0,' been ',(⍕Clicks),' ',p1,'.'
}

∇
