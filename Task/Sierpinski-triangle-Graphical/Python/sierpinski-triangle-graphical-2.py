#!/usr/bin/env python
##########################################################################################
# a very complicated version
# import necessary modules
# ------------------------
from numpy import *
import turtle

##########################################################################################
#	Functions defining the drawing actions
#       (used by the function DrawSierpinskiTriangle).
#	----------------------------------------------
def Left(turn, point, fwd, angle, turt):
	turt.left(angle)
	return [turn, point, fwd, angle, turt]
def Right(turn, point, fwd, angle, turt):
	turt.right(angle)
	return [turn, point, fwd, angle, turt]
def Forward(turn, point, fwd, angle, turt):
	turt.forward(fwd)
	return [turn, point, fwd, angle, turt]
