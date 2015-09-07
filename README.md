# README

## Installation

```{r}
install.packages("devtools")
devtools::install_github("redmode/RInCHlib")
```

## Usage

```{r}
library(RInCHlib)

# Demo data
file1 <- system.file("examples/chemical.json", package = "InCHlib")
file2 <- system.file("examples/whisky.json", package = "InCHlib")

InCHlib(file1)
InCHlib(file2)
```
