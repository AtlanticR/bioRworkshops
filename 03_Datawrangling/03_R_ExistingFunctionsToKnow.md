# Handy R Functions

## `str()`
This shows you the structure of the data you're looking at, and can give some insight into where you data is hidden
```{r}
vec1 = seq(1:10)
vec2 = c("Mike","Mike again", "Another Mike")
list1 = list(vec1, vec2)
str(vec1)
str(vec2)
str(list1)
```

## `head()` and `tail()`
These show you the first or last bit of your data.  They default to only showing 5 records, but I like to get more
```{r}
head(iris)
tail(iris,20)
```

## `length()` and `nrow()`
These each give you a count of something - length is good for vectors, and nrow is good for matrices and data.frames
```{r}
length(iris)
[1] 5
# 5 variables (columns)
nrow(iris)
[1] 150
# 150 rows of data
```

But like we said above, once you've extracted a single column, it's become a vector, so you need to use `length()` instead of `nrow()`
```{r}
nrow(iris[,1])
NULL
length(iris[,1])
[1] 150
```

## `unique()`
If you want to do a function over a number of porential values, it's handy to get the unqie values from a data frame.
`unique(iris$Species)`

## `select.list()`
This is a handy way to get user input
`choice = select.list(c("Mike", "Catalina","Brad","Adam","Ryan","Clark"),graphics = TRUE)`

## `paste()`/`paste0()`
These allow you to embed variables into your output.  `paste()` adds spaces around the input variables, but `paste0` doesn't.  I prefer `paste0()` since I type exactly what I want to be output.  Spaces around variables generally messes up your SQL queries.

```{r}
dude = "mike"
print(paste0("Here's a simple example where ",dude," uses paste0 to embed a variable"))
```

Here's a fancier example that shows how you need to be aware of the quotes and apostrophes in cases like SQL.
```{r}
mySpecies = "Cod"
mySQL = paste0("Select * from data where species = '",mySpecies,"' ORDER BY speciess")

mySQL
[1] "Select * from data where species = 'Cod'"
```

## `merge()`