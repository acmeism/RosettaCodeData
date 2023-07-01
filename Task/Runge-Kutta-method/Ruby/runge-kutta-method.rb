def calc_rk4(f)
  return ->(t,y,dt){
         ->(dy1   ){
         ->(dy2   ){
         ->(dy3   ){
         ->(dy4   ){ ( dy1 + 2*dy2 + 2*dy3 + dy4 ) / 6 }.call(
           dt * f.call( t + dt  , y + dy3   ))}.call(
           dt * f.call( t + dt/2, y + dy2/2 ))}.call(
           dt * f.call( t + dt/2, y + dy1/2 ))}.call(
           dt * f.call( t       , y         ))}
end

TIME_MAXIMUM, WHOLE_TOLERANCE = 10.0, 1.0e-5
T_START, Y_START, DT          =  0.0, 1.0, 0.10

def my_diff_eqn(t,y) ; t * Math.sqrt(y)                    ; end
def my_solution(t  ) ; (t**2 + 4)**2 / 16                  ; end
def  find_error(t,y) ; (y - my_solution(t)).abs            ; end
def   is_whole?(t  ) ; (t.round - t).abs < WHOLE_TOLERANCE ; end

dy = calc_rk4( ->(t,y){my_diff_eqn(t,y)} )

t, y = T_START, Y_START
while t <= TIME_MAXIMUM
  printf("y(%4.1f)\t= %12.6f \t error: %12.6e\n",t,y,find_error(t,y)) if is_whole?(t)
  t, y = t + DT, y + dy.call(t,y,DT)
end
