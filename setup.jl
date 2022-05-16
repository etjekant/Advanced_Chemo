# This document should provide every package you need for our julia project. If not, please add the packages and update this file
using Clustering, CSV, CurveFit, DataFrames, Distributions, GLM, HypothesisTests, Interpolations
using Juno, LinearAlgebra, MixedAnova, OrderedCollections, Peaks, Plots, Random
using RDatasets, ScikitLearn, StatsBase, Statistics, StatsPlots
@sk_import decomposition: PCA
@sk_import linear_model: LogisticRegression
@sk_import preprocessing: StandardScaler
@sk_import model_selection: train_test_split
