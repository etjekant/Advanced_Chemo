function r_cal(x, y, y_hat)
    SS_tot = sum((y.-mean(y)).^2)
    SS_res = sum((y_hat-y).^2)
    Rsquared = 1 - (SS_res/SS_tot)
    VARres = SS_res/(length(x)-size(x)[2])         # calculating VARres
    VARtot = SS_tot/(length(x)-1)                            # calculating VARtot
    rsqadj = 1 - (VARres/VARtot)
    return Rsquared, rsqadj
end
function remove_shit(x_data, namen=[])
    if isempty(namen)
        namen = names(x_data)
    end
    namen = namen[vec(.!any(ismissing.(Matrix(x_data)), dims=1))]
    x_data = x_data[:, vec(.!any(ismissing.(Matrix(x_data)), dims=1))]
    namen = namen[vec(.!any(isnan.(Matrix(x_data)), dims=1))]
    x_data = x_data[:, vec(.!any(isnan.(Matrix(x_data)), dims=1))]
    namen = namen[vec(.!any(Inf.==(Matrix(x_data)), dims=1))]
    x_data = x_data[:, vec(.!any(Inf.==(Matrix(x_data)), dims=1))]
    namen = namen[vec(.!any((-Inf).==(Matrix(x_data)), dims=1))]
    x_data = x_data[:, vec(.!any((-Inf).==(Matrix(x_data)), dims=1))]
    return namen, x_data
end
function var_exp(X)
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
