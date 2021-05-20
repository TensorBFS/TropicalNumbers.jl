using Test
using TropicalNumbers

@testset "counting tropical" begin
    ct1 = CountingTropical(2.0, 4.0)
    ct2 = CountingTropical(2.0, 3.0)
    @test ct1 * true == ct1
    @test ct1 * false == CountingTropical(-Inf, 1.0)
    @test one(ct1) == CountingTropical(0.0, 1.0)
    @test zero(ct1) == CountingTropical(-Inf, 1.0)
    res1 = ct1 + ct2
    @test res1.n == 2
    @test res1.c == 7
    res2 = ct1 * ct2
    @test res2.n == 4
    @test res2.c == 12
    @test res2 ≈ CountingTropical(4, 12)
    println(CountingTropical{Float64}(3))

    ct1 = CountingTropical(2, 4)
    ct2 = CountingTropical(2.0, 3.0)
    @test CountingTropicalF64(ct1) === CountingTropical(2.0, 4.0)
    @test promote(ct1, ct2) === (CountingTropical(2.0, 4.0), ct2)

    @test CountingTropical{Float64}(2) === CountingTropical{Float64,Float64}(2.0, 1.0)
    @test CountingTropical{Int64, Float64}(2) === CountingTropical{Int64,Float64}(2, 1.0)
    @test CountingTropical{Int64, Float64}(TropicalF64(2)) === CountingTropical{Int64,Float64}(2, 1.0)
    @test CountingTropical{Int64, Float64}(CountingTropicalF64(2)) === CountingTropical{Int64,Float64}(2, 1.0)
    @test zero(CountingTropical{Int64,Float64}) === CountingTropical{Int64,Float64}(-999999, 0.0)
    @test one(CountingTropical{Int64,Float64}) === CountingTropical{Int64,Float64}(0, 1.0)

    @test promote(CountingTropical{Float64,Float32}(1, 2), CountingTropical{Int64,Int32}(1, 2)) == (CountingTropical{Float64,Float32}(1, 2), CountingTropical{Float64,Float32}(1, 2))
    @test promote(CountingTropical{Float64,Float32}(1, 2)) == (CountingTropical{Float64,Float32}(1, 2),)
    @test promote_type(CountingTropical{Float64,Float32}, CountingTropicalF32, CountingTropical{Int32,Int32}) == CountingTropical{Float64,Float32}
end
