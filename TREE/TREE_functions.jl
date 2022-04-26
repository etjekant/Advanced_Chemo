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
