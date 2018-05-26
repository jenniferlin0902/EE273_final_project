* RC Filter to smooth and match pulse sources to transmission
* lines. User spcifies impedance, RFLT, and smoothing interval,
* TDFLT. TDFLT is usually specified at about 10% of the rise
* time of the pulse source.
*
* Performance parameters:
*
* 	Smoothing period = Tdflt (equiv. boxcar filter)
*	Time delay = Tdflt
*	Cut-off freq, Fc = 2*pi/(Tdflt)
*	Impedance, Zo ~= Rflt*(0.9 + 0.1/sqrt(1 + (f/Fc)**2))
*	V(out)/V(in) = [1/sqrt(1 + (f/Fc)**2)]**4

 .MACRO (RCF) in out  RFLT=50 TDFLT=100p
 .PARAM TD1S = 'TDFLT/4'
 .PARAM CTD  = 'TD1S/(0.9*RFLT)'
*.PROT
 Rf1  in n1  '0.00009*RFLT'
 Rf2  n1 n2  '0.0009*RFLT'
 Rf3  n2 n3  '0.009*RFLT'
 Rf4  n3 n4  '0.09*RFLT'
 Rout n4 out '0.9*RFLT'

 Cf1  n1 0   '10000*CTD'
 Cf2  n2 0   '1000*CTD'
 Cf3  n3 0   '100*CTD'
 Cf4  n4 0   '10*CTD'
*.UNPROT
 .EOM
