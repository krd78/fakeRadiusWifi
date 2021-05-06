#!/usr/bin/env python3
# After this script: ./john --format=NETNTLM freeradius.john
#
# 12/19/2011 - Josh Kelley
###############################################################################

import sys

OUTPUT = "freeradius.john"
LOG_FILE = sys.argv[1]

if len(sys.argv) < 2:
    print (sys.argv[0]+" <freeradius log file>")
    exit()

fileIn = open(LOG_FILE,'r')
fileOut = open(OUTPUT,'w')

i = 0
for line in fileIn:
    lineClean = line.strip()
    lineSplit = lineClean.split(':')
    if lineSplit[0] == "mschap":
        i = i + 1
    if lineSplit[0] == "username":
        username = lineSplit[1].strip()
        i = i + 1
    if lineSplit[0] == "challenge":
        challenge = ""
        for x in lineSplit[1:]:
            challenge = challenge + x
            challenge = challenge.strip()
            i = i + 1
    if lineSplit[0] == "response":
        response = ""
        for x in lineSplit[1:]:  
            response = response + x
            response = response.strip()
            i = i + 1
    if i == 4:
        lineNew = str(username, "%s:$NETNTLM$", challenge, response)
        fileOut.write(lineNew, "\n")
        i=0
fileIn.close()
fileOut.close()
