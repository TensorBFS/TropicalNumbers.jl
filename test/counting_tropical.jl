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
end
