data = CSV.read("/Users/ikram/Documents/Master/March-May 2022/Advanced Chemometrics and Statistics/Project /toxicity_data_fish_desc.csv", DataFrame)
descr = describe(data)

x = data[:, 8:end]
namen, x = remove_shit(x);
x = Matrix(x)
namen = namen

plot = scatter(x)

@sk_import decomposition: PCA

function Principal_Component_Analysis(x)
    m = mean(x, dims = 1)
    Tox_mc = x .- m
    cov_m = cov(Tox_mc)         #Covariance matrix
    eigvec = eigvecs(cov_m)
    eigval = eigvals(cov_m)     #Lambda and v calculations
    sortp = sortperm(eigval, rev=true)      #Sort based on explained variance
    eigvec = eigvec[:, sortp]
    eigval = eigval[sortp]
    var_ex = cumsum(eigval) ./ sum(eigval)
    loadings = eigvec[:,1:size(Tox_mc,1)]
    scores = (loadings' * Tox_mc')'
    return var_ex, scores
end  

var_ex, scores = Principal_Component_Analysis(x)

scatter(var_ex)

#plot(scores[:,1], scores[:,2], scores[:,3], seriestype = :scatter, 
           # xlabel = :PC1, ylabel = :PC2, zlabel = :PC3)


scatter(scores[:,1], scores[:,2], scores[:,3], seriestype = :scatter, 
            xlabel = :PC1, ylabel = :PC2, zlabel = :PC3)

            test