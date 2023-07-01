def task:
  svg(null;null),                                                   # use the defaults
  linearGradient("gradient"; "rgb(255,255,0)"; "rgb(255,0,0)"),     # define "gradient"
  ("Goodbye, World!" | text(10; 50; {"fill": "url(#gradient)"})),   # notice how the default for "fill" is overridden
  "</svg>";

task
