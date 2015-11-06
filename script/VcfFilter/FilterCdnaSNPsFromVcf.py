#!/usr/bin/python

import sys

def generator(fileobj):
    while True:
        data = fileobj.readline()
        if not data:
            
            break
        yield data[:-1]
    yield None

def newrange(pos,x_y):
    
    while int(pos) > int(x_y[0].split("-")[1]):
            
        del x_y[0]

        
    
    
def main(argv):
    x_y = argv[1].split("\n")
    file = open("Gorilla_all_SNPs.16.vcf")
    i = 0
    for line in generator(file):
        if line is None:
            break
        elif line[0] == "#":
        
            print line
        else:
            # pak positie
            pos = int(line.split("\t")[1])
            if pos > int(x_y[0].split("-")[1]):
                newrange(pos, x_y)
            elif pos >= int(x_y[0].split("-")[0]) and pos <= int(x_y[0].split("-")[1]):
                print line
            
            
 
if __name__ == "__main__":
    main(sys.argv)
