#!/bin/python
from __future__ import print_function
from scipy import signal
import matplotlib.pyplot as plt

if __name__=="__main__":
	sig = [-0.917843918645,0.141984778794,1.20536903482,0.190286794412,-0.662370894973,-1.00700480494,
		-0.404707073677,0.800482325044,0.743500089861,1.01090520172,0.741527555207,
		0.277841675195,0.400833448236,-0.2085993586,-0.172842103641,-0.134316096293,
		0.0259303398477,0.490105989562,0.549391221511,0.9047198589]

	#Create an order 3 lowpass butterworth filter
	#Generated using b, a = signal.butter(3, 0.5)
	a = [1.00000000, -2.77555756e-16, 3.33333333e-01, -1.85037171e-17]
	b = [0.16666667, 0.5, 0.5, 0.16666667]

	#Apply the filter to signal
	filt = signal.lfilter(b, a, sig)
	print (filt)

	plt.plot(sig, 'b')
	plt.plot(filt, 'r--')
	plt.show()
