
#prepearing the data
x, y, namen = data_reading()
x, y = normalize_data(x, y, "std")
namen, x = remove_shit(x, namen)

@sk_import cross_decomposition: PLSRegression
@sk_import model_selection: train_test_split
@sk_import model_selection:cross_val_score

x_train, x_test, y_train, y_test = train_test_split(x, y, test_size = 0.3, random_state = 42)
SSe = []
for i in 1:30
    plsc = PLSRegression(n_components = i)
    plsc.fit(x_train, y_train)

    y_pred = plsc.predict(x_test)
    SS = sum((y_test .- y_pred).^2)
    push!(SSe, SS)

end
scatter(SSe, xlabel="n components", ylabel="SSe", legend=false)
# from the plot we see that min error is at n_components = 4.
plsc = PLSRegression(n_components = argmin(SSe))
plsc.fit(X_train, y_train)

y_pred = plsc.predict(X_test)
scatter(y_test, y_pred, xlabel="Y Test", ylabel="Y Predicted", legend=false)

pls = PLSRegression(n_components=1)
pls.fit(X_train, y_train)

scatter(pls.transform(X_test), y_test, alpha=0.3, label="ground truth")
scatter!(
    pls.transform(X_test), pls.predict(X_test), alpha=0.3, label="predictions",
    xlabel="Projected data onto first PLS component", ylabel="y", title="PLS"
    )

    