function node_finder(x, y)
    SSₑ = zeros(size(x))
    for i in 1:size(x, 1)
        for j = 1:size(x, 2)
            llocs = x[:, j] .<= x[i, j]
            SSₑ_left = sum((y[llocs] .- mean(y[llocs])).^2)
            llocs = x[:, j] .> x[i, j]
            SSₑ_right = sum((y[llocs] .- mean(y[llocs])).^2)
            SSₑ[i, j] = SSₑ_left + SSₑ_right
        end
    end
    node = argmin(SSₑ)
    return node, SSₑ
end

 function group_maker(y, group)
    tmp = zeros(length(y))
    y_mean = mean(y)
    y_std = std(y, mean=y_mean)
    groups = collect(1:group)
    d = Normal(y_mean, y_std)
    groups = (1/group .* groups) 
    groups .= quantile(d, groups)
    pushfirst!(groups, -Inf64)

    for i in 1:length(groups)-1
        tmp[groups[i] .< y .< groups[i+1]] .= i
    end
    return tmp
end
