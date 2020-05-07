import Test: @testset, @test

include("src.jl")

@testset "tvl_or truth table" begin
    @test @tvl_or(true, true) === true
    @test @tvl_or(true, false) === true
    @test @tvl_or(true, missing) === true
    @test @tvl_or(false, true) === true
    @test @tvl_or(false, false) === false
    @test @tvl_or(false, missing) === missing
    @test @tvl_or(missing, true) === true
    @test @tvl_or(missing, false) === missing
    @test @tvl_or(missing, missing) === missing
end

@testset "tvl_and truth table" begin
    @test @tvl_and(true, true) === true
    @test @tvl_and(true, false) === false
    @test @tvl_and(true, missing) === missing
    @test @tvl_and(false, true) === false
    @test @tvl_and(false, false) === false
    @test @tvl_and(false, missing) === false
    @test @tvl_and(missing, true) === missing
    @test @tvl_and(missing, false) === false
    @test @tvl_and(missing, missing) === missing
end

# We define a function that prints out a unique ID for each argument
# to a Boolean operator. By wrapping all Boolean values in calls to this
# function, we're able to check that the order of evaluation and
# side-effects of the short-circuiting operators are retained by our
# macro rewrites.

function f(io, i, x)
    print(io, i)
    x
end

@testset "Order of evaluation for tvl" begin
    for x in (true, false)
        for y in (true, false)
            for z in (true, false)
                io = IOBuffer()

                a = f(io, 1, x) && f(io, 2, y) || f(io, 3, z)
                order_a = String(take!(io))
                b = @tvl f(io, 1, x) && f(io, 2, y) || f(io, 3, z)
                order_b = String(take!(io))

                @test a === b
                @test order_a === order_b

                a = f(io, 1, x) || f(io, 2, y) && f(io, 3, z)
                order_a = String(take!(io))
                b = @tvl f(io, 1, x) || f(io, 2, y) && f(io, 3, z)
                order_b = String(take!(io))

                @test a === b
                @test order_a === order_b
            end
        end
    end
end
