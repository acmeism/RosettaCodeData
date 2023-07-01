def svg:
  "<svg width='100%' height='100%' version='1.1'
        xmlns='http://www.w3.org/2000/svg'
	xmlns:xlink='http://www.w3.org/1999/xlink'>" ;

def draw_yinyang(x; scale):
  "<use xlink:href='#y' transform='translate(\(x),\(x)) scale(\(scale))'/>";

def define_yinyang:
  "<defs>
    <g id='y'>
        <circle cx='0' cy='0' r='200' stroke='black'
         fill='white' stroke-width='1'/>
        <path d='M0 -200 A 200 200 0 0 0 0 200
              100 100 0 0 0 0 0 100 100 0 0 1 0 -200
  		 z' fill='black'/>
        <circle cx='0' cy='100' r='33' fill='white'/>
        <circle cx='0' cy='-100' r='33' fill='black'/>
    </g>
  </defs>" ;

def draw:
  svg,
    define_yinyang,
    draw_yinyang(20; .05),
    draw_yinyang(8 ; .02),
  "</svg>" ;

draw
