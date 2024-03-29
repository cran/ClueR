% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clustOptimal.R
\name{clustOptimal}
\alias{clustOptimal}
\title{Generate optimal clustering}
\usage{
clustOptimal(
  clueObj,
  rep = 5,
  user.maxK = NULL,
  effectiveSize = NULL,
  pvalueCutoff = 0.05,
  visualize = TRUE,
  universe = NULL,
  mfrow = c(1, 1)
)
}
\arguments{
\item{clueObj}{the output from runClue.}

\item{rep}{number of times (default is 5) the clustering is to be repeated to find the best clustering result.}

\item{user.maxK}{user defined optimal k value for generating optimal clustering. If not provided, the optimal k that is identified by clue will be used.}

\item{effectiveSize}{the size of kinase-substrate groups to be considered for calculating enrichment. Groups that are too small
or too large will be removed from calculating overall enrichment of the clustering.}

\item{pvalueCutoff}{a pvalue cutoff for determining which kinase-substrate groups to be included in calculating overall enrichment of the clustering.}

\item{visualize}{a boolean parameter indicating whether to visualize the clustering results.}

\item{universe}{the universe of genes/proteins/phosphosites etc. that the enrichment is calculated against. The default are the row names of the dataset.}

\item{mfrow}{control the subplots in graphic window.}
}
\value{
return a list containing optimal clustering object and enriched kinases or gene sets.
}
\description{
Takes a clue output and generate the optimal clustering of the time-course data.
}
\examples{
# simulate a time-series data with 4 distinctive profile groups and each group with
# a size of 50 phosphorylation sites.
simuData <- temporalSimu(seed=1, groupSize=50, sdd=1, numGroups=4)

# create an artificial annotation database. Generate 20 kinase-substrate groups each
# comprising 10 substrates assigned to a kinase.
# among them, create 4 groups each contains phosphorylation sites defined to have the
# same temporal profile.
kinaseAnno <- list()
groupSize <- 50
for (i in 1:4) {
 kinaseAnno[[i]] <- paste("p", (groupSize*(i-1)+1):(groupSize*(i-1)+10), sep="_")
}

for (i in 5:20) {
 set.seed(i)
 kinaseAnno[[i]] <- paste("p", sample.int(nrow(simuData), size = 10), sep="_")
}
names(kinaseAnno) <- paste("KS", 1:20, sep="_")

# run CLUE with a repeat of 2 times and a range from 2 to 7
set.seed(1)
clueObj <- runClue(Tc=simuData, annotation=kinaseAnno, rep=5, kRange=2:7)

# visualize the evaluation outcome
xl <- "Number of clusters"
yl <- "Enrichment score"
boxplot(clueObj$evlMat, col=rainbow(ncol(clueObj$evlMat)), las=2, xlab=xl, ylab=yl, main="CLUE")
abline(v=(clueObj$maxK-1), col=rgb(1,0,0,.3))

# generate optimal clustering results using the optimal k determined by CLUE
best <- clustOptimal(clueObj, rep=3, mfrow=c(2, 3))

# list enriched clusters
best$enrichList

# obtain the optimal clustering object
\donttest{
  best$clustObj
}


}
