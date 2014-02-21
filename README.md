phobia codeguru 9
================

phase 1
-------
- AntiMamaliga method
- Two zombies same as master, catched via int 87h

phase 2
------
- AntiMamaliga method
- Zombies heal out code, 6 catched via [Chinese Remainder Theorem](http://en.wikipedia.org/wiki/Chinese_remainder_theorem)
- One of the zombies protect the other zombies
- The code of all the zombies added to the end of both survivurs, to decrece the odds of others catch zombies via int 87h

phase 3
------
- AntiMamaliga method
- Int 87h against `KenGeruX` and `IamAramAcham`
- The code of all the zombies added to the end of both survivurs, to decrece the odds of others catch zombies via int 87h

Chinese Remainder Theorem
--------
the formula used to find all the zombies are ():

    input = ?
    a1 = (input%254);
    a2 = (input%255);
    input = ( a1*255*1 + a2*254*254  ) % ( 255*254 );
    
