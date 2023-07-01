(import '[java.io File]
        '[javax.imageio ImageIO]
        '[java.awt Color]
        '[java.awt.image BufferedImage]))

(defn rgb-to-gray [color-image]
  (let [width (.getWidth color-image)]
    (partition width
               (for [x (range width)
                     y (range (.getHeight color-image))]
                 (let [rgb (.getRGB color-image x y)
                       rgb-object (new Color rgb)
                       r (.getRed rgb-object)
                       g (.getGreen rgb-object)
                       b (.getBlue rgb-object)
                       a (.getAlpha rgb-object)]
                   ;Compute the grayscale value an return it: L = 0.2126·R + 0.7152·G + 0.0722·B
                   (+ (* r 0.2126) (* g 0.7152) (* b 0.0722)))))))


(defn write-matrix-to-image [matrix filename]
  (ImageIO/write
   (let [height (count matrix)
         width (count (first matrix))
         output-image (new BufferedImage width height BufferedImage/TYPE_BYTE_GRAY)]
     (doseq [row-index    (range height)
             column-index (range width)]
       (.setRGB output-image column-index row-index (.intValue (nth (nth matrix row-index) column-index))))
     output-image)
   "png"
   (new File filename)))

(println
  (write-matrix-to-image
    (rgb-to-gray
      (ImageIO/read (new File "test.jpg")))
    "test-gray-cloj.png"))
