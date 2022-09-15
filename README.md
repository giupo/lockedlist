
# lockedlist

<!-- badges: start -->

<!-- badges: end -->

The goal of lockedlist is to provide a filesystem backed locked list.

## Installation

You can install the development version of lockedlist like so:

```r
devtools::install_github("giupo/lockedlist")
```

## Example

This is a basic example which shows you how to use a locked list:

```r
path <- rutils::tempdir()
ll <- lockedlist::lockedlist$new(path)
ll$set(list(A = 1, B = 2))
ll$get("A")
```

all operations *should* (see notes on https://github.com/r-lib/filelock/blob/main/README.md#special-file-systems ) be thread safe.

