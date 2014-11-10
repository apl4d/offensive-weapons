#!/usr/bin/env python
# Program name: NetworkPairs.py
# Authors: Simon Appleford and Vetria L. Byrd, PhD
# Date: February 28, 2012
# Description: read in data from .txt file, organize and group network
# characters by date, then generate pairs of characters for each group;
# the pairs of characters from each group is written to the final
# output file.
#
# Program Notes:
# input file should be sorted by picture filename format (i.e., 1946-01-04.jpg)
# input file should be a text file
from itertools import groupby
from operator import itemgetter
import sys, string 

def showUsage(exitCode):
	if exitCode == 1:
		print '\nUsage: characterPairs2.py <input_filename.txt> <output_filename.txt>'
	if exitCode == 2:
		print '\nCheck input and output filenames, they must be .txt files\n'
	if exitCode == 3:
		print '\nReserved filename (charGroups.txt) used as a filename.\n'
		print '\nCheck input/output filenames and rename the appropriate filename.\n'
		
	sys.exit(1)

def getCharacterNetwork(L,networkFile):
	row = networkFile.readline()
	while row:
		line = row.rstrip('\n') # remove end-line character
		entry = line.split('\t')	# split string into words
		entryDate = entry[0]
		entryName = entry[1]
		L.append((entryDate,entryName))
		row = networkFile.readline()

def write_pairs(List,outFile):
	current = List[0]
	for i in xrange(0,len(List)):
		next = i + 1
		if ((next <= len(List)) & (current != List[next-1])):
			# for debugging
			#print current, List[i]
			#print List[i], current
			outFile.write(current)
			outFile.write('\t')
			outFile.write(List[i])
			outFile.write("\n")
			outFile.write(List[i])
			outFile.write('\t')
			outFile.write(current)
			outFile.write("\n")
			
def checkFilename(filename):
	index = 0
	index = filename.find('.txt',index)
	if index == -1:
		showUsage(2)

argc = len(sys.argv)	#get number of arguments entered on CMD line
if argc < 3:
	showUsage(1)

inputfile = sys.argv[1]
outputfile = sys.argv[2]
intermediatefile = "charGroups.txt"

checkFilename(inputfile)
checkFilename(outputfile)

# open file pointers for filtered data
outFile = open(outputfile,"w")
inFile = open(inputfile,"r")
workFile = open(intermediatefile,"w")

charList = list()	# empty list
groupCount = 0

getCharacterNetwork(charList,inFile)

for key, group in groupby(charList, lambda x: x[0]):
	listOfCharacters = "\t".join(["%s" % character[1] for character in group])
	workFile.write(listOfCharacters)
	workFile.write('\n')  # put a blank line between groups
	groupCount = groupCount + 1

inFile.close()
workFile.close()

# Generate pairs of characters for each group
origInputfile = inputfile
inputfile = intermediatefile
inFile = open(inputfile,"r")	# intermediate workfile is now an input file

newCharList = list()	# empty list

row = inFile.readline()
while row:
	line = row.rstrip('\n')
	charGroup = line.split('\t')
	groupCount = len(charGroup)
	if groupCount == 1:
		outFile.write(row)
	elif groupCount >1:
		newCharList = charGroup
		current = newCharList[0]
		for i in xrange(0,len(newCharList)):
			write_pairs(newCharList,outFile)
			del newCharList[0]
	row = inFile.readline()

# close all files
outFile.close()
workFile.close()

print "\n\nDone.\n\n"
print "\nNetwork file: %s" % origInputfile
print "\nCharacter groups (by date) have been written to %s" % intermediatefile
print "\nGroup pairs have been written to: %s" % outputfile