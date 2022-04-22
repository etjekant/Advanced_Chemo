function suffle_PCA(X1, alpha=0.05)
    # Need to add sorting of the data. in our case this does not matter. but might be needed for other data

    significant_columns = 0
    cov_m = cov(X1);
    eigval = eigvals(cov_m)
    eigvec =  eigvecs(cov_m);
    loadings = eigvec;
    scores = (loadings'*X1')' 
    for i in 1:size(X1)[2]
        return_data = []
        for j in 1:50
            for col in eachcol(X1)
                shuffle!(col)
            end
            println("$i, $j")
            cov_m = cov(X1);
            eigval_in = eigvals(cov_m)[end-i+1];
            push!(return_data, eigval_in)
        end
    mean_return = mean(return_data)
    std_return = std(return_data)
    t_crit = quantile(TDist(length(return_data)), 1-alpha/2)
    upper = mean_return + std_return * t_crit
    if eigval[end-i+1] < upper
        break
    end
    significant_columns = i
    X1 = X1 - scores * loadings' 
    end
    return significant_columns
end

function var_exp(X)
    # This function is selfwritten and takes in the X-data. This function needs to be changes into Denises variant
    xt = transpose(X)*X
    V = eigvecs(xt)
    # had to use abs, the first values became small and negative
    # No column with a negative eigenvalue has been chosen.
    eigenvalues = abs.(eigvals(xt))
    D = diagm(sqrt.(eigenvalues))
    U = X*V*pinv(D)
    D_vec = diag(D)
    var_explained = Vector{Float64}(undef, length(D_vec))
    for i in 1:length(D_vec)
        println(i)
        tmp_vec = deepcopy(D_vec)
        for j in 1:length(D_vec)
            if i != j
                tmp_vec[j] = 0
            end
        end
        X_hat = U*diagm(tmp_vec)*V'
        var_explained[i] = (1 - sum((X.-X_hat).^2) / sum(X.^2))
    end
    return var_explained
end