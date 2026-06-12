function nktg(x, v, m, dm_dt) {
  const p = m * v;
  const nktg1 = x * p;
  const nktg2 = dm_dt * p;
  const stability = ["Moving toward stable state",
                     "Stable equilibrium",
                     "Moving away from stable state"];
  const massvariation = ["Mass variation resists movement",
                         "No mass variation effect",
                         "Mass variation supports movement"];
  const tendency1 = stability[Math.sign(nktg1) + 1];
  const tendency2 = massvariation[Math.sign(nktg2) + 1];
  return {"p": p,
          "NKTg1": nktg1,
          "NKTg2": nktg2,
          "Tendency (stability)": tendency1,
          "Tendency (mass variation)": tendency2};
}

console.log(nktg(2, 3, 4, -0.5));
