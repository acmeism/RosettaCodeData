nktg <- function(x, v, m, dm_dt) {
  p <- m*v
  nktg1 <- x*p
  nktg2 <- dm_dt*p
  tendency1 <- switch(sign(nktg1)+2,
                      "Moving toward stable state",
                      "Stable equilibrium",
                      "Moving away from stable state")
  tendency2 <- switch(sign(nktg2)+2,
                      "Mass variation resists movement",
                      "No mass variation effect",
                      "Mass variation supports movement")
  list("p" = p,
       "NKTg1" = nktg1,
       "NKTg2" = nktg2,
       "Tendency1" = tendency1,
       "Tendency2" = tendency2)
}

nktg(2, 3, 4, -0.5)
