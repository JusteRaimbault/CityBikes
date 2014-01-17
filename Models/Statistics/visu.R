# plot available bikes as a function of time -> just the sum of lines !

available <- function(numdays){
  i=0
  availableBikes = c()
  for(file in sort(dir("data"))){
    print(paste("day",i))
    if(i==numdays){
       dat = as.matrix(read.table(paste("data/",file,sep="")))
       for(l in 1:length(dat[,1])){
         availableBikes= append(availableBikes,sum(dat[l,]))
       }
    }
    i = i + 1
  }
  points(1:length(availableBikes),availableBikes,type="l",ylim=c(10000,15000),xlab="time",col=numdays)
}







