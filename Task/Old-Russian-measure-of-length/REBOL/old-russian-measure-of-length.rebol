Rebol [
    title: "Rosetta code: Old Russian measure of length"
    file:  %Old_Russian_measure_of_length.r3
    url:   https://rosettacode.org/wiki/Old_Russian_measure_of_length
]

russion-length: function/with [
    "Convert a value from one Russian unit to another."
    value [integer! decimal!] "Value to convert"
    from  [word!]             "Source unit"
    to    [word!]             "Target unit"
][
    unless all [
       src: units/:from
       dst: units/:to
    ][  ;; unknown unit — raise an error listing all valid unit names
        do make error! reform ["Unit must be one of:" keys-of units]
    ]
    value * src / dst ;; convert via meters as the common intermediate
][
    units: #[
        arshin   0.7112    centimeter 0.01      diuym    0.0254
        fut      0.3048    kilometer  1000.0    liniya   0.00254
        meter    1.0       milia      7467.6    piad     0.1778
        sazhen   2.1336    tochka     0.000254  vershok  0.04445
        versta   1066.8
    ]
]

russion-units: [
    arshin centimeter diuym fut kilometer liniya
    meter milia piad sazhen tochka vershok versta
]

print as-yellow "  1 meter to:"
foreach unit russion-units [
    printf [-10 ": "][unit russion-length 1 'meter unit]
]
print ""
print as-yellow "  1 versta to:"
foreach unit russion-units [
    printf [-10 ": "] [unit russion-length 1 'versta unit]
]
