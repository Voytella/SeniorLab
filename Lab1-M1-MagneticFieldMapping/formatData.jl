using DataFrames
using CSV

data = CSV.File("2dMappingTesla.csv") |> DataFrame

# return list of data points as triples
function getDataPoints()
    dataPts = []
    
    # all the z coordinates
    zs = data[:zVr]

    # all the rho coordinates
    rs = -22:2:22
    
    # iterate over zs
    for ii in 1:16

        # iterate over rs
        for jj in 2:24
            
            dataPt = (zs[ii], rs[jj-1], data[jj][ii])
            
            # append each triple to the list
            append!(dataPts, dataPt)
        end
    end

    # return the list of triples
    return dataPts
    
end

# convert column number (2:24) to radial distance value (-22:2:22)
colNum2RadialDist(col) = col + (col - 26)

# convert row number (1:16) to height value (3:2:33)
rowNum2Height(row) = row + (row + 1)

# data points for a row of data at the same height level
getRow(z) = [ (z+2, colNum2RadialDist(col), data[col][z]) for col in 2:24 ]

# a 2D array containing all the experimental data points as triples
allPts = map(getRow(z), 1:16)

println(allPts)
