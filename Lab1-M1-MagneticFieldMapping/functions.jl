# ----------BEGIN PACKAGES----------

# enable the addition of packages
using Pkg

# integration
Pkg.add("QuadGK")
using QuadGK

# -----------END PACKAGES-----------

# ----------BEGIN CONSTANTS----------

# Permeability of Free Space (T*m)/A
μ₀ = 1.256e-6

# -----------END CONSTANTS-----------

# ----------BEGIN BIOT-SAVART ON AXIS----------

# Biot-Savart (one loop, on axis)
B1(z,I,a) = ((μ₀ * I * (a ^ 2)) / 2) * (1 / (((a ^ 2) + (z ^ 2)) ^ (3/2)))
    
# Biot-Savart (two loops, on axis)
B2(z,I,a) = ((μ₀ * I * (a ^ 2)) / 2) * 
    ((1 / (((a ^ 2) + (z ^ 2)) ^ (3/2))) + 
     (1 / (((a ^ 2) + ((a - z) ^ 2)) ^ (3/2))))

# -----------END BIOT-SAVART ON AXIS-----------

# ----------BEGIN BIOT-SAVART OFF AXIS----------

# the full Biot-Savart equation (two loops, off axis)
B(z,I,N,a,ρ) = 
    ((μ₀ * I * N) / (2 * pi) ) *
    ( 
        (1 / sqrt(( (a + ρ) ^ 2) + ((a - z) ^ 2))) *
        ( 
            K(1,a,ρ,z) + 
            (
                (((a ^ 2) - (ρ ^ 2) - ((a - z) ^ 2)) / 
                 (((a - ρ) ^ 2) + ((a - z) ^ 2))) * 
                E(1,a,ρ,z)
            )
        ) +
        ( 
            (1 / sqrt(((a + ρ) ^ 2) + (z ^ 2))) * 
            (
                K(2,a,ρ,z) + 
                (
                    (((a ^ 2) - (ρ ^ 2) - (z ^ 2)) / 
                     (((a - ρ) ^ 2) + (z ^ 2))) * 
                    E(2,a,ρ,z)
                )
            ) 
        ) 
    )
        
# elliptic integrals of first kind (series expansion)
K(j,a,ρ,z, precision = 4) = 
    (pi / 2) * (
        1 + sum([ 
            ((reduce(*, [n - 1 for n in 2:2:precision]) / 
              reduce(*, [n for n in 2:2:precision])) ^ 2) * 
            (k(j,a,ρ,z) ^ n) 
            for n in 2:2:precision
        ])
    )
        
# elliptic integrals of the second kind (series expansion)
E(j,a,ρ,z, precision = 4) =
    (pi / 2) * (
        1 - foldl(-,[
            ((reduce(*, [n-1 for n in 2:2:precision]) / 
              reduce(*, [n for n in 2:2:precision])) ^ 2) * 
            ((k(j,a,ρ,z) ^ n) / (n-1))
            for n in 2:2:precision
        ])
    )
    
# the collections of variables k₁ and k₂
k(j,a,ρ,z) = (j == 1) ? 
    sqrt((4 * a * ρ) / (((a + ρ) ^ 2) + ((a - z) ^ 2))) :
    sqrt((4 * a * ρ) / (((a + ρ) ^ 2) + (z ^ 2)))

# -----------END BIOT-SAVART OFF AXIS-----------

println(B(0.2, 2, 70, .3, 0.1))
