% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/methods.R
\name{s3_methods_class}
\alias{s3_methods_class}
\alias{s3_methods_generic}
\title{List methods for a generic (or class)}
\usage{
s3_methods_class(x)

s3_methods_generic(x)
}
\arguments{
\item{x}{Name of class or generic}
}
\value{
A tibble with columns \code{generic}, \code{visible}, \code{class}, \code{visible},
and \code{isS4}.
}
\description{
Returns information about all methods belong to a generic or a class.
In S3, methods belong to a generic, but it is often useful to see what
generics have been provided methods for a given class. These are
wrappers around \code{\link[utils:methods]{utils::methods()}}, which returns a lot of useful information
in an attribute.
}
\examples{
s3_methods_class("Date")
s3_methods_generic("anova")
}
