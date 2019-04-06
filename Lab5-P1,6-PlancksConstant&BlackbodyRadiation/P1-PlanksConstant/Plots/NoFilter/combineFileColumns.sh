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
nl $baseFile > L${baseFile}
nl $appFile > L${appFile}

# join the two files together
join L${baseFile} L${appFile} > J${baseFile}

# eliminate pesky strange newlines
tr -d '\r' < J${baseFile} > F${baseFile}

# -----------END JOIN FILES TOGETHER-----------
