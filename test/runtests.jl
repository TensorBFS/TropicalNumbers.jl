using TropicalNumbers
using Test

@testset "tropical" begin
    include("tropical.jl")
end

@testset "counting_tropical" begin
    include("counting_tropical.jl")
end
