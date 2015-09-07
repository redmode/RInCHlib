

createColumnMetadata <- function(fname) {
  #
  #
  #

  # Reads data-----------------------------------------------------------------
  column_meta <- read.csv(fname, header = FALSE) %>% tbl_df()

  # Creates data structure-----------------------------------------------------
  feature_names <- unlist(column_meta[, 1]) %>% as.character()
  features <- data.frame(t(column_meta[, -1])) %>% as.list() %>% set_names(NULL)

  # Returns result-------------------------------------------------------------
  list(features = features, feature_names = feature_names)
}

createData <- function(fname) {
  #
  #
  #

  # Reads data-----------------------------------------------------------------
  data <- read.csv(fname, check.names = FALSE) %>% tbl_df()

  # Creates data structure-----------------------------------------------------
  # (a) Clusters data
  d <- dist(data[, -1], method = "euclidean")
  h <- hclust(d, method = "ward.D2")

  # (b) Constructs leaves
  leaves <- data %>%
    rowwise() %>%
    do({
      .row <- .
      data_frame(
        count = 1,
        distance = 0,
        objects = list(.row[1] %>% set_names(NULL)),
        features = list(c(.row[-1] %>% set_names(NULL))),
        parent = NA
      )
    })

  # (c) Constructs nodes
  nodes <- data.frame(h$merge) %>%
    set_colnames(c("left_child", "right_child")) %>%
    mutate(distance = h$height) %>%
    rowwise() %>%
    do({
      .row <- .
      data_frame(
        count = 0,
        distance = .row$distance,
        left_child = ifelse(.row$left_child < 0, -(.row$left_child + 1), (.row$left_child - 1) + nrow(data)),
        parent = NA,
        right_child = ifelse(.row$right_child < 0, -(.row$right_child + 1), (.row$right_child - 1) + nrow(data))
      )
    })

  # (d) Combines leaves with nodes and updates parents/counts
  nodes <- bind_rows(leaves, nodes)

  for (i in 1:nrow(nodes)) {
    if (!is.na(nodes$left_child[i])) {
      j <- nodes$left_child[i] + 1
      nodes$parent[j] <- i - 1
      nodes$count[i] <- nodes$count[i] + nodes$count[j]
    }
    if (!is.na(nodes$right_child[i])) {
      j <- nodes$right_child[i] + 1
      nodes$parent[j] <- i - 1
      nodes$count[i] <- nodes$count[i] + nodes$count[j]
    }
  }

  # (e) Turns data in needed format
  nodes <- llply(1:nrow(nodes), function(i) {
    x <- nodes[i, ]
    if (is.na(x$left_child)) {
      # Leaf
      list(count = x$count,
           distance = x$distance,
           objects = x$objects[[1]],
           features = x$features[[1]],
           parent = x$parent)
    } else {
      # Node
      if (!is.na(x$parent)) {
        list(count = x$count,
             distance = x$distance,
             left_child = x$left_child,
             parent = x$parent,
             right_child = x$right_child)
      } else {
        list(count = x$count,
             distance = x$distance,
             left_child = x$left_child,
             right_child = x$right_child)
      }
    }
  })
  names(nodes) <- 0:(length(nodes) - 1)

  # Returns result-------------------------------------------------------------
  list(nodes = nodes, feature_names = colnames(data)[-1])
}

createMetadata <- function(fname) {
  #
  #
  #

  # Reads data-----------------------------------------------------------------
  meta <- read.csv(fname, check.names = FALSE) %>% tbl_df()

  # Creates data structure-----------------------------------------------------
  nodes <- meta[, -1] %>%
    set_colnames(NULL) %>%
    rowwise() %>%
    do(x = {
      .
    }) %$% x
  names(nodes) <- 0:(nrow(meta) - 1)

  # Returns result-------------------------------------------------------------
  list(nodes = nodes, feature_names = colnames(meta)[-1])
}


#' @export
createJSON <- function(fout, fdata, fmeta = NULL, fcolumnmeta = NULL) {
  #
  #
  #

  # Creates data structure-----------------------------------------------------
  result <- list()

  if (!is.null(fcolumnmeta)) {
    result$column_metadata <- createColumnMetadata(fcolumnmeta)
  }

  result$data <- createData(fdata)

  if (!is.null(fmeta)) {
    result$metadata <- createMetadata(fmeta)
  }

  # Exports to JSON & saves to file--------------------------------------------
  json <- result %>% toJSON(pretty = TRUE, auto_unbox = TRUE)
  .con <- file(fout, open = "w")
  writeLines(json, con = .con)
  close(.con)

  # Returns result-------------------------------------------------------------
  invisible(json)
}
