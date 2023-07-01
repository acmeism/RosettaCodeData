coinsert'jgl2' [ require'gl2'

MESSAGE        =: 'Hello World! '
TIMER_INTERVAL =: 0.5 * 1000                                          NB. Milliseconds
DIRECTION      =: -1                                                  NB. Initial direction is right -->

ANIM           =: noun define
  pc anim closeok;pn "Basic Animation in J";
  minwh 350 5;
  cc isi isigraph flush;
  pcenter;pshow;
)

anim_run        =: verb def 'wd ANIM,''; ptimer '',":TIMER_INTERVAL'  NB. Set form timer
anim_timer      =: verb def 'glpaint MESSAGE=: DIRECTION |. MESSAGE'  NB. Rotate MESSAGE according to DIRECTION
anim_isi_mbldown=: verb def 'DIRECTION=: - DIRECTION'                 NB. Reverse direction when user clicks
anim_close      =: verb def 'wd ''timer 0; pclose; reset'' '          NB. Shut down timer
anim_isi_paint  =:  verb define
  glclear ''                                                          NB.  Clear out old drawing
  glrgb 255 0 0
  gltextcolor''
  glfont '"courier new" 36'
  gltext MESSAGE
)

anim_run ''
