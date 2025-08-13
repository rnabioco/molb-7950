# MOLB 7950 - Informatics and Statistics for Molecular Biology

## Project Overview

This is a Quarto website project containing teaching materials for a one semester course on informatics and statistics for molecular biology Ph.D. students. The course is structured with bootcamp materials, DNA block, and RNA block content.

## Project Structure

- **Exercises** (`exercises/`): Interactive exercises for students (`.qmd` files)
- **Problem Sets** (`problem-sets/`): Weekly assignments with keys in `problem-set-keys/`
- **Slides** (`slides/`): Lecture presentations 
- **Data** (`data/`): Course datasets organized by block (bootcamp, block-dna, block-rna)
- **Resources** (`resources/`): Additional learning materials
- **Course Info** (`course-info/`): Syllabus, team info, project guidelines

## Key Instructions for AI Assistants

### Content Requirements

- **Always read all `.qmd` files** when working on content-related tasks
- **All code chunks generating figures MUST include a `fig-alt` chunk option** with a clear, descriptive explanation of what the figure shows
- Follow existing code style and conventions found in similar files
- Use the same R packages and libraries already present in the codebase

### File Editing Guidelines

- **NEVER create new files** unless absolutely necessary for the specific task
- **Always prefer editing existing files** over creating new ones
- **Never proactively create documentation files** (*.md, README) unless explicitly requested
- When editing `.qmd` files, maintain the existing YAML frontmatter structure
- Preserve existing chunk options and naming conventions

### Code Standards

- Follow existing R coding patterns found in the codebase
- Use tidyverse conventions (dplyr, ggplot2, etc.) as established in existing files
- Ensure all visualizations are accessible with proper alt text
- Include appropriate error handling where established patterns exist

### Content Organization

- Exercises should be progressive and build on previous concepts
- Problem sets should align with lecture slides and exercises
- All datasets should be properly documented in `data/README.md`
- Images should be organized in appropriate subdirectories under `img/`

### Quarto-Specific Guidelines

- Use established chunk naming patterns (e.g., `plot-name`, `analysis-step`)
- Maintain consistent YAML formatting across files
- Follow the established theme and styling conventions
- Ensure all cross-references work properly

### R Environment

- The project uses `renv` for package management
- Check `renv.lock` for exact package versions
- Use packages already included in the environment
- Follow established data loading patterns from `data-raw/` scripts

### Quality Assurance

- Test all code chunks before finalizing edits
- Verify that figure alt-text accurately describes visualizations
- Ensure mathematical formulations are properly formatted
- Check that all file paths and references are correct

### Working with Course Data

- Genomics data is organized by analysis type (bootcamp, block-dna, block-rna)
- Use established data loading patterns from existing exercises
- Maintain data provenance and documentation
- Follow established naming conventions for datasets

## Build and Deployment

The site uses Quarto's freeze feature to cache computational results. When making changes:

1. Test changes locally with `quarto preview`
2. Use `quarto render` to build the full site
3. The site is deployed automatically via GitHub Actions

## Important Notes

- This is an active teaching repository - maintain consistency with existing pedagogical approach
- All content should be appropriate for graduate-level molecular biology students
- Code examples should be clear, well-commented, and reproducible
- Consider accessibility in all content creation (alt-text, color choices, etc.)