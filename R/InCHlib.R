#' @import htmlwidgets
#' @import htmltools
#' @import jsonlite
#' @export
InCHlib <- function(filename, width = NULL, height = NULL) {

  InCHlibEnv$filename <- normalizePath(filename)

  # forward options using x
  x = list()

  # create widget
  htmlwidgets::createWidget(
    name = 'InCHlib',
    x,
    width = width,
    height = height,
    package = 'RInCHlib'
  )
}

#' @import stringi
#' @import magrittr
#' @export
InCHlib_html <- function(id, style, class, ...) {

  # Gets JSON from file
  .jsondata <- stri_read_lines(InCHlibEnv$filename) %>%
    stri_trim_both() %>%
    stri_c(collapse = " ")

  # Creates HEAD script
  .head <- sprintf("<script>
                     $(document).ready(function() {
                       window.inchlib = new InCHlib({
                         target: 'inchlib',
                         heatmap: true,
                         metadata: true,
                         column_metadata: true,
                         max_height: 1200,
                         draw_row_ids: true,
                         heatmap_part_width: 0.8,
                         heatmap_colors: 'Greens',
                         metadata_colors: 'Reds'
                       });

                       inchlib.read_data(%s);
                       inchlib.draw();
                     });
                   </script>", .jsondata)

  # Returns list of tags
  tagList(
    tags$head(HTML(.head)),
    tags$div(id = "inchlib")
  )
}

#' Widget output function for use in Shiny
#'
#' @export
InCHlibOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'rinchlib', width, height, package = 'InCHlib')
}

#' Widget render function for use in Shiny
#'
#' @export
renderInCHlib <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, InCHlibOutput, env, quoted = TRUE)
}
