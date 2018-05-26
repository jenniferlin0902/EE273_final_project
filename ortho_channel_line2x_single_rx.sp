* Reference Orthogonal Midplane Channel -- Single Pulse Responts *

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
* Transmitter Bit Rate *
*.PARAM bps	= 6.25g		* Bit rate, bits per second
 .PARAM bps	= 10.7g		* Bit rate, bits per second

* Simulation Run Time *
 .PARAM simtime	= '100/bps'	* USE THIS RUNTIME FOR PULSE RESPONSE
*.PARAM simtime	= '256/bps'	* USE THIS RUNTIME FOR EYE DIAGRAM

* CTLE Settings *
*.PARAM az1     = 3.125g        * CTLE zero frequency, Hz
 .PARAM az1     = 5g            * CTLE zero frequency, Hz
*.PARAM ap1     = 3.125g        * CTLE primary pole frequency, Hz
 .PARAM ap1     = 5g            * CTLE primary pole frequency, Hz
 .PARAM ap2     = 10g           * CTLE secondary pole frequency, Hz

* Driver Pre-emphais *
 .PARAM pre1	=  0.00		* Driver pre-cursor pre-emphasis
 .PARAM post1	=  0.00		* Driver 1st post-cursor pre-emphasis
 .PARAM post2	=  0.00		* Driver 2nd post-cursor pre-emphasis

* PCB Line Lengths *
 .PARAM len_c   = 1             * Line segment 1 length, inches
 .PARAM len_x   = 11.6          * Line segment 2 length, inches
 .PARAM len_l   = 9.5           * Line segment 3 length, inches
 .PARAM len_t   = 0.25          * line segment for t line in connector

* Eye delay -- In awaves viewer, plot signal rx_diff against signal eye
*              then adjust parameter edui to center the data eye.
*
 .PARAM edui	= 0.00	 	* Eye diagram alignment delay.
 				* Units are fraction of 1 bit time.
				* Negative moves the eye rigth.
				* Positive moves the eye left.

*************************************************************************
*************************************************************************

*************************************************************************
*                                                                       *
*                       Simulation Controls and Alters                  *
*                                                                       *
*************************************************************************
 .TRAN 5p simtime *SWEEP DATA=plens
 .DATA	plens
+       az1     ap1     ap2	pre1	post2
*+	3.125g	3.125g	10g	0.0	0.0
+	5g	5g	10g	0.0	0.0
 .ENDDATA


*************************************************************************
*                                                                       *
*               Signal Source -- Tx/Rx Parameters                       *
*                                                                       *
*************************************************************************
* Driver Volatage and Timing *
 .PARAM vd	= 625m		* Driver zero to peak diff drive, volts
 .PARAM trise	= 35p	* Driver rise time, seconds
 .PARAM tfall	= 35p	* Driver fall time, seconds

* Receiver Parameters *
 .PARAM cload	= 500f 		* Receiver input capacitance, farads
 .PARAM rterm	= 50		* Receiver input resistance, ohms

* Single Pulse Signal Source *
 Vs  inp 0    PULSE (1 0 0 trise tfall '(1/bps)-trise' simtime)

* PRBS7 Signal Source *
*Xs  inp inn  (bitpattern) dc0=0 dc1=1 baud='1/bps' latency=0 tr=trise


*************************************************************************
*                                                                       *
*			Main Circuit					*
*                                                                       *
*************************************************************************
* Behavioral Driver *
 Xf  inp in   (RCF) TDFLT='0.25*trise'
 Xd  in  ppad npad  (tx_4tap_diff) ppo=vd bps=bps a0=pre1 a2=post1 a3=post2

* Interconnect *
 Xpp1    ppad  jp1     (bga_pkg)			* Driver package model
 Xpn1    npad  jn1     (bga_pkg)			* Driver package model
 Xvp1    jp1   jp2     (via)				* Package via
 Xvn1    jn1   jn2     (via)				* Package via

 Xl1 jp2 jn2   jp3 jn3 (diff_stripline)
+                      length=len_l			* Line seg 1

 Xvp2    jp3   jp4     (via) zvia=40			* Daughter card via
 Xvn2    jn3   jn4     (via) zvia=40			* Daughter card via
 Xk1 jp4 jn4   jp5 jn5 (xconn)				* Xcede+ connector
 Xvp3    jp5   jp6     (mvia)				* Backplane via
 Xvn3    jn5   jn6     (mvia)				* Backplane via

 Tmpp    jp6 0 jp7 0   Z0=50 TD='len_t*170p'		* Midplane seg 2-P
 Tmpn    jn6 0 jn7 0   Z0=50 TD='len_t*170p'		* Midplane seg 2-N

 Xvp4    jp7   jp8     (mvia) 				* Backplane via
 Xvn4    jn7   jn8     (mvia) 				* Backplane via
 Xk2 jp8 jn8   jp9 jn9 (xconn)
*Xkp2 0  jp9   jp8     (conn)				* Backplane connector
*Xkn2 0  jn9   jn8     (conn)				* Backplane connector
 Xvp5    jp9   jp10    (via) zvia=40			* Daughter card via
 Xvn5    jn9   jn10    (via) zvia=40			* Daughter card via

 Xl3 jp10 jn10 jp11 jn11 (diff_stripline)
+                        length=len_x			* Line seg 3

 Xvp6    jp11  jp11_cin  (via) 				* DC blocking cap vias
 Xvn6    jn11  jn11_cin  (via) 				* DC blocking cap vias

Cblockp  jp11_cin jp12 100n. 			* DC blocking cap
Cblockn jn11_cin cp12 100n

 Xvp7    jp12  jp12  (via) 				* DC blocking cap vias
 Xvn7    jn11  jn12  (via) 				* DC blocking cap vias



 Xl4 jp12 jn12 jp13 jn13 (diff_stripline)
+                        length=len_c			* Line seg 4

 Xvp8    jp13  jp14  (via)				* Package via
 Xvn8    jn13  jn14  (via)				* Package via
 Xpp2    jp14  jrp   (bga_pkg)				* Recvr package model
 Xpn2    jn14  jrn   (bga_pkg)				* Recvr package model

* Behavioral Receiver *
 Rrp1  jrp 0  rterm
 Rrn1  jrn 0  rterm
 Crp1  jrp 0  cload
 Crn1  jrn 0  cload
 Xctle jrp jrn outp outn  (rx_eq_diff) az1=az1 ap1=ap1 ap2=ap2

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

 .INCLUDE './rlgc/diff_aniso_stripline_Meg42.rlgc'
 .INCLUDE './prbs7.inc'
 .INCLUDE './tx_4tap_diff.inc'
 .INCLUDE './rx_eq_diff.inc'
 .INCLUDE './filter.inc'
 .INCLUDE './xcede_ortho_4x8.inc'


*************************************************************************
*                                                                       *
*                       Sub-Circuit Definitions                         *
*                                                                       *
*************************************************************************
* Daughter Card BGA Via Sub-circuit -- values for 0.093" thick PCBs *
 .SUBCKT (via) in out zvia=45 tpropvia=15p
    T1  in 0 out 0 Z0=zvia TD=tpropvia
 .ENDS (via)

* Differential Pair Stripline *
 .SUBCKT (diff_stripline)  in1 in2 out1 out2 length=1 *inch
     W1  in1 in2 0 out1 out2 0  RLGCmodel=diff_stripline  N=2  L='0.0254*length'
 .ENDS (diff_stripline)

* Motherboard Via Sub-circuit *
*     zvia    = via impedance, ohms
*     len1via = active via length, inches
*     len2via = via stub length, inches
*     prop    = propagation time, seconds/inch
*
*.SUBCKT (mvia) in out  zvia=50 len1via=0.09 len2via=0.03 prop=180p
 .SUBCKT (mvia) in out  zvia=43 len1via=0.09 len2via=0.03 prop=180p
    T1  in  0 out 0  Z0=zvia TD='len1via*prop'
    T2  out 0 2   0  Z0=zvia TD='len2via*prop'
 .ENDS (mvia)

* Simple BGA Package Model *
 .SUBCKT (bga_pkg)  in out  zpkg=47 tdpkg=150p
    T1  in 0 out 0  Z0=zpkg  TD=tdpkg
 .ENDS (bga_pkg)

* Simplistic Behavioral Connector Model *
 .SUBCKT (conn) ref in out
     T1  in ref out ref Z0=47 TD=200p
 .ENDS (conn)


*************************************************************************
*			Option and End Statement			*
*************************************************************************
 .OPTIONS post ACCURATE
 .END

