using DataFrames
using CSV

data = CSV.File("2dMappingTesla.csv") |> DataFrame

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

println(getDataPoints())
