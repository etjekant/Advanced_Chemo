# This document should provide every package you need for our julia project. If not, please at the packages and update this file
using CSV, CurveFit, DataFrames, Distributions, GLM, HypothesisTests, Interpolations
using Juno, LinearAlgebra, MixedAnova, OrderedCollections, Peaks, Plots, Random
using RDatasets, ScikitLearn, StatsBase, Statistics, StatsPlots
@sk_import decomposition: PCA
@sk_import linear_model: LogisticRegression
@sk_import preprocessing: StandardScaler
@sk_import model_selection: train_test_split
@sk_import ensemble: RandomForestClassifier
@sk_import ensemble: RandomForestRegressor
@sk_import ensemble: ExtraTreesRegressor

@sk_import model_selection: train_test_split;
include("General_functions.jl")
include("./PCA/PCA_functions.jl")
include("./SVD/SVD_functions.jl")
include("./MCR/MCR_functions.jl")
include("./TREE/TREE_functions.jl")


data = CSV.read("ConcData.csv", DataFrame)
data = vec(Matrix(data))

gamma_dist = fit_mle(Gamma, data)
plot(gamma_dist)
plot!(normal_dist)
histogram!(data, bins=5, normalize=true, alpha=0.5)

loop_vector = collect(2.5:0.01:10.5)
return_vector = zeros(length(collect(2.5:0.01:10.5)))

plot(loop_vector, return_vector)

x, y, namen = data_reading()
x_train, x_test, y_train, y_test = train_test_split(x, y)
model = ExtraTreesRegressor(n_estimators=100, min_samples_leaf=2).fit(x_train, y_train)
plot(y_test, model.predict(x_test), seriestype=:scatter)

function uncertainty_estimate(x, pri)
    target = collect(range(minimum(x), maximum(x), length=10000))
    post = zeros(length(target))
    for i in eachindex(target)
        dist = Normal(target[i], std(x))
        tv = 1
        for j in eachindex(x)
            tv *= pdf(dist, x[j]) * pdf(pri, x[j])
        end
        post[i] = tv
    end
    post = post ./ sum(post)
    return post, target
end

x = data
pri = gamma_dist
post, target = uncertainty_estimate(data, pri)
