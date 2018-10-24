\name{dotbplot}
\alias{dotbplot}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
dotbplot(x = xvar, y = yvar, meanfunction = "mean", jitter = 0.1, buffer = 0.5, scaleperc = 80, outlierfactor = 2, dotcol = "grey51", ltymean = 1, ltyoutlier = 1, linecolmean = "black", linecoloutlier = "black", lwdmean = 2, lwdoutlier = 1, lines = TRUE, highlightoutliers = FALSE, outliercol = "red", ylab = "", xlab = "", ylim = NULL, seed = 12345)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
%%     ~~Describe \code{x} here~~
}
  \item{y}{
%%     ~~Describe \code{y} here~~
}
  \item{meanfunction}{
%%     ~~Describe \code{meanfunction} here~~
}
  \item{jitter}{
%%     ~~Describe \code{jitter} here~~
}
  \item{buffer}{
%%     ~~Describe \code{buffer} here~~
}
  \item{scaleperc}{
%%     ~~Describe \code{scaleperc} here~~
}
  \item{outlierfactor}{
%%     ~~Describe \code{outlierfactor} here~~
}
  \item{dotcol}{
%%     ~~Describe \code{dotcol} here~~
}
  \item{ltymean}{
%%     ~~Describe \code{ltymean} here~~
}
  \item{ltyoutlier}{
%%     ~~Describe \code{ltyoutlier} here~~
}
  \item{linecolmean}{
%%     ~~Describe \code{linecolmean} here~~
}
  \item{linecoloutlier}{
%%     ~~Describe \code{linecoloutlier} here~~
}
  \item{lwdmean}{
%%     ~~Describe \code{lwdmean} here~~
}
  \item{lwdoutlier}{
%%     ~~Describe \code{lwdoutlier} here~~
}
  \item{lines}{
%%     ~~Describe \code{lines} here~~
}
  \item{highlightoutliers}{
%%     ~~Describe \code{highlightoutliers} here~~
}
  \item{outliercol}{
%%     ~~Describe \code{outliercol} here~~
}
  \item{ylab}{
%%     ~~Describe \code{ylab} here~~
}
  \item{xlab}{
%%     ~~Describe \code{xlab} here~~
}
  \item{ylim}{
%%     ~~Describe \code{ylim} here~~
}
  \item{seed}{
%%     ~~Describe \code{seed} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (x = xvar, y = yvar, meanfunction = "mean", jitter = 0.1, 
    buffer = 0.5, scaleperc = 80, outlierfactor = 2, dotcol = "grey51", 
    ltymean = 1, ltyoutlier = 1, linecolmean = "black", linecoloutlier = "black", 
    lwdmean = 2, lwdoutlier = 1, lines = TRUE, highlightoutliers = FALSE, 
    outliercol = "red", ylab = "", xlab = "", ylim = NULL, seed = 12345) 
{
    means <- tapply(y, x, get(meanfunction), na.rm = T)
    par(mar = c(4, 4, 2, 4))
    if (meanfunction == "mean") {
        sds <- tapply(y, x, sd, na.rm = T)
        upper <- means + outlierfactor * sds
        lower <- means - outlierfactor * sds
    }
    else {
        if (meanfunction == "median") {
            first <- tapply(y, x, quantile, 0.25, na.rm = T)
            third <- tapply(y, x, quantile, 0.75, na.rm = T)
            iqr <- third - first
            upper <- means + outlierfactor * iqr
            lower <- means - outlierfactor * iqr
        }
        else {
            cat("option meanfunction needs to be either mean or median")
            return()
        }
    }
    set.seed(seed)
    x.new <- jitter(as.numeric(as.factor(x)), amount = jitter)
    if (!highlightoutliers) {
        plot(x.new, y, pch = 16, col = dotcol, xaxt = "n", yaxt = "n", 
            xlim = c(1 - buffer, length(means) + buffer), xlab = xlab, 
            ylab = ylab, ylim = ylim, yaxs = "i")
    }
    if (highlightoutliers) {
        plot(x.new, y, type = "n", xaxt = "n", yaxt = "n", xlim = c(1 - 
            buffer, length(means) + buffer), xlab = xlab, ylab = ylab, 
            ylim = ylim, yaxs = "i")
        for (i in 1:length(means)) {
            inds <- which(as.numeric(as.factor(x)) == i)
            tf <- (y[inds] > upper[i] | y[inds] < lower[i])
            points(x.new[inds][!tf], y[inds][!tf], pch = 16, 
                col = dotcol)
            points(x.new[inds][tf], y[inds][tf], pch = 16, col = outliercol)
        }
    }
    left <- c(1:length(unique(x))) - buffer * scaleperc/100
    right <- c(1:length(unique(x))) + buffer * scaleperc/100
    segments(y0 = means, x0 = left, x1 = right, lend = 2, lwd = lwdmean, 
        lty = ltymean, col = linecolmean)
    if (lines) {
        segments(y0 = upper, x0 = left, x1 = right, lend = 2, 
            lwd = lwdoutlier, lty = ltyoutlier, col = linecoloutlier)
        segments(y0 = lower, x0 = left, x1 = right, lend = 2, 
            lwd = lwdoutlier, lty = ltyoutlier, col = linecoloutlier)
    }
    axis(1, at = c(1:length(unique(x))), tick = F, labels = unique(x))
    axis(2, las = 2)
    axis(4, las = 2)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
