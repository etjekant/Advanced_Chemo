x, y, namen, mono_mass = data_reading(mono_mass=true);
# x, y = normalize_data(x, y)
x, namen = remove_shit(x, namen)


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

CSV.write("X_data_tree_non.csv", DataFrame(x, namen))
CSV.write("y_data_tree_non.csv", DataFrame("y_data"=>y))


x_train, x_test, y_train, y_test = train_test_split(x, y)
RF = RandomForestRegressor(n_estimators=100, min_samples_split=2, min_samples_leaf=2, max_features="auto", max_depth=7, criterion="squared_error")
RF.fit(x_train, y_train);

RF.score(x_train, y_train)
RF.score(x_test, y_test)
y_test
RF.predict(x_test)
plot(y_test, RF.predict(x_test), seriestype=:scatter)



# TRYING TO MAKE A cLASSIFIER MODEL
x, y, namen, mono_mass = data_reading(mono_mass=true);
x, namen = remove_shit(x, namen)
scores = Vector{Float64}(undef, 200)
for j in 2:200
    println(j)
    y_seq = group_maker(deepcopy(y), j)
    chosen_columns = []
    for i = 1:4
        x = x[:, setdiff(1:end, chosen_columns)]
        namen = namen[setdiff(1:end, chosen_columns)]
        RF = RandomForestRegressor(n_estimators=80, min_samples_leaf=1, n_jobs=-1)
        RF.fit(x, y_seq)
        importance = RF.feature_importances_
        chosen_columns = sortperm(importance)[sort(importance).==0.0]    
    end

    x_train, x_test, y_train, y_test = train_test_split(x, y_seq)
    RF = RandomForestRegressor(n_estimators=100, min_samples_split=10, min_samples_leaf=2, max_features="sqrt", max_depth=13, n_jobs=-1)
    RF.fit(x_train, y_train)
    scores[j] = RF.score(x_test, y_test)
    Plots.display(plot(scores, seriestype=:scatter))
end
plot(scores, seriestype=:scatter)

