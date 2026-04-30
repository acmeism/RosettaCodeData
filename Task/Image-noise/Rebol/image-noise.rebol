Rebol [
    title: "Rosetta code: Image noise"
    file:  %Image_noise.r3
    url:   https://rosettacode.org/wiki/Image_noise
    needs: 3.15.0 ; or something like that
    note: {
        This script so far works only on Windows.
        GUI is still under development.
    }
]

img: make image! 320x240

;; Naive pixel randomization.
draw-frame: does [
    forall img [
        img/1: random/only [0.0.0 255.255.255]
    ]
]
;; Show FPS in the console.
update-fps: function/with [][
    frame-count: frame-count + 1
    current-time: now/time/precise
    elapsed: to decimal! current-time - last-time
    if elapsed >= 1 [
        fps: round/to frame-count / elapsed 1
        last-time: current-time
        frame-count: 0
        prin ["^MFPS:" fps ""]
    ]
][
    fps: frame-count: 0
    last-time: now/time/precise
]

gui?: on
either all [function? :view gui?] [
    ;; Open the window and register an event handler to detect closing it.
    gob: make gob! [image: img]
    win: view/no-wait gob
    handle-events [
        name: 'view-test
        priority: 100
        handler: func [event] [
            if switch event/type [
                close [true]
                key [event/key = escape]
            ][
                unhandle-events self
                unview event/window
                visible?: false
            ]
            none
        ]
    ]
    visible?: true
    print "Press ESC to exit."
    while [visible?][
        draw-frame
        show win
        update-fps
        wait 0.001
    ]
    unview win
][
    ;; When GUI is not available, just update the image a few times.
    loop 500 [
        draw-frame
        update-fps
    ]
]
print ""
