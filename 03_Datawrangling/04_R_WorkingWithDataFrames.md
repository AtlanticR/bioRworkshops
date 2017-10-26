# Working with data in data.frames

dataframes hold data as df[rows,cols].

`iris[1:3,]` will get you the first 3 rows of data

`iris[,1:2]` will get you the first 2 columns

`iris[,1]` will get you a single column, but has turned it into a vector

Columns of data in a data frame can be grabbed using the column number, or the name of the column itself.  I like using the name of the column in case my data changes, and impacts the column order.  The following all get the same thing
```{r}
iris[,5]
iris$Species
iris["Species"]
```

## Conditions You can Use to Extract Particular Data


### `&` and `|`
`iris[iris$Sepal.Length>7,]`

You can add multiple conditions with `&`  (and) or `|` (or)

```{r}
iris[iris$Sepal.Length>7 & iris$Sepal.Width == 3.8,]
iris[iris$Sepal.Length==7.7  | iris$Sepal.Width == 2.0,]
```

### `%in%`
This is handy because if you have a vector of acceptable values, you can use it to get them all.
```{r}
> widths=c(1.1, 2.4)
> iris[iris$Petal.Width %in% widths,]
```

### `!` (negate)
With most subsetting functions, you can use the conditions above, but wrap them in brackets and put a `!` in front of them to negate that condition.
