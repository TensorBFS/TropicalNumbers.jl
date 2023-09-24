using Test
using TropicalNumbers

@testset "TropicalMaxPlus" begin
    @test TropicalMaxPlus(3) * TropicalMaxPlus(4) == TropicalMaxPlus(7)
    @test TropicalMaxPlus(3) + TropicalMaxPlus(4) == TropicalMaxPlus(4)
    @test TropicalMaxPlus(4) + TropicalMaxPlus(-1) == TropicalMaxPlus(4)
    @test zero(TropicalMaxPlus(2)).n .< -99999
    @test zero(TropicalMaxPlus(2.0)) == TropicalMaxPlus(-Inf)
    @test one(TropicalMaxPlus(2)) == TropicalMaxPlus(0)
    @test TropicalMaxPlus(2.0) ≈ TropicalMaxPlus(2.0 + 1e-10)
    @test TropicalMaxPlus(2) ≈ TropicalMaxPlus(2.0)
    @test TropicalMaxPlusF32(2.0).n isa Float32
    @test TropicalMaxPlusF16(2.0).n isa Float16
    @test TropicalMaxPlusF64(2.0).n isa Float64

    @test TropicalMaxPlus(0//3) * TropicalMaxPlus(1//3) == TropicalMaxPlus(1//3)
    @test TropicalMaxPlus(1//3) * TropicalMaxPlus(0//3) == TropicalMaxPlus(1//3)
    @test TropicalMaxPlus(1//3) * TropicalMaxPlus(1//3) == TropicalMaxPlus(2//3)

    @test TropicalMaxPlus(1//3) * TropicalMaxPlus(1//0) == TropicalMaxPlus(1//0)
    @test TropicalMaxPlus(1//3) * TropicalMaxPlus(-1//0) == TropicalMaxPlus(-1//0)
    @test TropicalMaxPlus(1//0) * TropicalMaxPlus(1//1) == TropicalMaxPlus(1//0)
    @test TropicalMaxPlus(-1//0) * TropicalMaxPlus(-1//1) == TropicalMaxPlus(-1//0)
    @test content(TropicalMaxPlus(3.0)) == 3.0
    @test TropicalMaxPlus{Float32}(TropicalMaxPlus(0.0)) isa TropicalMaxPlus{Float32}
    println(TropicalMaxPlusF64(3))

    # promote and convert
    t1 = TropicalMaxPlus(2)
    t2 = TropicalMaxPlus(2.0)
    @test TropicalMaxPlusF64(t1) === TropicalMaxPlus(2.0)
    @test promote(t1, t2) === (TropicalMaxPlus(2.0), t2)

    @test content(TropicalMaxPlusF64) == Float64

    @test promote(TropicalMaxPlus{Float64}(1), TropicalMaxPlus{Int64}(2)) == (TropicalMaxPlus{Float64}(1), TropicalMaxPlus{Float64}(2))
    @test promote(TropicalMaxPlus{Float64}(1)) == (TropicalMaxPlus{Float64}(1),)
    @test promote_type(TropicalMaxPlus{Float64}, TropicalMaxPlusF32) == TropicalMaxPlusF64
    @test promote_type(TropicalMaxPlus{Float64}, TropicalMaxPlusF32, TropicalMaxPlus{Int32}) == TropicalMaxPlusF64

    @test TropicalMaxPlus(3) / TropicalMaxPlus(4) == TropicalMaxPlus(-1)
    @test TropicalMaxPlus(3) ÷ TropicalMaxPlus(4) == TropicalMaxPlus(-1)
    @test inv(TropicalMaxPlus(3)) == TropicalMaxPlus(-3)

    x = TropicalMaxPlus(2.0)
    @test x * true == x * one(x)
    @test x / true == x / one(x)
    @test x ÷ true == x ÷ one(x)
    @test x * false == x * zero(x)
    @test x / false == x / zero(x)
    @test x ÷ false == x ÷ zero(x)
    @test true * x == one(x) * x
    @test true / x == one(x) / x
    @test true ÷ x == one(x) ÷ x
    @test false * x == zero(x) * x
    @test false / x == zero(x) / x
    @test false ÷ x == zero(x) ÷ x
    @test isnan(TropicalMaxPlus(NaN))
    @test !isnan(TropicalMaxPlus(-Inf))

    @test TropicalMaxPlus(2.0) ^ 3.0 == TropicalMaxPlus(2.0) * TropicalMaxPlus(2.0) * TropicalMaxPlus(2.0)
    @test TropicalMaxPlus(2.0) ^ 3 == TropicalMaxPlus(2.0) * TropicalMaxPlus(2.0) * TropicalMaxPlus(2.0)
end
