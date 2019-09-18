#' mapbox_style
#'
#' Get a predefined or custom-made Mapbox style
#'
#' @param x Select a predefined style
#' @param owner For custom-made styles, include your Mapbox account name
#' @param styleid For custom-made styles, include your style ID
#' @param print Prints the predefined styles if TRUE. Default is FALSE
#' @param optimized If TRUE will append `?optimize=true` at the end of the
#' style URL. Default is FALSE
#'
#' @examples \donttest{
#' mapbox_style(print = TRUE)
#' mapbox_style(4)
#' mapbox_style(owner = "user", styleid = "style_id")
#' }
#' @export
mapbox_style <- function(x = 1, owner = NULL, styleid = NULL,
                         print = FALSE, optimized = FALSE) {

  if (is.null(owner) && is.null(styleid)) {
    styles <- list("mapbox://styles/mapbox/streets-v9",
                   "mapbox://styles/mapbox/streets-v10",
                   "mapbox://styles/mapbox/outdoors-v10",
                   "mapbox://styles/mapbox/light-v9",
                   "mapbox://styles/mapbox/dark-v9",
                   "mapbox://styles/mapbox/satellite-v9",
                   "mapbox://styles/mapbox/satellite-streets-v10",
                   "mapbox://styles/mapbox/navigation-preview-day-v2",
                   "mapbox://styles/mapbox/navigation-preview-night-v2",
                   "mapbox://styles/mapbox/navigation-guidance-day-v2",
                   "mapbox://styles/mapbox/navigation-guidance-night-v2"
    )
    if (print) { cat("", paste(1:length(styles), "-", unlist(styles), " \n"), "\n") }
    if (x > length(styles)) {stop("`x` must be between 1 and ",length(styles), ".\n",
                                  "Use `print = TRUE` to see which styles can be used per default.")}
    style <- styles[[x]]
  } else {
    style <- sprintf("mapbox://styles/%s/%s", owner, styleid)
  }

  if (optimized) {
    style <- paste0(style, "?optimize=true")
  }
  return(style)
}
