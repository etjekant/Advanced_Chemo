function r_cal(x, y, y_hat)
    # r_cal takes as input three vectors of the same length. 
    SS_tot = sum((y.-mean(y)).^2)
    SS_res = sum((y_hat-y).^2)
    Rsquared = 1 - (SS_res/SS_tot)
    VARres = SS_res/(length(x)-size(x)[2])         # calculating VARres
    VARtot = SS_tot/(length(x)-1)                            # calculating VARtot
    rsqadj = 1 - (VARres/VARtot)
    return Rsquared, rsqadj
end

function remove_shit(x_data, namen=[])
    # This function takes a Dataframe or Matrix as input. 
    # When a DataFrame is given "namen" can be left empty. When a 
    # Matrix is given, namen should be spicified. This makes sure the column headers
    # are known when working with the data. 
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
    # This function is selfwritten and takes in the X-data. This function needs to be changes into Denises variant
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
                                                
function distance_calc(N)
    # This function calculates the distance for the one-dementional data. the input is a vector of data. 
    dist = zeros(size(N, 1), size(N, 1))
    for i = 1:size(N, 1)-1
        for j = i + 1:size(N,1)
            dist[j,i] = mean(N[j]) - mean(N[i])
        end
    end
    dist += dist'
    return abs.(dist)
end

function distance_calc_higher(data)
    # This function calculates the distance for higher order datasets. can be used with any shape. 
    dist = zeros(size(data, 1), size(data, 1))
    for i = 1:size(data, 1)-1
        for j = i + 1:size(data,1)
            dist[j,i] = sqrt(sum((data[i, :] .- data[j, :]).^2))
        end
    end
    return dist += dist'
end                                                              
                                                                
function MCR_simple(Data1, factor)
    (S_Simple,C_Simple, obs) = SIMPLE(Data1'; Factors = factor)
    obs
    S_SIMP = reshape(S_Simple,size(Data1)[2],factor)'
    (C_S, S_S, err) = MCR_ALS_jw_March29(Data1, nothing, S_SIMP;
                                        Factors = factor,
                                        maxiters = 20,
                                        norm = (false, false),
                                        nonnegative = (true, true),
                                        unimodalC = false,
                                        unimodalS = false,
                                        fixedunimodal = false )

    p1 = plot(C_S);
    p2 = plot(S_S');
    # Compare to their "true" values
    p1 = plot(Wavelength,PURE[1:2:5,:]');
    p2 = plot(S_S');
    c2 = plot(C_S);
    c1 = plot(Conc_mix);
    E_S = Data1 - C_S*S_S;
    Esq_S = E_S.*E_S;
    Esq_S_c = sum(Esq_S, dims = 1)
    Esq_S_r = sum(Esq_S, dims = 2)
    p6 = plot(Esq_S_c', legend = false);
    p5 = plot(Esq_S_r, legend = false);
    plot(p1,p2,p6,c1,c2,p5,layout = (2,3))
end

function NMF(X; Factors = 1, tolerance = 1e-7, maxiters = 200)
    # NMF(X; Factors = 1, tolerance = 1e-7, maxiters = 200)
    # Performs a variation of non-negative matrix factorization on Array `X` and returns the a 2-Tuple of (Concentration Profile, Spectra)
    # *Note: This is not a coordinate descent based NMF. This is a simple fast version which works well enough for chemical signals*
    # Algorithms for non-negative matrix factorization. Daniel D. Lee. H. Sebastian Seung. NIPS'00 Proceedings of the 13th International Conference on Neural Information Processing Systems. 535-54

    (Obs, Vars) = size(X)
    W = abs.( randn( Obs , Factors ) )
    H = abs.( randn( Factors, Vars ) )

    Last = zeros(Obs,Vars)
    tolerancesq = tolerance ^ 2
    iters = 0
    #Monitor change in F norm...
    while (sum( ( Last .- W * H ) .^ 2)  > tolerancesq) && (iters < maxiters)
        Last = W * H
        H .*= ( W' * X ) ./ ( W' * W * H )
        W .*= ( X * H' ) ./ ( W * H * H')
        iters += 1
    end
    return (W, H)
end

#SIMPLE(X; Factors = 1, alpha = 0.05, includedvars = 1:size(X)[2], SecondDeriv = true)
#Performs SIMPLISMA on Array `X` using either the raw spectra or the Second Derivative spectra.
#alpha can be set to reduce contributions of baseline, and a list of included variables in the determination
#of pure variables may also be provided.
#Returns a tuple of the following form: (Concentraion Profile, Pure Spectral Estimates, Pure Variables)
#W. Windig, Spectral Data Files for Self-Modeling Curve Resolution with Examples Using the SIMPLISMA Approach, Chemometrics and Intelligent Laboratory Systems, 36, 1997, 3-16.
#"""
function SIMPLE(X; Factors = 1, alpha = 0.05, includedvars = 1:size(X)[2],
    SecondDeriv = false)
    Xcpy = deepcopy(X)
    X = X[:,includedvars]
    if SecondDeriv
        X = map( x -> max( x, 0.0 ), -SecondDerivative( X ) )
    end
    purvarindex = []
    (obs, vars) = size(X)
    pureX = zeros( Factors, vars )
    weights = zeros( vars )

    Col_Std = Statistics.std(X, dims = 1) .* sqrt( (obs - 1) / obs);
    Col_Mu = Statistics.mean(X, dims = 1);
    Robust_Col_Mu = Col_Mu .+ (alpha .* reduce(max, Col_Mu) );
    NormFactor = sqrt.( ((Col_Std .+ Robust_Col_Mu).^ 2) .+ (Col_Mu .^ 2) )
    Xp = X ./ NormFactor

    purity = Col_Std ./ Robust_Col_Mu

    for i in 1 : (Factors)
        for j in 1 : vars
            purvarmatrix = Xp[ : , vcat( purvarindex, j) ] ;
            O = (purvarmatrix' * purvarmatrix) ./ obs
            weights[j] = det( O );
        end
        purity_Spec = weights .* purity'
        push!(purvarindex, argmax(purity_Spec)[1])
        pureX[i,:] = purity_Spec;
    end
    pureinX = Xcpy[ : , includedvars[purvarindex] ]
    purespectra = pureinX \ Xcpy
    pureabundance = Xcpy / purespectra

    # scale = LinearAlgebra.Diagonal(1.0 ./ sum(pureabundance, dims = 2))
    # pureabundance = pureabundance * scale
    # purespectra = Base.inv( scale ) * purespectra
    return (pureabundance, purespectra, includedvars[purvarindex])
end

# FNNLS( A, b; maxiters = 500 )
# Uses an implementation of Bro et. al's Fast Non-Negative Least Squares on the matrix `A` and vector `b`.
# Returns regression coefficients in the form of a vector.
# Bro, R., de Jong, S. (1997) A fast non-negativity-constrained least squares algorithm. Journal of Chemometrics, 11, 393-401.
function FNNLS(A, b; maxiters = 500)
    ATA = A' * A
    ATb = A' * b
    X = zeros( size( ATA )[ 2 ] )
    tolerance = eps(Float16) * reduce(max,sum(abs.(ATA), dims = 1)) * prod(size(ATb))
    P = zeros( size( ATA )[ 2 ] ) .|> Int
    R = collect( 1 : length( ATb ) ) .|> Int
    r = zeros( size( ATA )[ 2 ] )
    Inds = collect( 1 : length( ATb ) ) .|> Int
    Rinds = collect( 1 : length( ATb ) ) .|> Int

    W = ATb
    inneriters = 0
    zeroint = 0 |> Int
    while any( R .> zeroint ) && any(W[Rinds] .> tolerance)
        Rinds = Inds[ R .> zeroint ]
        j = Rinds[argmax( W[Rinds] )]
        P[j] = j ; R[j] = zeroint
        Pinds = Inds[ P .> zeroint ] ; Rinds = Inds[ R .> zeroint ]
        #Update R & P
        r[Pinds] = Base.inv( ATA[ Pinds, Pinds ]) * ATb[ Pinds ]
        r[Rinds] .= 0.0
        while any(r[Pinds] .<= tolerance) && (inneriters < maxiters)
            Select = (r .<= tolerance) .& (P .> zeroint)
            alpha = reduce( min, X[Select] ./ ( X[Select] .- r[Select] ) )
            X .+= alpha .* ( r .- X )
            Select = Inds[(abs.(X) .< tolerance) .& ( P .!= zeroint )]
            R[Select] .= Select
            P[Select] .= zeroint
            Pinds = Inds[ P .> zeroint ] ; Rinds = Inds[ R .> zeroint ]
            r[Pinds] = Base.inv( ATA[ Pinds, Pinds ]) * ATb[ Pinds ]
            r[Rinds] .= 0.0
            inneriters += 1
        end
        X = r
        W = ATb .- (ATA * X)
    end

    return X
end

#    UnimodalFixedUpdate(x)
#This function performs a unimodal least squares update at a fixed maximum for a vector x.
#This is faster then UnimodalUpdate() but, is less accurate.
#Bro R., Sidiropoulos N. D.. Least Squares Algorithms Under Unimodality and Non-Negativity Constraints

function UnimodalFixedUpdate(x::Array{Float64,1})
    bins = length(x)
    if bins == 1
        return x
    end
    maxindx = argmax(x)[1]
    #Handle edge cases
    if (maxindx == 1)
        return reverse(MonotoneRegression(reverse(x)))
    elseif (maxindx == bins)
        return MonotoneRegression(x)
    end
    bLeft = MonotoneRegression(x[1:(maxindx-1)])
    bRight = reverse(MonotoneRegression(reverse(x[(maxindx+1):end])))
    if x[maxindx] > max( bLeft[maxindx-1], bRight[1] )
       return [bLeft; x[maxindx]; bRight];
    end
    return [bLeft; x[maxindx]; bRight]
end

#    UnimodalUpdate(x)
#This function performs a unimodal least squares update for a vector x.
#This is slower then UnimodalUpdate() but, is more accurate.
#Bro R., Sidiropoulos N. D.. Least Squares Algorithms Under Unimodality and Non-Negativity Constraints. Journal of Chemometrics, June 3, 1997

function UnimodalUpdate(x::Array{Float64,1})
    bins = length(x)
    if bins == 1
        return x
    end
    maxindx = argmax(x)[1]
    bLeft = MonotoneRegression(x)
    bRight = reverse(MonotoneRegression(reverse(x)))
    (SSE, BestSSE) = (Inf, Inf)
    (b, bestB) = (zeros( bins ),zeros( bins )) #Dummy initialization
    for (indx, value) in enumerate( bRight .+ bLeft )
        if indx == 1
            bRightFine = reverse(MonotoneRegression(reverse(x[(indx+1):end])))
            b = [ x[indx]; bRightFine ]
        elseif indx == bins
            bLeftFine = MonotoneRegression(x[1:(indx-1)])
            b = [ bLeftFine; x[indx] ]
        elseif (x[indx] >= (value / 2.0))
            bLeftFine = MonotoneRegression(x[1:(indx-1)])
            bRightFine = reverse(MonotoneRegression(reverse(x[(indx+1):end])))
            b = [ bLeftFine; x[indx]; bRightFine ]
        end
        SSE = sum(abs2.(b .- x))
        if SSE < BestSSE
            bestB = copy(b)
            BestSSE = SSE
        end
    end
    return bestB
end

#    UnimodalLeastSquares(x)
#This function performs a unimodal least squares regression for a matrix A and b (X and Y).
#Bro R., Sidiropoulos N. D.. Least Squares Algorithms Under Unimodality and Non-Negativity Constraints.Journal of Chemometrics, June 3, 1997

function UnimodalLeastSquares(  A::Union{Array{Float64,1}, Array{Float64,2}},
                                b::Union{Array{Float64,1}, Array{Float64,2}};
                                maxiters::Int = 500, fixed::Bool = false)
    (obs, vars) = size( A )
    obspreds = size( b )
    (obs, preds) = (length(obspreds) > 1) ? obspreds : (obspreds, 1)
    B = randn( vars, preds )
    #Obs x Vars * Vars x Preds = Obs x Preds
    iter = 0
    LastB = ones( vars, preds ) .* Inf
    while (sum(abs2.(LastB .- B) ) / sum(abs2.( B )) > 1e-11) && (iter < maxiters)
        LastB[:,:] = B
        for var in 1:vars
            Cols = vcat(collect.([1:(var-1), (var+1):vars])...)
            beta = LinearAlgebra.pinv(A[ :, var ]) * (b - ( A[:,Cols] * B[Cols,:] ))
            if length(beta) == 1
                B[var, :] = beta
            else
                B[var, :] = (fixed) ? UnimodalFixedUpdate( beta' ) : UnimodalUpdate( beta' )
            end
        end
        iter += 1
    end
    return B
end

function MonotoneRegression(x::Array{Float64,1}, w = nothing)
    #  MonotoneRegression(x, w = nothing)
    # Performs a monotone/isotonic regression on a vector x. This can be weighted
    # with a vector w.
    # Code was translated directly from:
    # Exceedingly Simple Monotone Regression. Jan de Leeuw. Version 02, March 30, 2017
        bins = length(x)
        retx = ones(bins)
        retx[:] = x[:]
        if isa(w, Nothing)
            w = ones(bins)
        end
        bins = bins + 1
        blocks = [ block(x[i], w[i], 1, i-1, i+1) for i in 1:(bins-1)]
        #I have a one off error somewhere an easy solution is just to pad
        push!(blocks, block( 0.0, w[end], 1, bins-1, bins+1) )
        active = 1
        continue_reg = true
        while( continue_reg )
            upsatisfied = false
            next = blocks[active].next
            if next == bins
                upsatisfied = true
            elseif blocks[next].value > blocks[active].value
                upsatisfied = true
            end
            if !upsatisfied
                ww = blocks[active].weight + blocks[next].weight
                nextnext = blocks[next].next
                wxactive = blocks[active].weight * blocks[active].value
                wxnext = blocks[next].weight * blocks[next].value
                blocks[active].value = (wxactive + wxnext) / ww
                blocks[active].weight = ww
                blocks[active].size += blocks[next].size
                blocks[active].next = nextnext
                if nextnext < bins
                    blocks[nextnext].previous = active
                end
                blocks[next].size = 0
            end
            downsatisfied = false
            previous = blocks[active].previous

            if previous == 0
                downsatisfied = true
            elseif blocks[previous].value < blocks[active].value
                downsatisfied = true
            end
            if !downsatisfied
                ww = blocks[active].weight + blocks[previous].weight
                previousprevious = blocks[previous].previous
                wxactive = blocks[active].weight * blocks[active].value
                wxprevious = blocks[previous].weight * blocks[previous].value
                blocks[active].value = (wxactive + wxprevious) / ww
                blocks[active].weight = ww
                blocks[active].size += blocks[previous].size
                blocks[active].previous = previousprevious
                if previousprevious > 0
                    blocks[previousprevious].next = active
                end
                blocks[previous].size = 0
            end
            if (blocks[active].next == bins) && (downsatisfied)
                continue_reg = false
            end
            if (upsatisfied && downsatisfied)
                active = next
            end
        end
        k = 1
        for i in 1:bins
            blksize = blocks[i].size;
            if (blksize > 0) && (i < bins )
                retx[k:(k+(blksize-1))] .= blocks[i].value;
                k += blksize
            end
        end
        return retx
    end

#MCR_ALS_jw_March29(X, C, S = nothing; norm = (false, false), Factors = 3, maxiters = 20, constraintiters = 500, nonnegative = (true, true), unimodalC = false, unimodalS = false, fixedunimodal = false  )
#Performs Multivariate Curve Resolution using Alternating Least Squares on `X` taking initial estimates for either `S` or `C`.
#The number of maximum iterations for the ALS updates can be set `maxiters`.
#S or C can be constrained by their `norm`(true/false,true/false), or by nonnegativity by using `nonnegative` arguments (true/false,true/false).
#S can also be constrained by unimodality(`unimodalS`). Two unimodal algorithms exist the `fixedunimodal`(true), and the quadratic (false).
#The number of resolved `Factors` can also be set.
#The number of maximum iterations for constraints can be set by `constraintiters`.
#Tauler, R. Izquierdo-Ridorsa, A. Casassas, E. Simultaneous analysis of several spectroscopic titrations with self-modelling curve resolution.Chemometrics and Intelligent Laboratory Systems. 18, 3, (1993), 293-300.
#"""
function MCR_ALS_jw_March29(X,
    C::Union{Nothing, Array{Float64,1}, Array{Float64,2}},
    S::Union{Nothing, Array{Float64,1}, Array{Float64,2}};
    Factors::Int = 3,
    maxiters::Int = 20,
    constraintiters::Int = 50,
    norm::Tuple{Bool,Bool} = (false, false),
    nonnegative::Tuple{Bool,Bool} = (true, true),
    unimodalC::Bool = false,
    unimodalS::Bool = false,
    fixedunimodal::Bool = false )
    #@assert all( isa.( [ C , S ], Nothing ) == false)
    lowestErr = Inf
    elements = prod( size(X) )
    err = zeros(maxiters)
    D = X
    isC = isa(C, Nothing)
    isS = isa(S, Nothing)
    C = isC ? zeros(size(X)[1], Factors) : C[:, 1:Factors]
    S = isS ? zeros(Factors, size(X)[2]) : S[1:Factors, :]
    C ./= norm[1] ? sum(C, dims = 2) : 1.0
    S ./= norm[2] ? sum(S, dims = 1) : 1.0
    output = (C, S, err)
    for iter in 1 : maxiters
        if !isS
            if unimodalC
                Ct = UnimodalLeastSquares(S', X';maxiters = constraintiters, fixed = fixedunimodal)
                C = Ct
                if nonnegative[2]
                    C[C.< 0.0] .= 0.0
                end
            elseif nonnegative[2]
                for obs in 1 : size( X )[ 1 ]
                    C[obs,:] = FNNLS(S', X[obs,:]; maxiters = constraintiters)
                end
            else
                C = X * LinearAlgebra.pinv(S)
            end
            if norm[1]
                C ./= sum(C, dims = 2)
            end
            isC = false
            D = C * S
        end
        if !isC
            if unimodalS
                S = UnimodalLeastSquares(C, X; maxiters = constraintiters, fixed = fixedunimodal)
                if nonnegative[1]
                    S[S .< 0.0] .= 0.0
                end
            elseif nonnegative[1]
                for var in 1:size(X)[2]
                    S[:,var] = FNNLS(C, vec(X[:,var]); maxiters = constraintiters)
                end
            else
                S = LinearAlgebra.pinv(C) * X
            end
            if norm[2]
                S ./= sum(S, dims = 1)
            end
            isS = false
            D = C * S
        end
        err[iter] = sum(abs2.(X .- D)) / elements
        if err[iter] < lowestErr
            lowestErr = err[iter]
            output = (C, S, err)
        end
    end
    return output
end
