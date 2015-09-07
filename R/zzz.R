# Creates new package-wide environment
if (!exists("InCHlibEnv")) {
  InCHlibEnv <- new.env(parent = .GlobalEnv)
}
