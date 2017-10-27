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

## `dim()`
`dim()` can either return or set the dimesions of an object, so it's more flexible then some other, similar functions

```{r}
x <- 1:12 
> x
 [1]  1  2  3  4  5  6  7  8  9 10 11 12
> dim(x)
NULL
> dim(x) <- c(3,4)
> x
     [,1] [,2] [,3] [,4]
[1,]    1    4    7   10
[2,]    2    5    8   11
[3,]    3    6    9   12
> dim(x)
[1] 3 4
```

## `head()` and `tail()`
These show you the first or last bit of your data.  They default to only showing 5 records, but I like to get more

```{r}
head(iris)
tail(iris,20)
```

## `length()`, `nrow()`, and `ncol()`
These each give you a count of something - length is good for vectors, and nrow is good for matrices and data.frames

```{r}
length(iris)
[1] 5
# 5 variables (columns)
nrow(iris)
[1] 150
# 150 rows of data
> ncol(iris)
[1] 5
#5 columns of data
```

But like we said above, once you've extracted a single column, it's become a vector, so you need to use `length()` instead of `nrow()`

```{r}
nrow(iris[,1])
NULL
length(iris[,1])
[1] 150
```
## `colnames()` (and `rownames()`)
These just return the names of the various rowns and columns

```{r}
> colnames(iris)
[1] "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width"  "Species"    
```

## `unique()`
If you want to do a function over a number of porential values, it's handy to get the unqie values from a data frame.

`unique(iris$Species)`

## `select.list()`
This is a handy way to get user input

`choice = select.list(c("Mike", "Catalina","Brad","Adam","Ryan","Clark"),graphics = TRUE)`

## `paste()`/`paste0()`
These allow you to embed variables into your output.  By default, `paste()` is actually `paste(...,sep=' ')`, and as such,  adds spaces around your input variables.  `paste0()` is a shortcut for `paste(..., sep='')`, which doesn't.  I prefer `paste0()` for embedding input into SQL since I can type exactly what I want to be output, and spaces around variables generally messes up your SQL queries.

```{r}
dude = "mike"
print(paste("Here's a simple example where",dude,"uses paste0 to embed a variable"))
```

Here's a fancier example that shows how you need to be aware of the quotes and apostrophes in cases like SQL.

```{r}
mySpecies = "Cod"
mySQL = paste0("Select * from data where species = '",mySpecies,"' ORDER BY speciess")
mySQL
[1] "Select * from data where species = 'Cod'"
```

`paste()` is great for adding other seperators, like commas, or slashes.  You can also 'collapse' vectors using the seperator of your choosing.  This is often useful for collapsing vectors of codes into something that can be passed to the IN clause of a SQL statement.

Note that if you `paste()` a vector, your paste will be repeated for however many elements there are in the vector

```{r}
sppCodes = c(1,2,3)  
paste("these are my codes: ", sppCodes)
[1] "these are my codes:  1" "these are my codes:  2" "these are my codes:  3"
```

That's not what I wanted, let's try again, but collapse the vector

```{r}
paste("these are my codes: ", sppCodes, collapse=",")
[1] "these are my codes:  1,these are my codes:  2,these are my codes:  3"
```

Still not what I wanted!  Let's do the collapse first, and then paste the data into our phrase.

```{r}
paste("these are my codes: ", paste(sppCodes, collapse=","))
[1] "these are my codes:  1,2,3"
```
Or to make a more relevant example... 

```{r}
mySQL = paste("SELECT * from data where spcode IN (", paste(sppCodes, collapse=","),")", sep="")
mySQL
[1] "SELECT * from data where spcode IN (1,2,3)"
```
Or if your IN statement will have characters (instead of integers), you need to wrap them in apostrophes, too

```{r}
sppNames = c("cod","haddock","Stellers Sea Cow")
mySQL = paste("SELECT * from data where spname IN ('", paste(sppNames, collapse="','"),"')", sep="")
mySQL
"SELECT * from data where spname IN ('code','haddock','Stellers Sea Cow')"
```

## `file.path()`
It's tempting to create paths to your files using `paste()`, but it's better to use the rrcdedicated `file.path()` function.  The reason is that even though most of are used to paths like "c:\mike\myfiles", someone else on a mac or linux computer might need something like "/mike/myfiles".  `file.path()` can ensure tha the seperators are appropriate for your OS

```{r}
file.path("folder1","folder2","folder3")
```

## `merge()`
Merge is how you can combine different datasets that have common field(s).  If you think in SQL, you can do INNER, OUTER LEFT, RIGHT and CROSS joins.  Essentially, you can elect to keep:
* Only the records that can be matched (INNER) 
* All of the records from dataset 1 that match something in dataset 2 (LEFT)
* All of the records from dataset 2 that match something in dataset 1 (RIGHT)
* All of the records from both, joining where possible, but adding NAs where they can't (OUTER)

Because I'm lazy, I'm stealing an example from StackOverflow.com, but please look at it - `merge()` is handy.

````{r}
df1 = data.frame(CustomerId = c(1:6), Product = c(rep("Toaster", 3), rep("Radio", 2),"LaserDisk"))
df2 = data.frame(CustomerId = c(2, 4, 6), State = c(rep("Alabama", 2), rep("Ohio", 1)))
merge(x = df1, y = df2, by = "CustomerId", all = TRUE)
merge(x = df1, y = df2, by = "CustomerId", all.x = TRUE)
merge(x = df1, y = df2, by = "CustomerId", all.y = TRUE)
merge(x = df1, y = df2, by = NULL)
```
It's not shown in the example above, but if you have to merge on 2 fields (for example, MISSION and SETNO), you can, via the `by` parameter.  The names of the fields don't need to be the same, either...

```{r}
merge(x, y, by = c("MISSION","SETNO"))
merge(x, y, by.x = c("MISSION","SETNO"), by.y = c("MISSIONorama","SETNOlio"))
```
