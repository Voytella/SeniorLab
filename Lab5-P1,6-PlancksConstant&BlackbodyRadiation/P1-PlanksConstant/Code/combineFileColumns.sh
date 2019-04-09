#!/bin/bash

# Horizontally append one file to another (column-wise append).
# Assume both files have the same number of lines.

# ----------BEGIN GET FILENAMES----------

# the name of the file being extended
baseFile="$1"

# the name of the file to be appended
appFile="$2"

# -----------END GET FILENAMES-----------

# ----------BEGIN JOIN FILES TOGETHER----------

# tack line numbers onto both files
nl $baseFile > ${baseFile}L
nl $appFile > ${appFile}L

# name of base file omitting extension
baseNoExt="$(echo ${baseFile} | awk -F'.' 'sub(FS $NF,x)')"

# extension of base file
baseExt="$(echo ${baseFile} | awk -F'.' '{print $NF}')"

# join the two files together
join ${baseFile}L ${appFile}L > ${baseFile}J

# -----------END JOIN FILES TOGETHER-----------

# ----------BEGIN CLEAN UP----------

# eliminate pesky strange newlines
tr -d '\r' < ${baseFile}J > ${baseFile}JN

# remove explicit line numbers
awk -F' ' '{$1=""; print $0}' ${baseFile}JN > ${baseFile}JNL

# remove leading space
sed s/^" "//g ${baseFile}JNL > "${baseNoExt}Comb.${baseExt}"

# remove bridge files
rm ${baseFile}L
rm ${appFile}L
rm ${baseFile}J
rm ${baseFile}JN
rm ${baseFile}JNL

# -----------END CLEAN UP-----------
