using Distributions

priorA = 2
priorB = 2
n1 = 3
n2 = 17
pointX = 0:10

bar1 = bar(
    pdf.(BetaBinomial(10, priorA + n1, priorB + n2), pointX),
    title = "Posterior predictive",
    xticks = 0:10,
    xlims = (0, 10),
    yticks = 0:0.05:0.35,
    ylims = (0, 0.35),
    grid = false,
    legend = false
)

bar2 = bar(
    pdf.(Binomial(10, (n1 + 1) / (n1 + n2 + 2)), pointX),
    title = "Plugin predictive",
    xticks = 0:10,
    xlims = (0, 10),
    yticks = 0:0.05:0.35,
    ylims = (0, 0.35),
    grid = false,
    legend = false
)

result = plot(bar1, bar2, grid = 2, size=(1000, 600))
png(result, "figure-3-7")
