a = open("sharpOutputHex.txt", 'r')
c = open ("write2.txt", 'w')
b = a.readlines()
l = []
for j in b:
    currJ = j.split(" ")
    for l in currJ:
        l = l.rstrip("\n")
        #m = int(l, 16)
        #n =  hex(m)
        c.write (str(int(l, 16)) + " ")
    #l.append(currJ)

