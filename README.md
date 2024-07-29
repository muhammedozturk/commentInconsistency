# commentInconsistency
![alt text](https://github.com/muhammedozturk/commentInconsistency/blob/main/cizim.pdf)?raw=true)

This repository includes R codes devised for code comment inconsistency detection.

First you should install following packages in R
library("stringdist")
library("stringi")
library("tensorflow")
library("keras")
library("tm")

After that, if you do not want to spend time in dividing sources into comment and codes, you may use the .txt files in this repository.
findSimilarity.R presents you to train code and comment files and learn inconsistency. 

folderSearch.R is a script finds comments and codes of any programmig language, just replace ".cs" with ".java" or ".py" to find others. Default is C#.
