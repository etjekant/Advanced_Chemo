x, y, namen, mono_mass = data_reading(mono_mass=true);
x, namen = remove_shit(x, namen)
chosen_columns = []
for i = 1:6
    x = x[:, setdiff(1:end, chosen_columns)]
    namen = namen[setdiff(1:end, chosen_columns)]
    RF = RandomForestRegressor(n_estimators=100, min_samples_leaf=1, n_jobs=-1)
    RF.fit(x, y)
    importance = RF.feature_importances_
    println(RF.score(x, y))
    chosen_columns = sortperm(importance)[sort(importance).==0.0]    
end
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
y_seq = group_maker(y, 5)



chosen_columns = []
for i = 1:4
    x = x[:, setdiff(1:end, chosen_columns)]
    println(size(x))
    namen = namen[setdiff(1:end, chosen_columns)]
    RF = RandomForestClassifier(n_estimators=80, min_samples_leaf=1, max_features=size(x, 2), n_jobs=-1)
    RF.fit(x, y_seq)
    importance = RF.feature_importances_
    println(RF.score(x, y_seq))
    chosen_columns = sortperm(importance)[sort(importance).==0.0]    
end

x_train, x_test, y_train, y_test = train_test_split(x, y_seq)
RF = RandomForestClassifier(n_estimators=100, min_samples_leaf=5,  max_features=size(x_train, 2), n_jobs=-1)
RF.fit(x_train, y_train)
RF.score(x_train, y_train)
RF.score(x_test, y_test)

