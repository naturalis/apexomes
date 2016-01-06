#!/usr/bin/python

import sys

def generator(fileobj):
    """
    Input: 1
        fileobj: read file object
    The function yields a readline row and stops
    if there is no more data available.
    """
    while True:
        data = fileobj.readline()
        if not data:
            break
        yield data[:-1]
    yield None

def newrange(pos,x_y):
    """
    Input: 2
        pos: Integer with current position.
        x_y: List with coding regions.
    The while loopt runs everytime the pos variable is larger
    than the second element of the sorted exome list.
    In every iteration the loop deletes the first
    index of the x_y list and then checks if the list is not
    empty. The check is for breaking the while loop if the list is
    empty. Without the check the code will generate an error in the
    iteration after the list is empty.
    """
    while int(pos) > int(x_y[0].split("-")[1]):
        del x_y[0]
        if len(x_y) == 0:
            break
            
        
        

        
def filterexome(filename, x_y):
    """
    Input: 2
       filename: str: Filename to be opend.(vcf file)
       x_y: list: List with strings. It has the positions of the exome.
    The function loops through the vcf file lines and prints headers.
    If there are no more headers, then the script checks if the snp is
    in the exome. If not, the function calls newrange to look for further
    gene positions. If the snp is in a coding region, then the snp will
    be printed. 
    The loop contains breaking points to stop if the exome list is empty
    to prevent errors.
    """
    file = open(filename)
    for line in generator(file):
        if line is None:
            break
        elif line[0] == "#":
            print line
        else:
            # get position
            pos = int(line.split("\t")[1])
            if pos > int(x_y[0].split("-")[1]):
                if len(x_y) == 1:
                    break
                newrange(pos, x_y)
                if len(x_y) == 0: 
                    break
            if pos >= int(x_y[0].split("-")[0]) and pos <= int(x_y[0].split("-")[1]):
                print line

def filtergenome(filename):
    """
    This function could be used to filter out unwanted Gorilla's but to
    preserve all the genomic data from vcf files.
    """
    file = open(filename)
    for line in generator(file):
        if line is None:
            break
        elif line[0] == "#":
        
            print line
        else:
            print line

            
def main(argv):
    option = argv[1]
    if option == "-h" or option == "--h" or option == "-help" or option == "--help":
        systeminformation()
    elif option == "-exome":
        exomelist = argv[2].split("\n")
        filename = argv[3]
        filterexome(filename, exomelist)
    elif option == "-genome":
        filename = argv[3]
        filtergenome(filename)
    
    
    
            
            
 
if __name__ == "__main__":
    main(sys.argv)
