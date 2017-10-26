# Generally Useful Things To be Aware Of

## Quotes and Apostrophes
They're interchangeable, but must match each other
```{r}
print("This is fine")
print("This is also fine")
print("wouldn't it be nice if we could, y'know, add apostrophes?")
```
But this one fails since R stops interpreting after it hits the first matching quote
```{r}
print("He said "This is not going to work" and she agreed.")
print('She said "Do you think it is because you had quotes trying to quote other quotes?"')
```


## `NULL`, `NA` and `exists()`
R objects can have a variety of conditions, and sometimes they're weird.  And the different possible weird values get handled differently.

```{r}
exists("hullabaloo")
[1] FALSE
hullabaloo = NULL
> exists("hullabaloo")
[1] TRUE
> is.null(hullabaloo)
[1] TRUE
 is.na(hullabaloo)
logical(0)
```
## Troubleshooting AKA "`browser()` is your friend"
Sometimes functions don't return what you thought they should and trying to figure out what happened along the way can be a pain.  A "friend" used to fill his code with `print()` statements that would write out the values at various stages of processing.  While workable, this is not ideal.  The `browser()` function allows you to trigger a debugging session at any place in your code.  Once initiated, you can run through the code line by line and determine where things are getting messed up.

So here's my fancy function that isn't working properly all the time
```{r}
fancyFunction<-function(x){
  #browser()
  fancyVector = c(1,2,3,4,5,6,x)
  step1 = fancyVector*fancyVector
  step2 =sum(step1)
  return(step2)
}

thisworks = fancyFunction(11)
```
But it doesn't work when I load the variable dynamically
```{r}
myVar = "11"
thisNoWorky = fancyFunction(myVar)

Error in fancyVector * fancyVector : 
  non-numeric argument to binary operator
```
If we uncomment the browser statement in the function above, we can walk stepwise through the function, and figure out which step it's failing at, and why.

## Loops
Loops are generally not necessary because of how R works.  But if that's what it takes to ease you into it...

```{r}
deliciousSpecies = c("Cod","Halibut","BottlenoseWhale")

for (i in 1:length(deliciousSpecies)){
  mySQL = paste0("Select * from recipes where species = '",deliciousSpecies[i],"'")
  print(mySQL)
}

[1] "Select * from recipes where species = 'Cod'"
[1] "Select * from recipes where species = 'Halibut'"
[1] "Select * from recipes where species = 'BottlenoseWhale'"
```
The above could also be done with a function.  This has some advantages since the function can then be used to do even more stuff specific to each species. 
```{r}
getRecipes<-function(species){
  mySQL = paste0("Select * from recipes where species = '",species,"'")
  return(mySQL)
}

for (i in 1:length(deliciousSpecies)){
  print(getRecipes(deliciousSpecies[i]))
}
```
Someone else should cover this, but `apply()` (and related `mapply()`, `sapply()`, `lapply()` etc) does what a loop does, but it's designed for arrays, and works super fast in R.  You can send stuff to a function and get your results right back into another vector
```{r}
all = mapply(deliciousSpecies, FUN= getRecipes)

all["Cod"]
                                          Cod 
"Select * from recipes where species = 'Cod'" 
```