using MlappToolkit
using Plots

# Fig 3-2

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
    orientation = :horizontal,
)

bar2 = bar(
    likelihood.(Ref(𝒟), hypSpace, l),
    xlabel = "likelihood",
    xticks = (0:0.2:0.4),
    xlims = (0, 0.4),
    grid = false,
    legend = false,
    yticks = false,
    orientation = :horizontal,
)

bar3 = bar(
    posterior.(Ref(𝒟), hypSpace, Ref(hypSpace), l),
    xlabel = "posterior",
    xticks = (0:0.2:0.4),
    xlims = (0, 0.4),
    grid = false,
    legend = false,
    yticks = false,
    orientation = :horizontal,
)

result = plot(bar1, bar2, bar3, layout = grid(1, 3))
png(result, "figure-3-2")


# Fig 3-3

𝒟 = [16, 8, 2, 64]

bar1 = bar(
    prior.(hypSpace, Ref(hypSpace)),
    xlabel = "prior",
    xticks = (0:0.1:0.2),
    xlims = (0, 0.2),
    grid = false,
    legend = false,
    yticks = (1:hypLength, hypNames),
    orientation = :horizontal,
)

bar2 = bar(
    likelihood.(Ref(𝒟), hypSpace, l),
    xlabel = "likelihood",
    xticks = (0:0.001:0.002),
    xlims = (0, 0.002),
    grid = false,
    legend = false,
    yticks = false,
    orientation = :horizontal,
)

bar3 = bar(
    posterior.(Ref(𝒟), hypSpace, Ref(hypSpace), l),
    xlabel = "posterior",
    xticks = (0:0.5:1.0),
    xlims = (0, 0.4),
    grid = false,
    legend = false,
    yticks = false,
    orientation = :horizontal,
)

result = plot(bar1, bar2, bar3, layout = grid(1, 3))
png(result, "figure-3-3")


# Fig 3-4

hypSpace2 = Vector{Hypothesis}()
𝒟 = 16

push!(hypSpace2, Hypothesis("Powers of 4", 0.1, x -> 4^x))
push!(hypSpace2, Hypothesis("Powers of 2", 0.1, x -> 2^x))
push!(hypSpace2, Hypothesis("End in 6", 0.1, x -> (x - 1) * 10 + 6))
push!(hypSpace2, Hypothesis("Squares", 0.1, x -> x^2))
push!(hypSpace2, Hypothesis("Even", 0.5, x -> x * 2))
push!(hypSpace2, Hypothesis("Mult of 8", 0.1, x -> x * 8))
push!(hypSpace2, Hypothesis("Mult of 4", 0.1, x -> x * 4))
push!(hypSpace2, Hypothesis("All", 0.1, x -> x))
push!(
    hypSpace2,
    Hypothesis("Powers of 2 + {37}", 0.001, x -> x == 1 ? 37 : 2^(x - 1)),
)
push!(
    hypSpace2,
    Hypothesis("Powers of 2 - {32}", 0.001, x -> x < 5 ? 2^x : 2^(x + 1)),
)

hypNames2 = [h.name for h in hypSpace2]
hypLength2 = length(hypSpace2)

dataX = Vector{Integer}()
dataY = Vector{Integer}()

for (i, h) in enumerate(hypSpace2)
    seq = sequence(h, l)
    append!(dataX, seq)
    append!(dataY, repeat([hypLength2 - i + 1], seq |> length))
end

p1 = histogram(dataX,
    bins = 0:100,
    xticks = 4:4:100,
    xlims = (0, 100),
    yaxis = false,
    tickfontsize = 6,
    grid = false,
    legend = false
)

p2 = scatter(dataX, dataY,
    xticks = false,
    yticks = (1:hypLength, reverse(hypNames2)),
    xaxis = false,
    xlims = (0, 100),
    ylims = (0, 11),
    legend = false,
    tickdir = :out
)


p3 = plot(
    posterior.(Ref([16]), hypSpace2, Ref(hypSpace2), l),
    reverse(1:10),
    shape = :circle,
    xlims = (0, 1),
    xticks = 0:0.5:1,
    xlabel = "p(h|16)",
    yticks = false,
    ylims = (0, 11),
    grid = false,
    legend = false
)

empty = plot(
    axis = false,
    grid = false,
    legend = false
)

g = @layout [a{0.2h} b; c{0.8w} d{0.2w}]

result = plot(p1, empty, p2, p3, layout = g)
png(result, "figure-3-4")
