#' Illustrate S3 dispatch
#'
#' @param call Example call to S3 method
#' @param env Environment in which to evaluate call
#' @export
#' @examples
#' x <- Sys.time()
#' s3_dispatch(print(x))
#' s3_dispatch(is.numeric(x))
#' s3_dispatch(as.Date(x))
#' s3_dispatch(sum(x))
#'
#' # Internal vs. regular generic
#' x1 <- 1
#' x2 <- structure(2, class = "numeric")
#'
#' my_length <- function(x) UseMethod("my_length")
#' s3_dispatch(my_length(x1))
#' s3_dispatch(my_length(x2))
#'
#' s3_dispatch(length(x1))
#' s3_dispatch(length(x2))
s3_dispatch <- function(call, env = parent.frame()) {
  call <- substitute(call)
  generic <- as.character(call[[1]])
  x <- eval(call[[2]], env)

  class <- c(s3_class(x), "default")
  names <- paste0(generic, ".", class)
  exists <- methods_exist(generic, class, env = env)

  # Add group generic if necssary
  group <- find_group(generic)
  if (!is.null(group)) {
    names <- c(names, paste0(group, ".", class))
    exists <- c(exists, methods_exist(group, class, env = env))
  }

  # internal generics will always resolve to something
  # currently showing with generic name
  if (is_internal_generic(generic)) {
    names <- c(names, generic)
    exists <- c(exists, TRUE)
  }

  new_s3_scalar(
    method = names,
    exists = exists,
    class = "method_table"
  )
}

methods_exist <- function(generic, class, env = parent.frame) {
  purrr::map2_lgl(generic, class, method_exists, env = env)
}

method_exists <- function(generic, class, env = parent.frame()) {
  !is.null(utils::getS3method(generic, class, envir = env, optional = TRUE))
}

#' @export
print.method_table <- function(x, ...) {
  bullet <- ifelse(x$exists, " *", "  ")
  if (any(x$exists)) {
    bullet[which(x$exists)[1]] <- "->"
  }

  cat(paste0(bullet, " ", x$method, "\n", collapse = ""), sep = "")
  invisible(x)
}

find_group <- function(generic) {
  g <- group_generics()
  g_table <- stats::setNames(rep(names(g), lengths(g)), unlist(g))

  if (!generic %in% names(g_table))
    return()

  g_table[[generic]]
}
