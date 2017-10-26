# Connecting to Oracle
Lots of data is in Oracle, and R can connect to it directly.  I know of 2 existing R packages that can do it - RODBC and ROracle

## RODBC

* Can be installed like any R package
* Requires that you set your ODBC Connections ("MAR BIO ODBC Configuration" in the Application Catalog)
    + "Architecture Mismatch" error indicates that you're probably using 64 bit when you should be using 32 bit.
* Generally limited to using 32-bit R (limits your available memory)
* Data is extracted more slowly
```{r}
library(RODBC)
channelRODBC = odbcConnect("PTRAN", uid = "yourusername", pwd = "yourpassword", believeNRows = F)
data = sqlQuery(channelRODBC, "SELECT * FROM dual")
```

## ROracle

* More difficult to install
    + Must download file from Oracle.com (using an account) and accept license agreement
* Extractions ~5x faster
* Can use 64 bit R, so more memory is allocated

```{r}
library(ROracle) 
channelROracle = dbConnect( DBI::dbDriver("Oracle"), username = "yourusername", password = "yourpassword", dbname = "PTRAN")
data = dbGetQuery(channelROracle, "SELECT * FROM dual")
```
