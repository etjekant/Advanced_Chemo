function var_exp_svd(X)
    tmp = zeros(size(X, 2), size(X, 2))
    X_hat = zeros(size(X))
    var_exp = zeros(size(X,2))
    previous_var = 1
    xt = transpose(X)*X
    V = eigvecs(xt)
    eigenvalues = abs.(eigvals(xt))
    D = diagm(sqrt.(eigenvalues))
    U = X*V*pinv(D)
    for i in 1:size(D, 1)
        D_temp = deepcopy(D)
        D_temp[i,i] = 0
        LinearAlgebra.mul!(tmp, D_temp, V')
        LinearAlgebra.mul!(X_hat, U, tmp)
        var_exp[i] = (sum((X.-X_hat).^2)/sum(X.^2))
    end
    return var_exp
end
