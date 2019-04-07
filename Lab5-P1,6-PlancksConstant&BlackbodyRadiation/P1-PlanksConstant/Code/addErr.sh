# Create a table of values and their corresponding uncertainties.
# ARGS: <data file> <uncertainty in column 1> <uncertainty in column 2>

# path to called scripts
scriptPath="~/SeniorLab/Experiments/Lab5-P1,P6-PlancksConstant

# ----------BEGIN INPUT----------

# path of the 2-column data file
filepath="$1"

# uncertainty in column 1
col1Err="$2"

# uncertainty in column 2
col2Err="$3"

# -----------END INPUT-----------

# ----------BEGIN GENERATE COMBINED FILE----------

# create uncertainty file
./mkErrFile.sh $filepath $col1Err $col2Err

# name of data file omitting extension
dataNoExt="$(echo ${filepath} | awk -F'.' 'sub(FS $NF,x)')"

# extension of the data file
dataExt="$(echo ${filepath} | awk -F'.' '{print $NF}')"

# combine the two files
./combineFileColumns.sh $filepath "${dataNoExt}Err${dataExt}"

# -----------END GENERATE COMBINED FILE-----------

