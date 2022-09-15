
# lockedlist

<!-- badges: start -->
<!-- badges: end -->

The goal of lockedlist is to provide a filesystem backed locked list.

## Installation

You can install the development version of lockedlist like so:

``` r
devtools::install_github("giupo/lockedlist")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(lockedlist)

path <- rutils::tempdir()
ll <- lockedlist$new(path)
ll$set(list(A = 1, B = 2))
ll$get("A")
list(A = 1)
```

all the operation (`should`) be thread safe.

