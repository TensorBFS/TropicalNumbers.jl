using TropicalNumbers
using Test, Documenter

@testset "tropical" begin
    include("tropical.jl")
    include("tropical_andor.jl")
    include("tropical_maxmul.jl")
    include("tropical_minplus.jl")
    include("tropical_maxplus.jl")
end

@testset "counting_tropical" begin
    include("counting_tropical.jl")
end

doctest(TropicalNumbers)
