/*REXX pgm calculates the total area of (possibly overlapping) circles. */
parse arg box .                        /*obtain possible #boxes from CL.*/
if box==''  then box=-500              /*allow specification of # boxes,*/
verbose= box<0                         /*set a flag if in verbose mode. */
box=abs(box);       boxen=box+1        /*use  |box|  value from here on.*/
numeric digits 15                      /*ensure enough digits for points*/
                    data = ' 1.6417233788   1.6121789534  0.0848270516',
                           '-1.4944608174   1.2077959613  1.1039549836',
                           ' 0.6110294452  -0.6907087527  0.9089162485',
                           ' 0.3844862411   0.2923344616  0.2375743054',
                           '-0.2495892950  -0.3832854473  1.0845181219',
                           ' 1.7813504266   1.6178237031  0.8162655711',
                           '-0.1985249206  -0.8343333301  0.0538864941',
                           '-1.7011985145  -0.1263820964  0.4776976918',
                           '-0.4319462812   1.4104420482  0.7886291537',
                           ' 0.2178372997  -0.9499557344  0.0357871187',
                           '-0.6294854565  -1.3078893852  0.7653357688',
                           ' 1.7952608455   0.6281269104  0.2727652452',
                           ' 1.4168575317   1.0683357171  1.1016025378',
                           ' 1.4637371396   0.9463877418  1.1846214562',
                           '-0.5263668798   1.7315156631  1.4428514068',
                           '-1.2197352481   0.9144146579  1.0727263474',
                           '-0.1389358881   0.1092805780  0.7350208828',
                           ' 1.5293954595   0.0030278255  1.2472867347',
                           '-0.5258728625   1.3782633069  1.3495508831',
                           '-0.1403562064   0.2437382535  1.3804956588',
                           ' 0.8055826339  -0.0482092025  0.3327165165',
                           '-0.6311979224   0.7184578971  0.2491045282',
                           ' 1.4685857879  -0.8347049536  1.3670667538',
                           '-0.6855727502   1.6465021616  1.0593087096',
                           ' 0.0152957411   0.0638919221  0.9771215985'
circles=words(data)%3      /*    ══x══          ══y══       ══radius══  */
if verbose  then say 'There are'  circles  "circles."
parse var data minX minY . 1 maxX maxY .   /*assign some min & max vals.*/

            do j=1  for circles; _=j*3-2   /*assign circles with datam. */
            @x.j=word(data,_);  @y.j=word(data,_+1)
                                @r.j=word(data,_+2)/1; @rr.j=@r.j**2
            minX=min(minX, @x.j-@r.j);  maxX=max(maxX, @x.j+@r.j)
            minY=min(minY, @y.j-@r.j);  maxY=max(maxY, @y.j+@r.j)
            end   /*j*/

  do   m=1   for circles                   /*sort the circles by radii. */
    do n=m+1 to  circles                   /*sort by  descending radii. */
    if @r.n>@r.m then parse  value  @x.n @y.n @r.n   @x.m @y.m @r.m  with,
                                    @x.m @y.m @r.m   @x.n @y.n @r.n
    end   /*n*/                            /* [↑]    Higher?  Then swap.*/
  end     /*m*/

dx=(maxX-minX) / box
dy=(maxY-minY) / box
w=length(circles);   #in=0                 /*#in►fully contained circles*/
isIn@ = ' is contained in circle '         /* [↓] find contained circles*/

  do     j=1  for circles                  /*traipse through  J  circles*/
      do k=1  for circles                  /*   "       "     K     "   */
      if k==j | @r.j==0  then iterate      /*ignore self or zero radius.*/
      if  @y.j+@r.j > @y.k+@r.k  then iterate  /*is cir J outside cir K?*/
      if  @x.j-@r.j < @x.k-@r.k  then iterate  /* "  "  "    "     "  " */
      if  @y.j-@r.j < @y.k-@r.k  then iterate  /* "  "  "    "     "  " */
      if  @x.j+@r.j > @x.k+@r.k  then iterate  /* "  "  "    "     "  " */
      if verbose  then  say  'Circle '     right(j,w)   isIn@   right(k,w)
      @r.j=0;     #in=#in+1                /*elide this circle; bump #in*/
      end   /*k*/
  end       /*j*/                          /* [↑] elided overlapping cir*/

if #in==0  then #in='no'                   /*use gooder English.  (joke)*/
if verbose then say #in "circles are fully contained within other circles."
nC=0                                       /*number of  "new"  circles. */
           do n=1  for circles;   if @r.n==0  then iterate  /*skip if 0.*/
           nC=nC+1;  @x.nC=@x.n;  @y.nC=@y.n;  @r.nC=@r.n;  @rr.nC=@r.n**2
           end   /*n*/                     /* [↑]  elide overlapping cir*/
#=0                                        /*the count of sample points.*/
     do   row=0  for boxen;  y=minY+row*dy /*process each grid row.     */
       do col=0  for boxen;  x=minX+col*dx /*   "      "    "  column.  */
         do k=1  for nC                    /*now process each new circle*/
         if (x-@x.k)**2+(y-@y.k)**2 <= @rr.k  then  do;  #=#+1; leave; end
         end   /*k*/
       end     /*col*/
     end       /*row*/
say
say 'The approximate area is: '   #*dx*dy   "  using"   box**2   "points."
                                       /*stick a fork in it, we're done.*/
