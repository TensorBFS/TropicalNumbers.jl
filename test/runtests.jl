using TropicalNumbers
using Test, Documenter

@testset "tropical and or" begin
    include("tropical_andor.jl")
end

@testset "tropical max mul" begin
    include("tropical_maxmul.jl")
end

@testset "tropical min plus" begin
    include("tropical_minplus.jl")
end

@testset "tropical max plus" begin
    include("tropical_maxplus.jl")
end

@testset "counting_tropical" begin
    include("counting_tropical.jl")
end

doctest(TropicalNumbers)
