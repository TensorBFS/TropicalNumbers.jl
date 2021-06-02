using Test
using TropicalNumbers
using TropicalNumbers: statictrues, staticfalses, StaticBitVector, onehot

@testset "static bit vector" begin
    @test statictrues(StaticBitVector{3,1}) == trues(3)
    @test staticfalses(StaticBitVector{3,1}) == falses(3)
    x = rand(Bool, 131)
    y = rand(Bool, 131)
    a = StaticBitVector(x)
    b = StaticBitVector(y)
    a2 = BitVector(x)
    b2 = BitVector(y)
    for op in [|, &, ⊻]
        @test op(a, b) == op.(a2, b2)
    end
    @test onehot(StaticBitVector{133,3}, 5) == (x = falses(133); x[5]=true; x)
end

@testset "counting tropical" begin
    function is_commutative_semiring(a::T, b::T, c::T) where T
        # +
        (a + b) + c == a + (b + c) &&
        a + zero(T) == zero(T) + a == a &&
        a + b == b + a &&
        # *
        (a * b) * c == a * (b * c) &&
        a * one(T) == one(T) * a == a &&
        a * b == b * a &&
        # more
        a * (b+c) == a*b + a*c &&
        (a+b) * c == a*c + b*c &&
        a * zero(T) == zero(T) * a == zero(T)
    end


    ct1 = ConfigTropical(2.0, [true, true, false, false, false])
    ct2 = ConfigTropical(4.0, [true, true, true, false, true])
    ct3 = ConfigTropical(3.0, [true, false, true, false, true])
    @test is_commutative_semiring(ct1, ct2, ct3)
    @test ct1 * true == ct1
    @test ct1 * false == zero(ct1)
    @test one(ct1) == ConfigTropical(0.0, falses(5))
    @test zero(ct1) == ConfigTropical(-Inf, trues(5))
    res1 = ct1 + ct2
    @test res1.n == 4
    @test res1.config == [true, true, true, false, true]
    res2 = ct1 * ct2
    @test res2.n == 6
    @test res2.config == [true, true, true, false, true]
    @test res2 ≈ ConfigTropical(6, [true, true, true, false, true])
    println(ConfigTropical{Float64, 4, 1}(3, rand(Bool, 4)))
end
