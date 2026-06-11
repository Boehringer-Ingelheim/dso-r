# dsoParams: list with safe access

A "dsoParams" and its constructor:

## Usage

``` r
dsoParams(x = list())
```

## Arguments

- x:

  empty, or a recursive list of lists which is converted to dsoParams

## Examples

``` r
# initiating empty
params <- dsoParams()

# converting a list of list

params <- list()
params$a <- "bla"
params$b <- list()
params$b$c <- "blub"
params <- dsoParams(params)
```
