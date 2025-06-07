# add_fig_alt_stubs.R
# Script to add fig.alt stubs to ggplot2 visualization chunks in Quarto files

library(stringr)
library(fs)
library(purrr)
library(here)

# Function to process a single Quarto file
process_qmd_file <- function(file_path) {
  # Read the file content
  lines <- readLines(file_path, warn = FALSE)

  # Initialize variables
  in_chunk <- FALSE
  has_ggplot <- FALSE
  has_fig_alt <- FALSE
  chunk_start_line <- NULL
  modified <- FALSE

  # Process each line
  for (i in seq_along(lines)) {
    line <- lines[i]

    # Check if we're entering a code chunk
    if (str_detect(line, "^```\\{r") && !in_chunk) {
      in_chunk <- TRUE
      chunk_start_line <- i
      has_ggplot <- FALSE
      has_fig_alt <- FALSE
    }

    # Check if the chunk has ggplot
    if (
      in_chunk &&
        (str_detect(line, "\\+\\s*ggplot") ||
          str_detect(line, "\\s*ggplot\\s*\\(") ||
          str_detect(line, "plot_") ||
          str_detect(line, "geom_"))
    ) {
      has_ggplot <- TRUE
    }

    # Check if the chunk already has fig.alt
    if (in_chunk && str_detect(line, "#\\|\\s*fig\\.alt:")) {
      has_fig_alt <- TRUE
    }

    # Check if we're exiting a code chunk
    if (str_detect(line, "^```$") && in_chunk) {
      # If this was a ggplot chunk without fig.alt, add one
      if (has_ggplot && !has_fig_alt) {
        # Find where to insert the fig.alt line (after any existing chunk options)
        insert_at <- chunk_start_line
        for (j in (chunk_start_line + 1):(i - 1)) {
          if (str_detect(lines[j], "^#\\|")) {
            insert_at <- j
          } else if (!str_detect(lines[j], "^\\s*$")) {
            # Stop when we hit actual code
            break
          }
        }

        # Add the fig.alt line
        lines <- c(
          lines[1:insert_at],
          "#| fig.alt: \"Description of the plot - PLEASE FILL IN\"",
          lines[(insert_at + 1):length(lines)]
        )

        # Adjust indices after insertion
        i <- i + 1
        modified <- TRUE
      }

      in_chunk <- FALSE
    }
  }

  # If changes were made, write the file back
  if (modified) {
    writeLines(lines, file_path)
    cat("Updated:", file_path, "\n")
  } else {
    cat("No changes needed for:", file_path, "\n")
  }

  return(modified)
}

# Find all Quarto files in the repository
qmd_files <- dir_ls(here(), recurse = TRUE, glob = "*.qmd")

# Process each file
results <- map_lgl(qmd_files, process_qmd_file)

# Summary
cat("\nSummary:\n")
cat("Total Quarto files processed:", length(qmd_files), "\n")
cat("Files modified:", sum(results), "\n")
cat("Files unchanged:", length(qmd_files) - sum(results), "\n")
