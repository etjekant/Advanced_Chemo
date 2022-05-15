function find_best_columns(x1, y)
    return_vector = Vector{Float64}(undef, size(x1, 2))
    previous_value = -Inf64
    x1 = x
    for j in 1:size(x1)[2]
        x2 = [ones(907) x1[:, j]]
        y_hat = x2 * pinv(x2' * x2) * x2' * y 
        return_data = r_cal(x2, y, y_hat)
        push!(return_df, return_data);
        R2_adj = return_data[2];
        return_vector[j] = R2_adj
    end
    println(sortperm(return_vector))
    selection = size(x1)[2] - nrow(return_df) : size(x1)[2]
    return selection, return_df
end

function columns_test_set(x1, y)
    