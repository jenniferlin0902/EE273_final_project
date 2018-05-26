*************************************************************************
*                                                                       *
*		Paramaterized PRBS7 Bit Pattern				*
*                                                                       *
*************************************************************************
*
* This subcircuit implements a voltage source supplying a PRBS7 pattern,
* a 127 bit long pseudo-random sequence. There are two complimentary
* outputs, node p and node n. The voltage levels and timing are 
* paramaterized, and the parameter definitions are as follows:
*
*	dc0     = output low  level, volts
*	dc1     = output high level, volts
*	baud    = bit time in seconds
*	latency = delay before starting pattern, seconds
*	tr      = output rise and fall time, seconds
* 
* Once started, the pattern runs continuously.
*
* Example calling sequence:
*    Xdata  p  n (bitpattern) dc0=0 dc1=1 baud=1n latency=2n tr=0.1n
* This gives a 0 to 1 volt 1 Gbit/sec sequence with 100ps rise/fall
* times that starts after a 2ns delay.
*
.SUBCKT (bitpattern) p n
En n 0 vol='dc1 + dc0 - v(p)'
Vp p 0 PWL
+ "latency + 0*baud"	dc0	"latency + 0*baud + tr"	dc1
+ "latency + 1*baud"	dc1	"latency + 1*baud + tr"	dc0
+ "latency + 6*baud"	dc0	"latency + 6*baud + tr"	dc1
+ "latency + 8*baud"	dc1	"latency + 8*baud + tr"	dc0
+ "latency + 12*baud"	dc0	"latency + 12*baud + tr"	dc1
+ "latency + 13*baud"	dc1	"latency + 13*baud + tr"	dc0
+ "latency + 14*baud"	dc0	"latency + 14*baud + tr"	dc1
+ "latency + 15*baud"	dc1	"latency + 15*baud + tr"	dc0
+ "latency + 18*baud"	dc0	"latency + 18*baud + tr"	dc1
+ "latency + 22*baud"	dc1	"latency + 22*baud + tr"	dc0
+ "latency + 24*baud"	dc0	"latency + 24*baud + tr"	dc1
+ "latency + 25*baud"	dc1	"latency + 25*baud + tr"	dc0
+ "latency + 28*baud"	dc0	"latency + 28*baud + tr"	dc1
+ "latency + 29*baud"	dc1	"latency + 29*baud + tr"	dc0
+ "latency + 30*baud"	dc0	"latency + 30*baud + tr"	dc1
+ "latency + 32*baud"	dc1	"latency + 32*baud + tr"	dc0
+ "latency + 34*baud"	dc0	"latency + 34*baud + tr"	dc1
+ "latency + 37*baud"	dc1	"latency + 37*baud + tr"	dc0
+ "latency + 38*baud"	dc0	"latency + 38*baud + tr"	dc1
+ "latency + 39*baud"	dc1	"latency + 39*baud + tr"	dc0
+ "latency + 40*baud"	dc0	"latency + 40*baud + tr"	dc1
+ "latency + 41*baud"	dc1	"latency + 41*baud + tr"	dc0
+ "latency + 43*baud"	dc0	"latency + 43*baud + tr"	dc1
+ "latency + 48*baud"	dc1	"latency + 48*baud + tr"	dc0
+ "latency + 49*baud"	dc0	"latency + 49*baud + tr"	dc1
+ "latency + 50*baud"	dc1	"latency + 50*baud + tr"	dc0
+ "latency + 54*baud"	dc0	"latency + 54*baud + tr"	dc1
+ "latency + 57*baud"	dc1	"latency + 57*baud + tr"	dc0
+ "latency + 60*baud"	dc0	"latency + 60*baud + tr"	dc1
+ "latency + 61*baud"	dc1	"latency + 61*baud + tr"	dc0
+ "latency + 63*baud"	dc0	"latency + 63*baud + tr"	dc1
+ "latency + 64*baud"	dc1	"latency + 64*baud + tr"	dc0
+ "latency + 66*baud"	dc0	"latency + 66*baud + tr"	dc1
+ "latency + 68*baud"	dc1	"latency + 68*baud + tr"	dc0
+ "latency + 69*baud"	dc0	"latency + 69*baud + tr"	dc1
+ "latency + 71*baud"	dc1	"latency + 71*baud + tr"	dc0
+ "latency + 72*baud"	dc0	"latency + 72*baud + tr"	dc1
+ "latency + 73*baud"	dc1	"latency + 73*baud + tr"	dc0
+ "latency + 74*baud"	dc0	"latency + 74*baud + tr"	dc1
+ "latency + 76*baud"	dc1	"latency + 76*baud + tr"	dc0
+ "latency + 77*baud"	dc0	"latency + 77*baud + tr"	dc1
+ "latency + 81*baud"	dc1	"latency + 81*baud + tr"	dc0
+ "latency + 82*baud"	dc0	"latency + 82*baud + tr"	dc1
+ "latency + 84*baud"	dc1	"latency + 84*baud + tr"	dc0
+ "latency + 87*baud"	dc0	"latency + 87*baud + tr"	dc1
+ "latency + 89*baud"	dc1	"latency + 89*baud + tr"	dc0
+ "latency + 90*baud"	dc0	"latency + 90*baud + tr"	dc1
+ "latency + 91*baud"	dc1	"latency + 91*baud + tr"	dc0
+ "latency + 93*baud"	dc0	"latency + 93*baud + tr"	dc1
+ "latency + 94*baud"	dc1	"latency + 94*baud + tr"	dc0
+ "latency + 95*baud"	dc0	"latency + 95*baud + tr"	dc1
+ "latency + 98*baud"	dc1	"latency + 98*baud + tr"	dc0
+ "latency + 99*baud"	dc0	"latency + 99*baud + tr"	dc1
+ "latency + 102*baud"	dc1	"latency + 102*baud + tr"	dc0
+ "latency + 104*baud"	dc0	"latency + 104*baud + tr"	dc1
+ "latency + 106*baud"	dc1	"latency + 106*baud + tr"	dc0
+ "latency + 108*baud"	dc0	"latency + 108*baud + tr"	dc1
+ "latency + 109*baud"	dc1	"latency + 109*baud + tr"	dc0
+ "latency + 110*baud"	dc0	"latency + 110*baud + tr"	dc1
+ "latency + 111*baud"	dc1	"latency + 111*baud + tr"	dc0
+ "latency + 112*baud"	dc0	"latency + 112*baud + tr"	dc1
+ "latency + 113*baud"	dc1	"latency + 113*baud + tr"	dc0
+ "latency + 114*baud"	dc0	"latency + 114*baud + tr"	dc1
+ "latency + 121*baud"	dc1	"latency + 121*baud + tr"	dc0
+ "latency + 127*baud"	dc0
+ R
.ENDS
