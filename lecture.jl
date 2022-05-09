function confusion_matrix(P::Int64, N::Int64, TP::Int64, TN::Int64)
    FP, FN = N - TN, P - TP
    TPR, TNR = TP / P, TN / N
    FNR, FPR = 1 - TPR, 1 - TNR 
    PPV, FOR = TP / (TP+FP), FN / (TN + FN)
    FDR, NPV = 1 - PPV, 1 - FOR
    return TPR, TNR, FNR, FPR, PPV, FOR, FDR, NPV
end 
confusion_matrix(4, 4, 3, 3)
confusion_matrix(4, 4, 3, 3)


truth = rand(0:1,100)
corr = rand(100)

thresh = 0:0.05:1
TPrate = zeros(length(thresh))
FPrate = zeros(length(thresh))

for i= 1:length(thresh)
    TP = sum((corr .>= thresh[i]) .& (truth .== 1))
    FN = sum((corr .< thresh[i]) .& (truth .== 1))
    FP = sum((corr .>= thresh[i]) .& (truth .== 0))
    TN = sum((corr.< thresh[i]) .& (truth .== 0))

    TPrate[i] = 100*TP/(TP+FN)
    FPrate[i] = 100*FP/(FP+TN)
end

scatter(FPrate, TPrate, zcolor = thresh, xlabel = "FP rate", ylabel = "TP rate")