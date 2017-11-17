## create our data file
data(iris)
write.csv(iris, file='iris.csv', row.names = FALSE)
rm(iris)

## read data set:
d <- read.csv('iris.csv')

## If we have our own data, write a custom function:
# read.kumiko <- function(file) {
#     header <- read.csv(file, n=1)
#     read.csv(file, skip=10, sep=";")
# }

## We can access columns in a data frame using the "$"
str(d$Petal.Length)

## Add a new column:
d$Petal.Area <- d$Petal.Length * d$Petal.Width
## Below is another way of doing the same thing, use the `[[` notation
d[['Petal.Area']] <- d[['Petal.Length']] * d[['Petal.Width']]

## The advantage of the `[[` notation is that it allows you to be more flexible with
## column names -- e.g. names that have a space, or ones that you might want to refer
## to using variables
# d[['new column']] <- d$Petal.Area
# column <- 'Petal.Area'
# str(d[[column]])

## Make some plots:
# the first is a summary plot that plots all columns against all other columns
plot(d)

## Plot just two of the fields
plot(d$Petal.Length, d$Petal.Width)
# or 
plot(Petal.Width ~ Petal.Length, data=d)

## Fit linear model to data
## Use the lm()
model <- lm(Petal.Width ~ Petal.Length, data=d)

plot(Petal.Width ~ Petal.Length, data=d)
abline(model, col='red')

## want to see a summary of the model? use `summary()`
summary(model)

## If we want, we can save the file to an "RData" file for later use or distribution
save(file='iris_analysis.rda', d)
