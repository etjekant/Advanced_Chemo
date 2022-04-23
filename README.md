# Advanced_Chemo
Project for advanced Chemometrics and Statistics

## TODO
|Ikram |Yuliya |Kevin |Etienne | Projects | 
|:---   | :---| :---   |:---    |  :---    |
|      |     |        |X        |PCA       |
|      |     |        |        |SVD       | 
|      |     |        |        |MCR*      |
|      |     |        |        |PLSA      |
|      |     |        |        |HCA       |
|      |     |        |        |K-means   |
* MCR might not be possible because of our dataset. We still need to explain why it is not possible.


|PCA |Normalized | Matrix| 
|:---|:---       |:---   |
|1   |No         |cov    |
|2   |No         |corr   |
|3   |Mean       |cov    |
|4   |Mean       |corr   |
|5   |Std        |cov    |
|6   |Std        |corr   |

To check with columns are significant there are a few methods:
> 1. suffle pca.
> 2. R-squared adjusted on a training and a test set.
These methods can be used to determine how many columns are needed. The advantage of R-squared adjusted is that it takes into account the y-values. 




