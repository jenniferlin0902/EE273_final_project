* Reference Channel Single Pulse Response *

*************************************************************************
*************************************************************************
*                                                                       *
*			Parameter Definitions				*
*                                                                       *
*	ADJUST THE FOLLOWING PARAMETERS TO SET SIMULATION RUN TIME	*
*	AND TO SET DRIVER PRE-EMPHASIS LEVELS.				*
*                                                                       *
*	PLOT THE SIGNAL rx_diff TO GET THE DIFFERENTIAL RECEIVE SIGNAL.	*
*                                                                       *
*************************************************************************
*************************************************************************
* Simulation Run Time *
 .PARAM simtime	= '60/bps'	* USE THIS RUNTIME FOR PULSE RESPONSE
*.PARAM simtime	= '256/bps'	* USE THIS RUNTIME FOR EYE DIAGRAM

* CTLE Settings *
 .PARAM az1     = 1.5g	* CTLE zero frequency, Hz
 .PARAM ap1     = 3.125g	* CTLE primary pole frequency, Hz
 .PARAM ap2     = 10g           * CTLE secondary pole frequency, Hz

* Eye delay -- In awaves viewer, plot signal rx_diff against signal eye
*              then adjust parameter edui to center the data eye.
*
 .PARAM edui	= 0.00	 	* Eye diagram alignment delay.
 				* Units are fraction of 1 bit time.
				* Negative moves the eye rigth.
				* Positive moves the eye left.

* Single Pulse Signal Source *
*Vs  inp 0    PULSE (1 0 0 trise tfall '(1/bps)-trise' simtime)

* PRBS7 Signal Source *
*Xs  inp inn  (bitpattern) dc0=0 dc1=1 baud='1/bps' latency=0 tr=trise

* AC Signal Source *
 Vs  inp inn   AC 1

*************************************************************************
*************************************************************************

* Driver Volatage and Timing *
 .PARAM vd	= 1250m		* Driver peak to peak diff drive, volts
 .PARAM trise	= 35p		* Driver rise time, seconds
 .PARAM tfall	= 35p		* Driver fall time, seconds
 .PARAM bps	= 10.7g		* Bit rate, bits per second

* PCB Line Lengths *
 .PARAM len1	= 9		* Line segment 1 length, inches
 .PARAM len2	= 12		* Line segment 2 length, inches
 .PARAM len3	= 4		* Line segment 3 length, inches
 .PARAM len4	= 1		* Line segment 4 length, inches

* Package Parameters *
 .PARAM GENpkgR = 0.337		* Typ GEN package trace resistance, ohms
 .PARAM GENpkgL = 5.675n	* Typ GEN package trace induct., henries
 .PARAM GENpkgC = 2.27p		* Typ GEN package trace capac., farads

* Receiver Parameters *
 .PARAM rterm	= 50		* Receiver input resistance, ohms


*************************************************************************
*                                                                       *
*			Main Circuit					*
*                                                                       *
*************************************************************************
* Behavioral CTLE *
*Xf  inp in   (RCF) TDFLT='0.25*trise'
 Xd  inp  inn outp outn  (rx_eq_diff) az1=az1 ap1=ap1 ap2=ap2

* Behavioral Receiver *
 Rrp1  outp 0  rterm
 Rrn1  outn 0  rterm

* Differential Receive Voltage *
 Ex  rx_diff 0  (outp,outn) 1
 Rx  rx_diff 0  1G

* Eye Diagram Horizontal Source *
 Veye1 eye 0 PWL (0,0 '1./bps',1 R TD='edui/bps')
 Reye  eye 0 1G

*************************************************************************
*                                                                       *
*			Libraries and Included Files			*
*                                                                       *
*************************************************************************

*.INCLUDE './rlgc/diff_aniso_stripline_Meg42.inc'
*.INCLUDE './prbs7.inc'
 .INCLUDE './rx_eq_diff.inc'
*.INCLUDE './filter.inc'


*************************************************************************
*                                                                       *
*                       Sub-Circuit Definitions                         *
*                                                                       *
*************************************************************************



*************************************************************************
*                                                                       *
*			Simulation Controls and Alters			*
*                                                                       *
*************************************************************************
 .OPTIONS post
 .AC DEC 1000 (100k,100g) SWEEP DATA=plens
 .DATA	plens
+	az1	ap1	ap2
+	5.35g	5.35g	10g
+	1.5g	5.25g	10g
 .ENDDATA

*.TRAN 5p simtime
 .END

