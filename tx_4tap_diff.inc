* Behavioral Four Tap Equalizer *
*
* *** Parameter Meanings: ***
*
*.PARAM ppo = Differential peak to peak output voltage driving 100 ohm line
*.PARAM bps = signaling rate in bits per second
*.PARAM a0 = pre-cursor as fraction of max full swing
*.PARAM a2 = 1st post-cursor as fraction of max full swing
*.PARAM a3 = 2nd post-cursor as fraction of max full swing
*
* *** RESTIRCTIONS: ***
* 1. This differential driver must be loaded with 100 ohms to give correct levels
* 2. The input swing must be zero to 1 volt
*
 .SUBCKT (tx_4tap_diff) in outp outn  ppo=700m bps=3.125G a0=0 a2=0 a3=0
    R1  in 1  1G							* Terminate "open" input
    V1  1  0  DC 0.5
    Ed1 2  0  DELAY (in,1) TD='1/bps'					* One bit delay
    Ed2 3  0  DELAY (in,1) TD='2/bps'					* Two bit delay
    Ed3 4  0  DELAY (in,1) TD='3/bps'					* Three bit delay
    R2  2  0  1G							* Delay termination
    R3  3  0  1G							* Delay termination
    R4  4  0  1G							* Delay termination
    *
    G0  outn outp  (in,1) '0.5*ppo*a0/25'				* Pre-cursor source
    G1  outp outn  (2,0)  '0.5*ppo*(1-(abs(a0)+abs(a2)+abs(a3)))/25'	* Cursor source
    G2  outn outp  (3,0)  '0.5*ppo*a2/25'				* 1st post-cursor source
    G3  outn outp  (4,0)  '0.5*ppo*a3/25'				* 2nd post-cursor source
    R5  outp 0     50							* Driver output termination
    R6  outn 0     50							* Driver output termination
 .ENDS (tx_4tap_diff)

