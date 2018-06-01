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
*.PARAM simtime	= '60/bps'	* USE THIS RUNTIME FOR PULSE RESPONSE
 .PARAM simtime	= '100/bps'	* USE THIS RUNTIME FOR PULSE RESPONSE
*.PARAM simtime	= '256/bps'	* USE THIS RUNTIME FOR EYE DIAGRAM

* CTLE Settings *
 .PARAM az1     = 5.35g 	* CTLE zero frequency, Hz
 .PARAM ap1     = 5.35g 	* CTLE primary pole frequency, Hz
 .PARAM ap2     = 10g           * CTLE secondary pole frequency, Hz

* Driver Pre-emphais *
 .PARAM pre1	= 0.00		* Driver pre-cursor pre-emphasis
 .PARAM post1	= 0.00		* Driver 1st post-cursor pre-emphasis
 .PARAM post2	= 0.00		* Driver 2nd post-cursor pre-emphasis

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
*Vs  in 0   AC 1

* S11 Signal Sources and Replica Circuit *
 Vs  s1   s2   AC 2		* Channel signal source
 Rs1 s1   jp1  50
 Rs2 s2   jn1  50

 Vr  rep1 rep2 AC 2		* Replica source
 Rr1 rep1 repp 50		* Replica circuit
 Rr2 repp 0    50
 Rr3 rep2 repn 50
 Rr4 repn 0    50
 Er1 fwd  0 (repp, repn) 1	* Compute V forward
 Er2 inpt 0 (jp1,  jn1)  1	* Computes vhannel input voltage
 Er3 s11  0 (inpt, fwd)  1	* Computes s11
 Er4 s21  0 (jp14, jn14) 1	* Computes s21


*************************************************************************
*************************************************************************

* Driver Volatage and Timing *
 .PARAM vd	= 1250m		* Driver peak to peak diff drive, volts
 .PARAM trise	= 35p *60p		* Driver rise time, seconds
 .PARAM tfall	= 35p *60p		* Driver fall time, seconds
 .PARAM bps	= 10.7g *6.25g		* Bit rate, bits per second

* PCB Line Lengths *
 .PARAM len_c   = 1             * Line segment cap length, inches
 .PARAM len_x   = 11.6          * Line segment xbar length, inches
 .PARAM len_l   = 10.5           * Line segment linecard length, inches
 .PARAM len_t   = 0.25          * line segment for t line in connector

* Package Parameters *
 .PARAM GENpkgZ = 47.5		* Typ GEN package trace impedance, ohms
 .PARAM GENpkgD = 100p		* Typ GEN package trace delay, sec

* Receiver Parameters *
 .PARAM cload	= 2f		* Receiver input capacitance, farads
 .PARAM rterm	= 50		* Receiver input resistance, ohms


*************************************************************************
*************************************************************************
*************************************************************************
*                                                                       *
*			Main Circuit					*
*                                                                       *
*************************************************************************
*************************************************************************
*************************************************************************
* Behavioral Driver *
*Xf  inp in   (RCF) RFLT=rterm TDFLT='0.25*trise'
*Xd  in  ppad npad  (tx_4tap_diff) ppo=vd bps=bps a0=pre1 a2=post1 a3=post2

* Daughter Card 1 Interconnect *
*Xpp1    ppad  jp1   (gen_pkg)				* Driver package model
*Xpn1    npad  jn1   (gen_pkg)				* Driver package model
 Xvn1    jn1   jn2   (via)				* Package via
 Xvp1    jp1   jp2   (via)				* Package via
 Xl1     jp2   jn2   jp3  jn3  (diff_stripline)	length=len_l  * Line seg 1
 Xvp2    jp3   jp4   (via)				* Daughter card via
 Xvn2    jn3   jn4   (via)				* Daughter card via

*************************************************************************
*************************************************************************
*                                                                       *
*	    Select Your Mid/backplane Configuration Here		*
*                                                                       *
*	    COMMENT OUT THE UNUSED CONFIGURATIONS			*
*                                                                       *
*************************************************************************
* Backplane Interconnect *
*Xk1  0  jp4   jn4   jp5  jn5  (conn)			* Backplane connector
*Xvp3    jp5   jp6   (mvia)				* Backplane via
*Xvn3    jn5   jn6   (mvia)				* Backplane via
*Xl2     jp6   jn6   jp7  jn7  (diff_stripline)	length=len_t  * Line seg 2
*Xvp4    jp7   jp8   (mvia) 				* Backplane via
*Xvn4    jn7   jn8   (mvia) 				* Backplane via
*Xk2  0  jp9   jn9   jp8  jn8  (conn)			* Backplane connector

* 4x8 Orthogonal Midplane Interconnect *
 Xk1  0  jp4   jn4   jp5  jn5  (conn)		    * 4x8 Ortho connector stack
 Tmp1    jp5 0 jp8 0 Z0=50 TD=40p		    * Through-midplane via
 Tmp2    jn5 0 jn8 0 Z0=50 TD=40p		    * Through-midplane via
 Xk2  0  jp9   jn9   jp8  jn8  (conn)		    * 4x8 Ortho connector stack
*Xk1  0  jp4   jn4   jp9  jn9  (conn)		    * 4x8 Ortho connector stack

* 6x12 Orthogonal Midplane Interconnect *
*Xk1  0  jp4   jn4   jp5  jn5  (conn)		    * 6x12 Orthogonal connector
*Tmp1    jp5 0 jp8 0 Z0=50 TD=40p		    * Through-midplane via
*Tmp2    jn5 0 jn8 0 Z0=50 TD=40p		    * Through-midplane via
*Xk2  0  jp9   jn9   jp8  jn8  (conn)		    * 6x12 Orthogonal connector
*************************************************************************
*************************************************************************

* Daughter Card 2 Interconnect *
 Xvp5    jp9   jp10  (via)				* Daughter card via
 Xvn5    jn9   jn10  (via)				* Daughter card via
 Xl3     jp10  jn10  jp11 jn11 (diff_stripline)	length=len_x  * Line seg 3
 Xvp6    jp11  jp12  (via) 		Cvia=1.4p	* DC blocking cap vias
 Xvn6    jn11  jn12  (via) 		Cvia=1.4p	* DC blocking cap vias
 Xl4     jp12  jn12  jp13 jn13 (diff_stripline)	length=len_c  * Line seg 4
 Xvp7    jp13  jp14  (via)				* Package via
 Xvn7    jn13  jn14  (via)				* Package via
*Xpp2    jp14  jrp   (gen_pkg)				* Recvr package model
*Xpn2    jn14  jrn   (gen_pkg)				* Recvr package model
 Rrp1    jp14  0     50
 Rrn1    jn14  0     50

* Behavioral Receiver *
*Rrp1  jrp 0  rterm
*Rrn1  jrn 0  rterm
*Crp1  jrp 0  cload
*Crn1  jrn 0  cload
*Xctle jrp jrn outp outn  (rx_eq_diff) az1=az1 ap1=ap1 ap2=ap2

* Differential Receive Voltage *
*Ex  rx_diff 0  (outp,outn) 1
*Rx  rx_diff 0  1G

* Eye Diagram Horizontal Source *
 Veye1 eye 0 PWL (0,0 '1./bps',1 R TD='edui/bps')
 Reye  eye 0 1G

*************************************************************************
*                                                                       *
*			Libraries and Included Files			*
*                                                                       *
*************************************************************************
 .INCLUDE './prbs7.inc'
 .INCLUDE './tx_4tap_diff.inc'
 .INCLUDE './rx_eq_diff.inc'
 .INCLUDE './filter.inc'


*************************************************************************
*                                                                       *
*                       Sub-Circuit Definitions                         *
*                                                                       *
*************************************************************************

*************************************************************************
*************************************************************************
*                                                                       *
*			Simplistic Connector Model			*
*                                                                       *
* 	     REPLACE THIS WITH THE APPROPRIATE AMPHENOL MODEL		*
*                                                                       *
*************************************************************************
*************************************************************************
 .SUBCKT (conn) ref inp inn outp outn					*
*    T1  inp ref outp ref Z0=50 TD=150p					*
*    T2  inn ref outn ref Z0=50 TD=150p					*
* Midplane Side Terminations *
*R1    1 0  50
*R3    3 0  50
 R5    5 0  50
 R7    7 0  50
 R9    9 0  50
 R11  11 0  50
 R13  13 0  50
 R15  15 0  50
 R17  17 0  50
 R19  19 0  50
 R21  21 0  50
 R23  23 0  50
 R25  25 0  50
 R27  27 0  50
 R29  29 0  50
 R31  31 0  50

* Connector *
 S1 inp outp inn outn   5   6   7   8   9   10   11   12
+    13   14  15   16  17  18  19  20  21   22   23   24   MNAME=s_model
* S1  inp outp inn outn   5   6   7   8   9   10   11   12   13   14   15   16
*+     17   18  19   20  21  22  23  24  25   26   27   28   29   30   31   32  MNAME=s_model

* Daughter Card Side Terminations *
*R2    2 0  50
*R4    4 0  50
 R6    6 0  50
 R8    8 0  50
 R10  10 0  50
 R12  12 0  50
 R14  14 0  50
 R16  16 0  50
 R18  18 0  50
 R20  20 0  50
 R22  22 0  50
 R24  24 0  50
 R26  26 0  50
 R28  28 0  50
 R30  30 0  50
 R32  32 0  50

* Connector S-parameter Model *
 .MODEL s_model S TSTONEFILE='./Orthogonal_rev12_Full_Final.s24p'
*.MODEL s_model S TSTONEFILE='./XCedeplus_100ohm_2p68_Ortho_2mm_Sig_3mm_GND_Wipe_EF_GHpairs_Only_20144301_IdEM.s32p'

 .ENDS (conn)								*
*************************************************************************
*************************************************************************

*************************************************************************
*                                                                       *
*		    6 mil Wide 50 ohm Stripline in FR4			*
*                                                                       *
*	    REPLACE THIS WITH YOUR DIFFERENTIAL STRIPLINE MODEL		*
*                                                                       *
*************************************************************************
*************************************************************************
 .SUBCKT (diff_stripline) inp inn outp outn length=1 *inch
    W1 inp inn 0 outp outn 0 RLGCMODEL=diff_stripline N=2 l='length*0.0254' delayopt=3
*   W1 inp 0 outp 0 RLGCMODEL=stripline6_fr4 N=1 l='length*0.0254' delayopt=3
*   W2 inn 0 outn 0 RLGCMODEL=stripline6_fr4 N=1 l='length*0.0254' delayopt=3
 .ENDS (diff_stripline)

 .INCLUDE './diff_stripline.rlgc'

*SYSTEM_NAME : stripline6_fr4
*
*  ------------------------------------ Z = 4.012800e-04
*  //// Top Ground Plane //////////////
*  ------------------------------------ Z = 3.860400e-04
*       diel_1   H = 3.708000e-04
*  ------------------------------------ Z = 1.524000e-05
*  //// Bottom Ground Plane ///////////
*  ------------------------------------ Z = 0
*
* L(H/m), C(F/m), Ro(Ohm/m), Go(S/m), Rs(Ohm/(m*sqrt(Hz)), Gd(S/(m*Hz))
*
*.MODEL stripline6_fr4 W MODELTYPE=RLGC, N=1
*+ Lo = 3.365634e-07
*+ Co = 1.322366e-10
*+ Ro = 7.474906e+00
*+ Go = 0.000000e+00
*+ Rs = 1.003105e-03
*+ Gd = 2.492601e-11
*************************************************************************
*************************************************************************

* Daughter Card Via Sub-circuit -- typical values for 0.093" thick PCBs *
 .SUBCKT (via) in out  Z_via=30 TD_via=20p
    Tvia  in 0 out 0  Z0=Z_via TD=TD_via
 .ENDS (via)

* Motherboard Via Sub-circuit *
*     zvia    = via impedance, ohms
*     len1via = active via length, inches
*     len2via = via stub length, inches
*     prop    = propagation time, seconds/inch
*
 .SUBCKT (mvia) in out  zvia=50 len1via=0.09 len2via=0.03 prop=180p
    T1  in  0 out 0  Z0=zvia TD='len1via*prop'
    T2  out 0 2   0  Z0=zvia TD='len2via*prop'
 .ENDS (mvia)

* Generic Package Model *
 .SUBCKT (gen_pkg)  in out  Z_pkg=GENpkgZ Td_pkg=GENpkgD
    Tpkg in 0 out 0 Z0=Z_pkg TD=Td_pkg
 .ENDS (gen_pkg)


*************************************************************************
*                                                                       *
*			Simulation Controls and Alters			*
*                                                                       *
*************************************************************************
 .OPTIONS post ACCURATE
 .AC DEC 1000 (100k,10g) SWEEP DATA=plens
*.TRAN 5p simtime *SWEEP DATA=plens
 .DATA	plens
+       az1     ap1     ap2	pre1
+	1k	1k	100g	0.0
*+	800meg	3.125g	100g	0.0
*+	850meg	3.125g	10g	0.0
*+	850meg	3.125g	10g	0.16
*+	1g	3.125g	100g	0.0
 .ENDDATA
 .END

