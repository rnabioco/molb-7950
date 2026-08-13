# Shared reporting helpers for the package install/verify scripts.
# Kept dependency-free so setup-posit-cloud.R can source() it over https.

# some packages print on load, so swallow their output to keep the report clean
is_installed <- function(pkg) {
  ok <- FALSE
  suppressMessages(suppressWarnings(
    utils::capture.output(ok <- requireNamespace(pkg, quietly = TRUE))
  ))
  ok
}

pkg_version <- function(pkg) {
  tryCatch(
    as.character(utils::packageVersion(pkg)),
    error = function(e) NA_character_
  )
}

status_line <- function(mark, pkg, note = "") {
  cat(sprintf("  %-9s %-42s %s\n", mark, pkg, note))
}

# print ok/missing for each package; return the logical presence vector
report_status <- function(pkgs) {
  present <- vapply(pkgs, is_installed, logical(1))
  for (i in seq_along(pkgs)) {
    if (present[i]) {
      status_line("ok", pkgs[i], pkg_version(pkgs[i]))
    } else {
      status_line("missing", pkgs[i])
    }
  }
  present
}
