x, y, namen = data_reading()
x_train, x_test, y_train, y_test = train_test_split(x, y)
X1 = x_train

chosen_columns = []


length_columns = length(chosen_columns);
R2_vector = zeros(size(X1, 2));
x2 = ones(size(x_train, 1), length_columns + 2);
x2test = ones(size(x_test, 1), length_columns + 2);
for j in eachindex(chosen_columns)
    x2[:, j+1] .= x_train[:, [j]]
    x2test[:, j+1] .= x_test[:, [j]]
end

for i in 1:size(x_train, 2)
    if i in chosen_columns
        R2_vector[i] = 0.0
        continue
    end
    x2[:, length_columns+2] .= x_train[:, i]
    x2test[:, length_columns+2] .= x_test[:, i]
    xt = transpose(x2)
    y_hat = x2test * pinv(xt * x2) * xt * y_train
    SSr = sum((y_test .- y_hat).^2)
    SSt = sum((y_test .- mean(y)).^2)
    R2_vector[i] = 1 - SSr/SSt 
end
R2_vector
println(maximum(R2_vector))
push!(chosen_columns, argmax(R2_vector))
plot(sort(R2_vector))

