# Writing Functions
## Very Basic Example
```{r}
whoAreYou<-function(){
  msg = "I'm Mike!"
  return(msg)
}

> whoAreYou()
[1] "I'm Mike!"
```
You can assign the results directly to a variable
```{r}
> person = whoAreYou()

> person
[1] "I'm Mike!"
```

## Basic Example with a Parameter
```{r}
whoAreYou<-function(x = "Unknown"){
  msg = paste("I'm", x, "!")
  return(msg)
}

> whoAreYou()
[1] "I'm Unknown !"

> whoAreYou('a Noob')
[1] "I'm a Noob !"
```
## Use parameters to alter what functions return
```{r}
askForPassword <-function(manners = NULL){
  if (manners == "Polite") {
    thePassword <- "Open Sesame!"
  }else{
    thePassword <- "No soup for you!"
  }
  return(thePassword)
}

askForPassword(manners = "Gimme!")
[1] "No soup for you!"

askForPassword(manners = "Polite")
[1] "Open Sesame!"
```
## Function scope (not limited to R)
If a variable is assigned outside of a function, it will be available within all functions.
```{r}
weAllKnow = "Mike's a dork"

testScope<-function(){
  print(weAllKnow)
}

testScope()
[1] "Mike's a dork"
```
The opposite is not true.  If a variable is defined within a function, it is only available within that function unless it is returned by the function, or assigned a broader scope.

```{r}
testScope2<-function(){
  onlyIKnow = "Mike's actually pretty awesome"
  print(onlyIKnow)
}

testScope2()
[1] "Mike's actually pretty awesome"
```
But if you just try to get it directly, you can't
```{r}
onlyIKnow
Error: object 'onlyIKnow' not found
```
### Global Variables
You may have a compelling reason to create something in a function that you want available to everything.  I think this is frowned upon, but I have found it useful in functions that extract data that I want to be available in my workspace.

```{r}
makeAUsefulThing<-function(){
  .GlobalEnv$aUsefulThing = seq(1:100)
}

aUsefulThing
Error: object 'aUsefulThing' not found

makeAUsefulThing()
aUsefulThing
```
