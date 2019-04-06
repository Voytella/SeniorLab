#!/bin/bash

# create a list of uncertainties the same length as the data file

# ----------BEGIN ERRORS----------

# uncertainty in current
AErr="0.1"

# uncertainty in voltage
VErr="1"

# -----------END ERRORS-----------

# ----------BEGIN FILENAMES----------

# first argument is the data file
dataFile="$1"

# the name of the file containing the error data
errFile=$(echo $dataFile | awk -F'.' '{print $1"Err."$2}')

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
    echo "$VErr $AErr" >> $errFile
done

# -----------END CREATE FILE-----------


