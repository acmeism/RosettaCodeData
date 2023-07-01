USING: accessors assocs colors.constants kernel sequences ui
ui.gadgets ui.gadgets.charts ui.gadgets.charts.lines ;

chart new { { 0 9 } { 0 180 } } >>axes
line new COLOR: blue >>color
9 <iota> { 2.7 2.8 31.4 38.1 58 76.2 100.5 130 149.3 180 } zip
>>data add-gadget "Coordinate pairs" open-window
