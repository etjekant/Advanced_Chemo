x, y, namen, mono_mass = data_reading(mono_mass=true);
x, y = normalize_data(x, y)
x, namen = remove_shit(x, namen)

# Cleaning procedure before optimization
chosen_columns = []
prev_length = Inf64
while prev_length != length(namen)
    prev_length = length(namen) 
    println(length(namen))
    RF = RandomForestRegressor(n_estimators=100, min_samples_leaf=1, n_jobs=5)
    RF.fit(x, y)
    importance = RF.feature_importances_
    chosen_columns = sortperm(importance)[sort(importance).==0.0] 
    x = x[:, setdiff(1:end, chosen_columns)]
    namen = namen[setdiff(1:end, chosen_columns)]
end


# reading the data in after optimization
x = Matrix(CSV.read("X_data_tree_non.csv", DataFrame))
y = Matrix(CSV.read("Y_data_tree_non.csv", DataFrame))
y = vec(y)

x_train, x_test, y_train, y_test = train_test_split(x, y, random_state=42)
RF = RandomForestRegressor(n_estimators=100, min_samples_split=2, min_samples_leaf=2, max_features="auto", criterion="squared_error")
RF.fit(x_train, y_train);

RF.score(x_train, y_train)
RF.score(x_test, y_test)

RF.predict(x_test)
plot(y_test, RF.predict(x_test), seriestype=:scatter, xlim=(0, 7), ylim=(0, 7), label="Model")
plot!(collect(0:7), collect(0:7), label="Prefect senario")
xlabel!("Real LC50")
ylabel!("predicted LC50)")
title!("RandomForestRegressor Model")




# TRYING TO MAKE A CLASSIFIER MODEL
scores = Vector{Float64}(undef, 200)
for j in 2:200
    println(j)
    x, y, namen, mono_mass = data_reading(mono_mass=true);
    x, namen = remove_shit(x, namen)
    y_seq = group_maker(deepcopy(y), j)
    chosen_columns = []
    for i = 1:4
        x = x[:, setdiff(1:end, chosen_columns)]
        namen = namen[setdiff(1:end, chosen_columns)]
        RF = RandomForestClassifier(n_estimators=80, min_samples_leaf=1, n_jobs=-1)
        y_seq = group_maker(deepcopy(y), 50)
        RF.fit(x, y_seq)
        importance = RF.feature_importances_
        chosen_columns = sortperm(importance)[sort(importance).==0.0]    
    end
    x_train, x_test, y_train, y_test = train_test_split(x, y_seq)
    RF = RandomForestClassifier(n_estimators=100, min_samples_split=10, min_samples_leaf=2, max_features="sqrt", max_depth=13, n_jobs=-1)
    RF.fit(x_train, y_train)
    scores[j] = RF.score(x_test, y_test)
    Plots.display(plot(scores, seriestype=:scatter))
end
xlabel!("Number of groups")
ylabel!("Score")
