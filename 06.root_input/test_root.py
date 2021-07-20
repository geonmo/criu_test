#!/usr/bin/env python3


from ROOT import *
import sys

f1 = TFile.Open("h1.root","recreate")


h1 = TH1F("his","hist",100,0,100)

rand3 = TRandom3()
rand3.SetSeed(time(0))


for x in range(50):
    value = int(rand3.Rndm()*100%100)
    print(f"Fill {value} at {x}")
    sys.stdout.flush()
    h1.Fill(x,value)
    if ( x%10==0):
        h1.Write()
        print(f"Write h1 at {x}")
    sleep(1) 


h1.Write()

