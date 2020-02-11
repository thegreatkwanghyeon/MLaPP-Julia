using Lazy
using Plots

import Base: size
# Josh Tenenbaum's Number game

# Hypothesis space
struct Hypothesis
    name::String
    prior::Float64
    generator::Function
end

function createHypSpace()
    hypSpace = Vector{Hypothesis}()

    # All even numbers
    push!(hypSpace, Hypothesis("Even", 0.5, x -> x * 2))

    # All odd numbers
    push!(hypSpace, Hypothesis("Odd", 0.5, x -> x * 2 - 1))

    # All squared numbers
    push!(hypSpace, Hypothesis("Squares", 0.1, x -> x^2))

    # All multiples of k
    append!(hypSpace, map(k -> Hypothesis("Mult of $k", 0.1, x -> x * k), 3:10))

    # All numbers end in k
    append!(
        hypSpace,
        map(k -> Hypothesis("End in $k", 0.1, x -> (x - 1) * 10 + k), 1:9),
    )

    # All powers of k
    append!(hypSpace, map(k -> Hypothesis("Powers of $k", 0.1, x -> k^x), 2:10))

    # All numbers
    push!(hypSpace, Hypothesis("All", 0.1, x -> x))

    # Unnatrual hypotheses
    push!(
        hypSpace,
        Hypothesis("Powers of 2 + {37}", 0.001, x -> x == 1 ? 37 : 2^(x - 1)),
    )
    push!(
        hypSpace,
        Hypothesis("Powers of 2 - {32}", 0.001, x -> x < 5 ? 2^x : 2^(x + 1)),
    )

    return hypSpace
end

function pmf(data::Integer, hyp::Hypothesis, limit::Integer)
    space = Lazy.range() |>
            x -> map(hyp.generator, x) |> x -> takewhile(y -> y <= limit, x)

    return data ∈ space ? 1 / (space |> length) : 0
end

function likelihood(data::AbstractArray, hyp::Hypothesis, limit::Integer)
    return prod(pmf.(data, Ref(hyp), limit))
end

function prior(hyp::Hypothesis, hypSpace::Vector{Hypothesis})
    return hyp.prior / sum(h.prior for h in hypSpace)
end

function posterior(
    data::AbstractArray,
    hyp::Hypothesis,
    hypSpace::Vector{Hypothesis},
    limit::Integer,
)
    return likelihood(data, hyp, limit) * prior(hyp, hypSpace) /
           sum(likelihood.(Ref(data), hypSpace, l) .*
               prior.(hypSpace, Ref(hypSpace)))
end

hypSpace = createHypSpace()
hypNames = [h.name for h in hypSpace]
hypLength = length(hypSpace)
𝒟 = [16]
l = 100

bar1 = bar(
    prior.(hypSpace, Ref(hypSpace)),
    xlabel = "prior",
    xticks = (0:0.1:0.2),
    xlims = (0, 0.2),
    grid = false,
    legend = false,
    yticks = (1:hypLength, hypNames),
    orientation = :horizontal
)

bar2 = bar(
    likelihood.(Ref(𝒟), hypSpace, l),
    xlabel = "likelihood",
    xticks = (0:0.2:0.4),
    xlims = (0, 0.4),
    grid = false,
    legend = false,
    yticks = false,
    orientation = :horizontal
)

bar3 = bar(
    posterior.(Ref(𝒟), hypSpace, Ref(hypSpace), l),
    xlabel = "posterior",
    xticks = (0:0.2:0.4),
    xlims = (0, 0.4),
    grid = false,
    legend = false,
    yticks = false,
    orientation = :horizontal
)

plot(bar1, bar2, bar3, layout = grid(1, 3))
