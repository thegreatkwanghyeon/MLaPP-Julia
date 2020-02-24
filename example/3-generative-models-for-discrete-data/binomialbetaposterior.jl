using Distributions

pointX = 0:0.01:1

p1 = plot(
    pointX,
    pdf.(Beta(2, 2), pointX),
    label = "prior Be(2.0, 2.0)",
    linecolor = :red,
    linewidth = 2,
    xticks = 0:0.1:1,
    grid = false
)

plot!(
    pointX,
    pdf.(Beta(5, 19), pointX),
    label = "lik Be(4.0, 18.0)",
    linecolor = :blue,
    linestyle = :dash,
    linewidth = 2
)

plot!(
    pointX,
    pdf.(Beta(4, 18), pointX),
    label = "post Be(5.0, 19.0)",
    linecolor = :black,
    linestyle = :dash,
    linewidth = 2
)

p2 = plot(
    pointX,
    pdf.(Beta(5, 2), pointX),
    label = "prior Be(5.0, 2.0)",
    linecolor = :red,
    linewidth = 2,
    xticks = 0:0.1:1,
    grid = false
)

plot!(
    pointX,
    pdf.(Beta(12, 14), pointX),
    label = "lik Be(12.0, 14.0)",
    linecolor = :blue,
    linestyle = :dash,
    linewidth = 2
)

plot!(
    pointX,
    pdf.(Beta(16, 15), pointX),
    label = "post Be(16.0, 15.0)",
    linecolor = :black,
    linestyle = :dash,
    linewidth = 2
)

result = plot(p1, p2, layout = grid(1, 2), size=(1200, 400))
png(result, "figure-3-6")
