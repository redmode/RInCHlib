# README

## Installation

```{r}
install.packages("devtools")
devtools::install_github("redmode/RInCHlib")
```

## Usage

```{r}
library(RInCHlib)

# Chemical
file1 <- system.file("examples/chemical.json", package = "RInCHlib")
InCHlib(file1)

# Whisky
file2 <- system.file("examples/whisky.json", package = "RInCHlib")
InCHlib(file2)

# Chemical (raw data)
fout <- tempfile()

file_data <- system.file("examples/example_data.csv", package = "RInCHlib")
file_meta <- system.file("examples/example_metadata.csv", package = "RInCHlib")
file_column_meta <- system.file("examples/example_column_metadata.csv", package = "RInCHlib")

createJSON(fout = fout, fdata = file_data, fmeta = file_meta, fcolumnmeta = file_column_meta)
InCHlib(fout)
```
