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