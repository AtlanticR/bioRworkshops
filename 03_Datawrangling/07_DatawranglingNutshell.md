# Mar.datawrangling demonstration
## Idea
* Make database extractions as easy and consistent

## Approach
* Generic enough to allow for multiple data sources (e.g. groundfish, marfissci, observer databases, etc)
* GUI available if desired, but not necessary (can still embed components in scripts)
* R package (like you'd install from CRAN)
    + includes documentation
    + brings in required packages
    + no configuration necessary
             
## How it Works
*  Connects to Oracle, and extracts data locally (only if necessary)
    + local copies of data load faster; 
    + allows people to work from home
* Configuration file contains all of the information about the various data sources, e.g.
    + what tables exist, 
    + how they are linked (primary/foreign relationships), 
    + fields that might be good to allow filtering on...
* If using the GUI, a series of popups allow you to filter the data
* Following the application of filters, a series of merges are done within the data to drop all records that no longer apply.	

## Using the Application

### Installation

```{r}
library(devtools)
install_github('Maritimes/Mar.datawrangling')
```

### First Run

```{r}
library(Mar.datawrangling)
setwd("/home/mike")
get_data('rv') # Select the datasource you want
```
You will now be prompted for your oracle credentials
Assuming you have them, you'll see something like...

```{r}
Looked in '/home/mike/git/Maritimes/bio.datawrangling/data' for required *.rdata files, but you are missing the following:
[1] "RV.GSCAT"      "RV.GSDET"      "RV.GSINF"      "RV.GSMISSIONS" "RV.GSSPECIES"  "RV.GSSTRATUM"  "RV.GSXTYPE"   

Press E to extract all the data, or any other key to cancel: 
```
Assuming the directory stated above is an appropriate place, you would type "E" to extract the data.

#### Permissions

Only after you've elected to extract the data does the package verify that you are actually allowed to view the data you indicated.
```{r}
Successfully connected to Oracle via RODBC

Verifying access to RV.FGP_TOWS_NW2 ... success
Verifying access to RV.GSCAT ... success
Verifying access to RV.GSDET ... success
Verifying access to RV.GSINF ... success
Verifying access to RV.GSMISSIONS ... success
Verifying access to RV.GSSPECIES ... success
Verifying access to RV.GSSTRATUM ... success
Verifying access to RV.GSXTYPE ... success
...
```
If *any* of these checks say "failed", instead of "success", you will not be able to do the extractions.  Please check with Mike.McMahon@dfo-mpo.gc.ca to see if you can get permissions to the problematic Oracle objects.

#### Subsequent Runs

Once you've done a successful extraction, you can load the data using the same command,  `get_data()`.  If you feel the data is out of date and need updating, you can do `get_data(force.extract = T)`.w

```{r}
Loading data...

Loaded RV.GSCAT...  (Data modified 45 days ago.)
Loaded RV.GSINF...  (Data modified 45 days ago.)
Loaded RV.GSDET...  (Data modified 45 days ago.)
Loaded RV.GSMISSIONS...  (Data modified 45 days ago.)
Loaded RV.GSSTRATUM...  (Data modified 45 days ago.)
Loaded RV.GSXTYPE...  (Data modified 45 days ago.)
Loaded RV.GSSPECIES...  (Data modified 45 days ago.)
Loaded RV.FGP_TOWS_NW2...  (Data modified 45 days ago.)

5 seconds to load...
```

### Working with the Data (GUI)

If you are unfamiliar with the data, you should probably start out using the GUI, as it will give you a sense of what values are in the data, and doesn't assume that you know things like species codes.  

To get started, run:

```{r}
data_filter()
```
This will lead you through a series of popups you can use to filter the data.  Each time you pick one, it will be applied immediately.  For example, if you select that you want data for haddock, then every record that can't be linked to a haddock catch will be gone.

### Working with the Data (script)

GUIs are handy, except when you're trying to automate something, or you already know exactly what you want.  In such cases, you can achieve all of the same functionality by overwriting the existing R objects with a subsetted version, and then running `self_filter()` when you're done.

`self_filter()` is the part of the application that uses the known relationships between the objects and gets rid of those that you've filtered away.  It's a bit of a slow process, and when you run the GUI, `self_filter()` is applied after each selection.  If you know exactly wat you want, you can do all of your subsetting at once, and then just run the `self_filter()` at the end.  This is significantly faster, but does make it possible to filter away all of your data.

Following is an example of what you might include in a script to extract all of the
Cod data for the Summer 2017 survey.

```{r}
library(Mar.datawrangling)
setwd("/home/mike")
get_data('rv')
GSSPECIES = GSSPECIES[GSSPECIES$CODE ==10,]
GSMISSIONS = GSMISSIONS[GSMISSIONS$YEAR == 2017 & GSMISSIONS$SEASON == 'SUMMER',]
self_filter()

```


### Reloading the Data

Should you accidentally apply an incorrect filter or you want to create a new selection, run `get_data()` again to reload your stored, virgin data back into your workspace and try it again.
             
             