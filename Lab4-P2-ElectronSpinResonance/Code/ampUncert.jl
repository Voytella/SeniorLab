# ----------BEGIN PACKAGES----------

using Measurements

using CSV

using DataFrames

# -----------END PACKAGES-----------

# ----------BEGIN EXTRACT DATA----------

# read all the data from the file
dataRaw = CSV.File("../Plots/ExpFreqVsVolt/freq_depen.csv") |> DataFrame



# -----------END EXTRACT DATA-----------
