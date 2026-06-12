def colors: [
    [255,   0,   0],  # red
    [255, 128,   0],  # orange
    [255, 255,   0],  # yellow
    [  0, 255,   0],  # green
    [  0,   0, 255],  # blue
    [ 75,   0, 130],  # indigo
    [128,   0, 255]   # violet
  ];

def rainbow($s):
    # ;38 is the extended foreground color code
    # ;2 indicates RGB digits follow
    def e: "\u001B";  # ESCAPE
    reduce range(0; $s|length) as $j ("";
      ($j % 7) as $i
      | . + "\(e)[38;2;\(colors[$i][0]);\(colors[$i][1]);\(colors[$i][2])m\($s[$i:$i+1])" )
    + "\(e)[0m";

rainbow("RAINBOW")
