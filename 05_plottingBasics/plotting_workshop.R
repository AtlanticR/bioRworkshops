x <- seq(0, 1, by = 0.01)
y <- x^2 + rnorm(x, mean=0, sd=0.2)

plot(x, y)

data(iris)
plot(iris)
plot(iris$Sepal.Length, iris$Sepal.Width,
     xlab="Sepal Length", ylab="Sepal Width")

plot(x, y, type="o")

plot(x, y, pch=2)

plot(1:25, pch=1:25)

plot(x, y, pch=21, col=2, bg='grey')

plot(x, y, type='b', pch=21, col=2, bg='grey')

par(mar=c(3, 3, 0.5, 0.5), mgp=c(2, 0.5, 0),
    cex=1)
plot(x, y, cex=0.5)

par(mfrow=c(2, 2))
plot(x, y)
plot(y, x)
plot(x, y)
plot(y, x)

par(mfcol=c(2, 2))
plot(x, y)
plot(y, x, xlab='', ylab='')
plot(x, y)
plot(y, x)


par(mfrow=c(1, 1))
plot(x, y)
points(x, y + 0.1, col=2)
lines(x, y - 0.1, col=3)
legend('topleft', 
       legend=c('First plot', 'points', 'lines'),
       pch=c(1, 1, NA),
       lty=c(NA, NA, 1),
       col=c(1, 2, 3))

date <- "Jan 10 2018"
pdate <- as.POSIXct(date, format='%b %d %Y', tz="UTC")

time <- pdate + seq(0, 4*3600, by=1)
ynew <- rnorm(time)

plot(time, ynew)

library(oce)
oce.plot.ts(time, ynew)

png('plot.png')

plot(x, y)

dev.off()
