* Test of Xcede+ Connector s24p Model Include File *

*************************************************************************
*                                                                       *
*				Sub-Circuit				*
*                                                                       *
*************************************************************************
 .SUBCKT (xconn) inp inn outp outn  rterm=50
    * Midplane Side Terminations *
    *R1    1 0  rterm
    *R3    3 0  rterm
     R5    5 0  rterm
     R7    7 0  rterm
     R9    9 0  rterm
     R11  11 0  rterm
     R13  13 0  rterm
     R15  15 0  rterm
     R17  17 0  rterm
     R19  19 0  rterm
     R21  21 0  rterm
     R23  23 0  rterm


    * Connector *
     S1 inp outp inn outn   5   6   7   8   9   10   11   12   13   14   15   16
    +    17   18  19   20  21  22  23  24  MNAME=s_model

    * Daughter Card Side Terminations *
    *R2    2 0  rterm
    *R4    4 0  rterm
     R6    6 0  rterm
     R8    8 0  rterm
     R10  10 0  rterm
     R12  12 0  rterm
     R14  14 0  rterm
     R16  16 0  rterm
     R18  18 0  rterm
     R20  20 0  rterm
     R22  22 0  rterm
     R24  24 0  rterm
 .ENDS (xconn)

* Connector S-parameter Model *
 .MODEL s_model S TSTONEFILE='Orthogonal_rev12_Full_Final.s24p'

