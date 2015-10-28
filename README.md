### Cluster Evaluation R package (ClueR) for detecting key signaling events from time-series phosphoproteomics data

#### Description
CLUster Evaluation (or "CLUE") is an R package for identifying optimal number of clusters in a given time-course dataset clustered by cmeans or kmeans algorithms. It relies on a reference annotation set to test for enrichment in
each cluster using Fisher's Exact Test and then test for overall enrichment of the entire clusters using Fisher's
combined probability test.

CLUE is designed for analyzing time-course phosphoproteomics dataset using kinase-substrate annotation as reference. However, it can be applied to time-course microarray dataset as well by replacing the kinase-substrate annotation with gene sets annotation.

#### Reference
Pengyi Yang, Xiaofeng Zheng, Vivek Jayaswal, Guang Hu, Yee Hwa Yang, Raja Jothi, Detecting key signaling events from time-series phosphoproteomics data, PLoS Comput Biol 11(8): e1004403. doi:10.1371/journal.pcbi.1004403.

#### Download and install
The release version can be downloaded from CRAN [link](http://cran.r-project.org/web/packages/ClueR/);

whereas the latest release of development version can be downloaded from [here](https://github.com/PengyiYang/ClueR/releases)

1. Install the release version from CRAN with `install.packages("ClueR")`

2. You can also install the latest development version from github with:
```r
devtools::install_github("PengyiYang/ClueR")
```
Make sure that you have Rtools install in your system for building the package from the source.

#### Examples
(1) This example demonstrate how CLUE can be applied to discover the optimal number of clusters from a simulated data.

``` r
## install the latest release of ClueR package

# load the package into R session
library(ClueR) 

# simulate a time-series data with six distinctive profile groups and each group with
# a size of 500 phosphorylation sites.
simuData <- temporalSimu(seed=1, groupSize=500, sdd=1, numGroups=6)

# create an artificial annotation database. Generate 100 kinase-substrate groups each
# comprising 50 substrates assigned to a kinase.
# among them, create 5 groups each contains phosphorylation sites defined to have the
# same temporal profile.
kinaseAnno <- list()
groupSize <- 500
for (i in 1:5) {
 kinaseAnno[[i]] <- paste("p", (groupSize*(i-1)+1):(groupSize*(i-1)+50), sep="_")
}

for (i in 6:100) {
 set.seed(i)
 kinaseAnno[[i]] <- paste("p", sample.int(nrow(simuData), size = 50), sep="_")
}
names(kinaseAnno) <- paste("KS", 1:100, sep="_")

# run CLUE with a repeat of 5 times and a range from 2 to 20
set.seed(2)
clueObj <- runClue(Tc=simuData, annotation=kinaseAnno, rep=5, kRange=20)

# visualize the evaluation outcome
Ms <- apply(clueObj$evlMat, 2, mean, na.rm=TRUE)
Ss <- apply(clueObj$evlMat, 2, sd, na.rm=TRUE)
library(Hmisc)
errbar(1:length(Ms), Ms, Ms+Ss, Ms-Ss, cex=1.2, type="b", xaxt="n", xlab="k", ylab="E score")
axis(1, at=1:19, labels=paste("k=", 2:20, sep=""))

# generate optimal clustering results using the optimal k determined by CLUE
best <- clustOptimal(clueObj, rep=10, mfrow=c(2, 3))

# list enriched clusters
best$enrichList

# obtain the optimal clustering object
best$clustObj
```

(2) This example shows the application of CLUE on a hES phosphoproteomics data set (Rigbolt et al. Sci Signal. 4(164):rs3, 2011) and uses kinase-substrate annotation compiled from [PhosphoSitePlus](http://www.phosphosite.org).

``` r
## install the latest release of ClueR package

# load the package into R session
library(ClueR) 

# load the human ES phosphoprotoemics data 
data(hES) 

# load the PhosphoSitePlus annotations (Hornbeck et al. Nucleic Acids Res. 40:D261-70, 2012)
data(PhosphoSite)

# run CLUE with a repeat of 5 times and a range from 2 to 20
set.seed(2)
clueObj <- runClue(Tc=hES, annotation=PhosphoSite.human, rep=5, kRange=20)

# visualize the evaluation outcome
Ms <- apply(clueObj$evlMat, 2, mean, na.rm=TRUE)
Ss <- apply(clueObj$evlMat, 2, sd, na.rm=TRUE)
library(Hmisc)
errbar(1:length(Ms), Ms, Ms+Ss, Ms-Ss, cex=1.2, type="b", xaxt="n", xlab="k", ylab="E score")
axis(1, at=1:19, labels=paste("k=", 2:20, sep=""))

# generate the optimal clustering results
best <- clustOptimal(clueObj, rep=10, mfrow=c(3, 4))

# list enriched clusters
best$enrichList

# obtain the optimal clustering object
best$clustObj
```


