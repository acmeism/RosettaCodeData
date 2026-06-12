# syntax: GAWK -f NKTG_LAW.AWK
# converted from EasyLang
BEGIN {
    main(2,3,4,-0.5)
    exit(0)
}
function main(x,v,m,dm_dt,  nktg1,nktg2,p) {
    p = m * v
    nktg1 = x * p
    nktg2 = dm_dt * p
    if (nktg1 > 0) { tendency1 = "Moving away from stable state" }
    else if (nktg1 < 0) { tendency1 = "Moving toward stable state" }
    else { tendency1 = "Stable equilibrium" }
    if (nktg2 > 0) { tendency2 = "Mass variation supports movement" }
    else if (nktg2 < 0) { tendency2 = "Mass variation resists movement" }
    else { tendency2 = "No mass variation effect" }
    printf("p: %g\n",p)
    printf("NKTg1: %g\n",nktg1)
    printf("NKTg2: %g\n",nktg2)
    printf("Tendency1: %s\n",tendency1)
    printf("Tendency2: %s\n",tendency2)
}
