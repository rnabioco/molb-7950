library(here)
library(fs)

save_data <- function(obj, compress = "xz", overwrite = TRUE, ...) {
  obj_name <- deparse(substitute(obj))
  file_path <- path(here("data", obj_name), ext = "rda")
  save(
    obj,
    file = file_path,
    compress = compress,
    overwrite = overwrite,
    ...
  )
}
