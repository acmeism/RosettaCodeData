/ Angle difference between two angles
/ angledif.k

angdif: {[b1;b2]; :[(r:(b2-b1)!360.0)<-180.0;r+:360.0;r>180.0;r-:360.0];:r}
