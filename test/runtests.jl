using TropicalNumbers
using Test

@testset "base" begin
    include("base.jl")
end

@testset "counting_tropical" begin
    include("counting_tropical.jl")
end
