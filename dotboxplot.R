## vis - dotplot

dotbplot<-function(x = "xvar", y = "yvar", 
                   meanfunction = "mean",
                   jitter = 0.1, 
                   buffer = .5, 
                   scaleperc = 80,
                   outlierfactor = 2, 
                   dotcol = "grey51",
                   ltymean = 1, 
                   ltyoutlier = 1, 
                   linecolmean = "black", 
                   linecoloutlier = "black",
                   lwdmean = 2, 
                   lwdoutlier = 1, lines = TRUE,
                   highlightoutliers = FALSE, 
                   outliercol = "red",
                   ylab="", 
                   xlab="", 
                   ylim=NULL, 
                   seed = 12345
                   ){
  means<- tapply(y, x,  get(meanfunction), na.rm=T )
  par(mar=c(4,4,2,4))

  if(meanfunction=="mean"){
    sds<-tapply(y, x, sd, na.rm=T )
    upper<-means+outlierfactor*sds
    lower<-means-outlierfactor*sds
    }
  else{ if(meanfunction == "median"){
    first<-tapply(y, x, quantile, 0.25, na.rm=T )
    third<-tapply(y, x, quantile, 0.75, na.rm=T )
    iqr<-third-first
    upper<-means+outlierfactor*iqr
    lower<-means-outlierfactor*iqr
    }
    
    else{cat("option meanfunction needs to be either mean or median")
      return()
      }
    }
  set.seed(seed) ## this is to get the jitter always the same
  x.new<-jitter(as.numeric(as.factor(x)), amount=jitter)

  if(!highlightoutliers){
  plot(x.new,y, pch=16, col=dotcol, 
       xaxt="n", yaxt="n", 
       xlim=c(1-buffer,length(means)+buffer),
      xlab=xlab, ylab=ylab, ylim=ylim, yaxs="i")
  }
  if(highlightoutliers){
    plot(x.new, y, type="n" ,
         xaxt="n", yaxt="n", 
         xlim=c(1-buffer,length(means)+buffer),
         xlab=xlab, ylab=ylab, ylim=ylim,
         yaxs="i")
    
    for (i in 1:length(means)){
      inds<-which(as.numeric(as.factor(x))==i)
      tf<-(y[inds]>upper[i] | y[inds]<lower[i])
      points(x.new[inds ][!tf], y[inds][!tf], 
             pch=16, col=dotcol)
      
      points(x.new[inds][tf], y[inds][tf], 
              pch=16, col=outliercol)
          }  
  }
  
    
  left<-c(1:length(unique(x)))-buffer*scaleperc/100  
  right<-c(1:length(unique(x)))+buffer*scaleperc/100  
  
  segments(y0=means,  x0=left, 
           x1=right, lend=2, lwd=lwdmean, 
           lty=ltymean, col=linecolmean)
  
  if(lines){  
    segments(y0=upper,  x0=left, x1=right, 
             lend=2, lwd=lwdoutlier, lty = ltyoutlier, 
             col= linecoloutlier)
    segments(y0=lower,  x0=left, x1=right, lend=2, 
             lwd=lwdoutlier, lty = ltyoutlier, col= linecoloutlier)
  }
    
    axis(1, at=c(1:length(unique(x))), tick=F,
       labels=unique(x))
  axis(2, las=2)
  axis(4, las=2)
  }


makeplot<-function(data=data1, 
                   org="leber", 
                   var="ICU_Days", 
                   ymin = NULL, 
                   ymax = NULL,
                   meanfunction = "mean", 
                   dotcol = col1, 
                   outliercolor = col2){
subi<-subset(data, organ == org)
ran<-range(subi[,var],na.rm=T)

if(is.null(ymin)){ymin<-ran[1]}
if(is.null(ymax)){ymax<-ran[2]*1.2}

dotbplot(x=as.character(subi$Site),
                     y = subi[,var],
  meanfunction = meanfunction, highlightoutliers=T,
                     outlierfactor = 2, dotcol=dotcol,
                     xlab="Center", lines=F, outliercol=outliercolor,
                     ylab=var, jitter=.2, buffer=.3,
                     scaleperc = 120, ylim=c(ymin,ymax))
}

maketable<-function(data=data1, org="leber", var="ICU_Days" ){
  subi<-subset(data, organ==org)
  subi[,c("Site", var)]
  }


