# Josh Tenenbaum's Number game

# Hypothesis space
struct Hypothesis
    name::String
    prior::Float64
    generator::Function
end

function sequence(hyp::Hypothesis, limit::Integer)
    return Lazy.range() |>
           x -> map(hyp.generator, x) |>
                x -> takewhile(y -> y <= limit, x) |> collect
end

function pmf(data::Integer, hyp::Hypothesis, limit::Integer)
    seq = sequence(hyp, limit)
    return data ∈ seq ? 1 / (seq |> length) : 0
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
           sum(likelihood.(Ref(data), hypSpace, limit) .*
               prior.(hypSpace, Ref(hypSpace)))
end
