using MlappToolkit
using Lazy
using Plots

import Base: size


# Fig 3-2

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
    orientation = :horizontal
)

bar2 = bar(
    likelihood.(Ref(𝒟), hypSpace, l),
    xlabel = "likelihood",
    xticks = (0:0.001:0.002),
    xlims = (0, 0.002),
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

result = plot(bar1, bar2, bar3, layout = grid(1, 3))
png(result, "figure-3-4")
