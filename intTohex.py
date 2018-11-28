a = open("sorry.txt", 'r')
c = open ("write.txt", 'w')
b = a.readlines()
l = []
for j in b:
    currJ = j.split("\t")
    for l in currJ:
        l = l.rstrip("\n")
        m = int(l)
        n =  hex(m)
        c.write (n + " ")
    #l.append(currJ)

