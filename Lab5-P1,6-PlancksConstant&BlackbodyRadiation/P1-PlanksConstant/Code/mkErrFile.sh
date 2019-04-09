#!/bin/bash

# create a list of uncertainties the same length as the data file

# ----------BEGIN ERRORS----------

# uncertainty in first column
col1="$2"

# uncertainty in second column
col2="$3"

# -----------END ERRORS-----------

# ----------BEGIN FILENAMES----------

# first argument is the data file
dataFile="$1"

# name of data file omitting extension
dataNoExt="$(echo ${dataFile} | awk -F'.' 'sub(FS $NF,x)')"

# extension of data file
dataExt="$(echo ${dataFile} | awk -F'.' '{print $NF}')"

# the name of the file containing the error data
errFile="${dataNoExt}Err.${dataExt}"

# -----------END FILENAMES-----------

# ----------BEGIN ITERATIONS----------

# the number of lines in the data file
lenDataFile=$(wc -l "$dataFile" | awk -F' ' '{print $1}')

# the number of uncertainty pairs that need to be inserted
numUncerts=$(($lenDataFile-1))

# -----------END ITERATIONS-----------

# ----------BEGIN CREATE FILE----------

# throw headers onto the file
echo "VErr AErr" > $errFile

# insert uncertainties into file
for (( ii=0; ii<$numUncerts; ii++ )); do
    echo "$col1 $col2" >> $errFile
done

# -----------END CREATE FILE-----------


