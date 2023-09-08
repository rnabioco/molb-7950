# Suggestions for quarto / revealjs slides

## Key for slides

The main class schedule table is rendered by `index.qmd` and assumes that files are named e.g., `slides/slide-01.qmd`, which would place these slides into the "Slides" column on row `01` (left side) of the table.

Slide numbers correspond to the class number on the left of the main schedule table.

-   Slides 01-09: R bootcamp
-   Slides 10-15: Stats bootcamp

## Suggestions for slide content.

- The [quarto docs](https://quarto.org/docs/presentations/revealjs/) on slide markup are excellent. They are spread
  over a few pages, with simpler and more advanced approaches.

-   Use h1 headers (`#`) to demarcate sections of slides. The title will appear on its own slide.

-   Slides under the headers start with h2 (`##`).

If you are displaying code on a slide, and expect them to type it out, consider the following:

-   Ensure that the code doesn't spill over the code block on a slide.

E.g., this code:

``` r
ggplot(mtcars, aes(x = hp, y = mpg, color = factor(cyl)) + geom_point(size = 3) + scale_color_brewer(palette = 'Set1')
```

should be reformatted with shorter, individual lines:

``` r
ggplot(
  mtcars,
  aes(
    x = hp,
    y = mpg,
    color = factor(cyl)
  )
) +
  geom_point(size = 3) +
  scale_color_brewer(palette = "Set1")
```

You can run `styler::style_file()` on the qmd and it will help move things around (but definitely isn't perfect, so inspect the changes).

-   Ensure you are using shortest possible names for variables, assuming you are expecting students to type things out. Especially the early learners will feel the need to type things out exactly.

    E.g., so this code:

    ``` r
    myFancyNewDataFrame <- tibble(columnX = c(1,2,3), columnY = c(2,4,6))
    ```

    should be:

    ``` r
    tbl <- tibble(x = c(1,2,3), y = c(2,4,6))
    ```

-   Use the revealjs separators `. . .` and `---` throughout slides. `. . .` places a stall in a slide that you click through to reveal. `---` creates a new slide, and you don't need a header on the new one, so use it mainly to continue the thought from a previous slide.

-   Use the `output.location` chunk label to direct output.

    -   `column` puts the output in a second column next to the code chunk. useful for text output
    -   `column-fragment` is like \`column, but you clide to reveal the output
    -   `fragment` places the output below a code chunk that spans the width of the slide
    -   `slide` places the output on the next slide. useful for larger, more complex plots.

- Use [`aside` blocks](https://quarto.org/docs/presentations/revealjs/index.html#asides-footnotes) for peripheral suggestions.

Other formatting suggestions, which will surprise students the least:

-   Prefer `tibble()` over `data.frame()` (find and replace)
-   Prefer base `|>` over magrittr `%>%` (find and replace)
