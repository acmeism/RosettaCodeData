#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

PROC mean angle = ([]#LONG# REAL angles)#LONG# REAL:
(
  INT size = UPB angles - LWB angles + 1;
  #LONG# REAL y part := 0, x part := 0;
  FOR i FROM LWB angles TO UPB angles DO
      x part +:= #long# cos (angles[i] * #long# pi / 180);
      y part +:= #long# sin (angles[i] * #long# pi / 180)
  OD;

  #long# arc tan2 (y part / size, x part / size) * 180 / #long# pi
);

main:
(
  []#LONG# REAL angle set 1 = ( 350, 10 );
  []#LONG# REAL angle set 2 = ( 90, 180, 270, 360);
  []#LONG# REAL angle set 3 = ( 10, 20, 30);

  FORMAT summary fmt=$"Mean angle for "g" set :"-zd.ddddd" degrees"l$;
  printf ((summary fmt,"1st", mean angle (angle set 1)));
  printf ((summary fmt,"2nd", mean angle (angle set 2)));
  printf ((summary fmt,"3rd", mean angle (angle set 3)))
)
