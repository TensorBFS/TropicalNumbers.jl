using Test
using TropicalNumbers

@testset "TropicalMaxMul max mul" begin
    @test TropicalMaxMul(3) * TropicalMaxMul(4) == TropicalMaxMul(12)
    @test TropicalMaxMul(3) + TropicalMaxMul(4) == TropicalMaxMul(4)
    @test TropicalMaxMul(4) + TropicalMaxMul(1) == TropicalMaxMul(4)
    @test zero(TropicalMaxMul(2)).n == 0
    @test zero(TropicalMaxMul(2.0)) == TropicalMaxMul(0.0)
    @test one(TropicalMaxMul(2)) == TropicalMaxMul(1)
    @test TropicalMaxMul(2.0) ≈ TropicalMaxMul(2.0 + 1e-10)
    @test TropicalMaxMul(2) ≈ TropicalMaxMul(2.0)
    @test TropicalMaxMulF32(2.0).n isa Float32
    @test TropicalMaxMulF16(2.0).n isa Float16
    @test TropicalMaxMulF64(2.0).n isa Float64
    @test TropicalMaxMulI32(2).n isa Int32
    @test TropicalMaxMulI16(2).n isa Int16
    @test TropicalMaxMulI64(2).n isa Int64

    @test TropicalMaxMul(0//3) * TropicalMaxMul(1//3) == TropicalMaxMul(0//9)
    @test TropicalMaxMul(1//3) * TropicalMaxMul(0//3) == TropicalMaxMul(0//9)
    @test TropicalMaxMul(1//3) * TropicalMaxMul(1//3) == TropicalMaxMul(1//9)

    @test TropicalMaxMul(1//3) * TropicalMaxMul(1//0) == TropicalMaxMul(1//0)
    @test TropicalMaxMul(1//0) * TropicalMaxMul(1//1) == TropicalMaxMul(1//0)
    @test content(TropicalMaxMul(3.0)) == 3.0
    @test TropicalMaxMul{Float32}(TropicalMaxMul(0.0)) isa TropicalMaxMul{Float32}
    println(TropicalMaxMulF64(3))

    # promote and convert
    t1 = TropicalMaxMul(2)
    t2 = TropicalMaxMul(2.0)
    @test TropicalMaxMulF64(t1) === TropicalMaxMul(2.0)
    @test promote(t1, t2) === (TropicalMaxMul(2.0), t2)

    @test content(TropicalMaxMulF64) == Float64

    @test promote(TropicalMaxMul{Float64}(1), TropicalMaxMul{Int64}(2)) == (TropicalMaxMul{Float64}(1), TropicalMaxMul{Float64}(2))
    @test promote(TropicalMaxMul{Float64}(1)) == (TropicalMaxMul{Float64}(1),)
    @test promote_type(TropicalMaxMul{Float64}, TropicalMaxMulF32) == TropicalMaxMulF64
    @test promote_type(TropicalMaxMul{Float64}, TropicalMaxMulF32, TropicalMaxMul{Int32}) == TropicalMaxMulF64

    @test TropicalMaxMul(3) / TropicalMaxMul(4) == TropicalMaxMul(3 / 4)
    @test TropicalMaxMul(3) ÷ TropicalMaxMul(4) == TropicalMaxMul(3 ÷ 4)
    @test inv(TropicalMaxMul(3)) == TropicalMaxMul(1/3)

    x = TropicalMaxMul(2.0)
    @test x * true == x * one(x)
    @test x / true == x / one(x)
    @test x ÷ true == x ÷ one(x)
    @test x * false == x * zero(x)
    @test x / false == x / zero(x)
    # @test x ÷ false == x / zero(x)
    @test isnan(x ÷ false)
    @test true * x == one(x) * x
    @test true / x == one(x) / x
    @test true ÷ x == one(x) ÷ x
    @test false * x == zero(x) * x
    @test false / x == zero(x) / x
    @test false ÷ x == zero(x) ÷ x
    @test isnan(TropicalMaxMul(NaN))
    @test !isnan(TropicalMaxMul(Inf))

    @test TropicalMaxMul(2.0) ^ 3.0 == TropicalMaxMul(2.0) * TropicalMaxMul(2.0) * TropicalMaxMul(2.0)
    @test TropicalMaxMul(2.0) ^ 3 == TropicalMaxMul(2.0) * TropicalMaxMul(2.0) * TropicalMaxMul(2.0)
end
