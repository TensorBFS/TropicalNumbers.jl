module TropicalNumbers

export Tropical, TropicalF64, TropicalF32, TropicalF16, CountingTropicalF16, CountingTropicalF32, CountingTropicalF64, content
export CountingTropical
export TropicalTypes


include("tropical.jl")
include("counting_tropical.jl")

const TropicalTypes{T} = Union{CountingTropical{T}, Tropical{T}}

for T in [:Tropical, :CountingTropical]
    # defining constants like `TropicalF64`.
    for NBIT in [16, 32, 64]
        @eval const $(Symbol(T, :F, NBIT)) = $T{$(Symbol(:Float, NBIT))}
    end
    for OP in [:>, :<, :(==), :>=, :<=, :isless]
        @eval Base.$OP(a::$T, b::$T) = $OP(a.n, b.n)
    end
    @eval begin
        # promotion rules
        Base.promote_rule(::Type{$T{T1}}, b::Type{$T{T2}}) where {T1, T2} = $T{promote_rule(T1, T2)}
        Base.promote_rule(::Type{$T{T1}}, b::Type{$T{Union{}}}) where {T1} = $T{T1}
        Base.promote_rule(::Type{$T{Union{}}}, b::Type{$T{T2}}) where {T2} = $T{T2}

        content(x::$T) = x.n
        Base.isapprox(x::AbstractArray{<:$T}, y::AbstractArray{<:$T}; kwargs...) = all(isapprox.(x, y; kwargs...))
        Base.show(io::IO, ::MIME"text/plain", t::$T) = Base.show(io, t)

        # this is for CUDA matmul
        Base.:(*)(a::$T, b::Bool) = b ? a : zero(a)
        Base.:(*)(b::Bool, a::$T) = b ? a : zero(a)
    end
end

end # module