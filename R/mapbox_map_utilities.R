#' mapbox dispatch
#'
#' Extension points for plugins
#'
#' @param map a map object, as returned from \code{\link{mapbox}}
#' @param funcName the name of the function that the user called that caused
#'   this \code{mapbox_dispatch} call; for error message purposes
#' @param mapbox an action to be performed if the map is from
#'   \code{\link{mapbox}}
#' @param mapbox_update an action to be performed if the map is from
#'   \code{\link{mapbox_update}}
#'
#' @return \code{mapbox_dispatch} returns the value of \code{mapbox} or
#' or an error. \code{invokeMethod} returns the
#' \code{map} object that was passed in, possibly modified.
#'
mapbox_dispatch = function(
  map,
  funcName,
  mapbox = stop(paste(funcName, "requires a map update object")),
  mapbox_update = stop(paste(funcName, "does not support map update objects"))
) {

  if (inherits(map, "mapbox"))
    return(mapbox)
  else if (inherits(map, "mapbox_update"))
    return(mapbox_update)
  else
    stop("Invalid map parameter")
}

#' @param method the name of the JavaScript method to invoke
#' @param ... unnamed arguments to be passed to the JavaScript method
#' @rdname mapbox_dispatch
invoke_method <- function(map, method, ...) {
  args = evalFormula(list(...))
  mapbox_dispatch(
    map,
    method,
    mapbox = {
      x = map$x$calls
      if (is.null(x)) x = list()
      n = length(x)
      x[[n + 1]] = list(functions = method, args = args)
      map$x$calls = x
      map
    },
    mapbox_update = {
      invoke_remote(map, method, args)
    }
  )
}


invoke_remote = function(map, method, args = list()) {
  if (!inherits(map, "mapbox_update"))
    stop("Invalid map parameter; mapbox_update object was expected")

  msg <- list(
    id = map$id,
    calls = list(
      list(
        dependencies = lapply(map$dependencies, shiny::createWebDependency),
        method = method,
        args = args
      )
    )
  )

  sess <- map$session
  if (map$deferUntilFlush) {

    sess$onFlushed(function() {
      sess$sendCustomMessage("mapboxmap-calls", msg)
    }, once = TRUE)

  } else {
    sess$sendCustomMessage("mapboxmap-calls", msg)
  }
  map
}

# Evaluate list members that are formulae, using the map data as the environment
# (if provided, otherwise the formula environment)
evalFormula = function(list, data) {
  evalAll = function(x) {
    if (is.list(x)) {
      structure(lapply(x, evalAll), class = class(x))
    } else resolveFormula(x, data)
  }
  evalAll(list)
}

resolveFormula = function(f, data) {
  if (!inherits(f, 'formula')) return(f)
  if (length(f) != 2L) stop("Unexpected two-sided formula: ", deparse(f))

  doResolveFormula(data, f)
}

doResolveFormula = function(data, f) {
  UseMethod("doResolveFormula")
}


doResolveFormula.data.frame = function(data, f) {
  eval(f[[2]], data, environment(f))
}
