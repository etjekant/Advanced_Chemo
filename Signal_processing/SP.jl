using Distributions, LsqFit, CSV, DataFrames, Plots
data = CSV.read("ACS_1D_Signal.CSV", DataFrame)
data = Matrix(data)
x = data[:, 1]
y = data[:, 2]
plot(data[:,1], data[:, 2])

# HGT .* exp.(.-((Time.-Pos)./ Wdt).^2)
@. model(x, p) = (p[1] .* exp.(.-((x.-p[2])./ p[3]).^2)) + (p[4] .* exp.(.-((x.-p[5])./ p[6]).^2))

p0 = [100, 8, 0.5, 80, 9, 0.5]
ub = [Inf, Inf, Inf, Inf, Inf, Inf]
lb = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
fit = curve_fit(model, x, y, p0, lower=lb, upper=ub)
fit.param

peak1 = fit.param[1] .* exp.(.-((x .- fit.param[2])./ fit.param[3]).^2)
peak2 = fit.param[4] .* exp.(.-((x .- fit.param[5])./ fit.param[6]).^2)
plot!(x, peak1)
plot!(x, peak)


data = CSV.read("ACS_2D_Signal.CSV", DataFrame)
x = data[:, 1]
y = data[:, 2]
plot(x, y)
xlims!(95, 107)

scantime = 0.01
modtime = 10.0
modsize = Int(modtime/scantime)
datafolt = reshape(y, modsize, :)
Time2D = range(0, 10, length=modsize)
Time1D = range(0,218,length=1311)

heatmap(Time1D, Time2D, datafolt, clims=(0,1_000_000))
xlims!(95, 106)
ylims!(4.5,5.5)


sum_wrong_column = vec(sum(datafolt, dims=2))
plot(sum_wrong_column)
xlims!(450,550)
plot!(diff(sum_wrong_column))

@. model(x, p) = (p[1] .* exp.(.-((x.-p[2])./ p[3]).^2)) + (p[4] .* exp.(.-((x.-p[5])./ p[6]).^2))
# HGT .* exp.(.-((Time.-Pos)./ Wdt).^2)
p0 = [1.9*10^7, 470, 0.7, 1.8*10^7, 55, 0.5]
ub = [Inf, Inf, Inf, Inf, Inf, Inf]
lb = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
fit = curve_fit(model, collect(1:1000), sum_wrong_column, p0, lower=lb, upper=ub)
fit.param

peak1 = fit.param[1] .* exp.(.-((x .- fit.param[2])./ fit.param[3]).^2)
peak2 = fit.param[4] .* exp.(.-((x .- fit.param[5])./ fit.param[6]).^2)
