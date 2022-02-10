using TropicalNumbers
using Test, Documenter

@testset "tropical" begin
    include("tropical.jl")
end

@testset "counting_tropical" begin
    include("counting_tropical.jl")
end

doctest(TropicalNumbers)
