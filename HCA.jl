using Statistics, Plots, Random, LinearAlgebra


function calcDist(data)

	dist = zeros(size(data,1),size(data,1))
	for i = 1:size(data,1)-1
		for j = i+1:size(data,1)
			dist[j,i] = data[j,1] - data[i,1]
		end
	end

	dist += dist'
	# set diagonal
	dist[diagind(dist)] .= Inf
	return abs.(dist)
end




function clustering(data)
	data = sort(data)
	cl = [Int.(ones(size(data,1), size(data,1)) .* collect(1:size(data,1))) data]
	cl_means = Array{Union{Missing, Vector{Float64}}}(missing, size(data,1), 1)
	data = [data collect(1:length(data))]

	for i = 1:size(cl,1)-1
		cl_means[i] = data[:,1]
		dist = calcDist(data)
		ind = findmin(dist)[2]
		#merge values
		ind_add = findall(cl[:,i] .== data[ind[1],2])
		cl[ind_add,i+1:end-1] .= data[ind[2],2]
		#adjust data
		data = data[1:end .!= ind[1],:]  	#remove row
		#calculate new cluster mean
		data[ind[2],1] = mean(cl[findall(cl[:,i+1] .== data[ind[2],2]),end])
	end
	cl_means[size(cl,1)] = [mean(cl[:,end])]

	return cl, cl_means
end


function HCLplot(cl,cl_means)
	plot()
	for i = 1:size(cl,1)
		println(i)
		# scatter!(cl[:,end],
		# 		 ones(size(cl,1)).*(i-1),c = 1,label = false)
		#plot upward lines
		plot!([cl_means[i]'; cl_means[i]'],
			  [(ones(size(cl,1)).*(i-1))';(ones(size(cl,1)).*i)'],
			  c = 1,label = false)
		#plot horz. line
		ind_change = findall(cl[:,i] .!= cl[:,i+1])[1]
		ind = findall(cl[:,i+1] .== cl[ind_change,i+1])
		plot!(cl_means[i][ind], [1; 1] .* i,
			  c = 1, label = false)
		#adjust cl for next plot
		cl = cl[1:end .!= ind_change,:]
	end
	return plot!()
end




## Exersizes


#exersize 1/2/3
#generate the data
data = [rand(MersenneTwister(2),1:.0001:2,5);rand(MersenneTwister(2),4:.0001:6,5)]

#calculate the distance matrix
dist = calcDist(data)

#clustering function
cl,cl_means = clustering(data)


#plot function
HCLplot(cl,cl_means)



## Expand calcDist function for multiple variables
function calcDistMultipleFeatures(data)
	# each row is considered a sample and the columns are features
	dist = zeros(size(data,1),size(data,1))
	for i = 1:size(data,1)-1
		for j = i+1:size(data,1)
			dist[j,i] = sqrt(sum((data[i,:] .- data[j,:]).^2))
		end
	end

	return dist += dist'
end

d1 = [rand(MersenneTwister(2),1:.0001:2,5);rand(MersenneTwister(2),4:.0001:6,5)]
d2 = [rand(MersenneTwister(6),1:.0001:2,5);rand(MersenneTwister(6),4:.0001:6,5)]
# d3 = [rand(MersenneTwister(63),1:.0001:2,5);rand(MersenneTwister(65),4:.0001:6,5)]
data = [d1 d2]
# data = [d1 d2 d3]

calcDistMultipleFeatures(data)












## exersize 4
using Clustering, RDatasets
using StatsPlots

data2 = dataset("datasets","iris")
x = Matrix(data2[:,1:4])
y = data2[:,5]

#calcualte the distance matrix
DM = calcDistMultipleFeatures(x)

#perform clustering
comp = hclust(DM, linkage=:complete)
aver = hclust(DM, linkage=:average)
plot(	plot(comp, xlabel="complete"),
		plot(aver, xlabel="average"))



#Extracting groups (we know there are 2 in the data)
grp_comp = cutree(comp; k=3)
grp_aver = cutree(aver; k=3)
plot(scatter(x[:,1],x[:,3], title = "complete", xlabel = "SepalLength", ylabel = "PetalLength", group = grp_comp, label = false),
	scatter(x[:,1],x[:,3], title = "average", xlabel = "SepalLength", ylabel = "PetalLength", group = grp_aver, label = false),
	scatter(x[:,1],x[:,3], title = "original", xlabel = "SepalLength", ylabel = "PetalLength", group = y))
