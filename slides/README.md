# Suggestions for quarto / revealjs slides

## Key for slides

The main class schedule table is rendered by `index.qmd` and assumes that files are named e.g., `slides/slide-01.qmd`, which would place these slides into the "Slides" column on row `01` (left side) of the table.

Slide numbers correspond to the class number on the left of the main schedule table.

-   Slides 01-09: R bootcamp
-   Slides 10-15: Stats bootcamp

## Suggestions for slide content.

-   The [quarto docs](https://quarto.org/docs/presentations/revealjs/) on slide markup are excellent. They are spread over a few pages, with simpler and more advanced approaches.

### Headers

-   Use h1 headers (`#`) to demarcate sections of slides. The title will appear on its own slide. These also improve navigation in the overview (`Esc` when you're in the slide show).

-   Slides under the headers start with h2 (`##`).

-   You can also use h3 and h4, but I don't find them to be useful in practice as stuff usually spills off the end of the slide.

### Code formatting

If you are displaying code on a slide, and expect them to type it out, consider the following:

-   Ensure that the code doesn't spill over the code block on a slide. If they are following along on the projector screen and not on their own screens, they won't be able to slide the slider, and it will be annoying for you to do so.

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
  scale_color_brewer(
    palette = "Set1"
  )
```

You can run `styler::style_file()` on the qmd and it will help move things around (but definitely isn't perfect, so inspect the changes).

-   For longer code chunks where you want them to type something so that they're actually thinking about it, use a "fill in the blanks" approach rather than having them type everything out.

``` r
#| eval: false
# *important* be sure to include the `eval: false` label above
# so that quarto doesn't try to render it.
# (which will fail because of the blanks below)
gggplot(
  ___,
  aes(
    x = ___, 
    y = ___
  ) 
) + geom_???
```

-   Ensure you are using shortest possible names for variables, assuming you are expecting students to type things out. Especially the early learners will feel the need to type things out exactly

    E.g., so this code:

    ``` r
    myFancyNewDataFrame <- tibble(columnX = c(1,2,3), columnY = c(2,4,6))
    ```

    should be:

    ``` r
    tbl <- tibble(x = c(1,2,3), y = c(2,4,6))
    ```

-   Prefer quarto-style over Rmarkdown-style code chunks. Readability is better with quarto style, plus the editor will do tab-completion for you.

```` markdown
```{r}
#| label: chunk-1
#| warning: false
# quarto style
```

```{r chunk-1, warning=FALSE}
# rmarkdown style 
```
````

-   Use the revealjs separators `. . .` and `---` throughout slides. `. . .` places a stall in a slide that you click through to reveal. `---` creates a new slide, and you don't need a header on the new one, so use it mainly to continue the thought from a previous slide.

-   Use the [`output-location`](https://quarto.org/docs/presentations/revealjs/index.html#output-location) chunk label to direct output:

    -   `column` puts the output in a second column next to the code chunk. useful for text output
    -   `column-fragment` is like `column`, but you click to reveal the output
    -   `fragment` places the output below a code chunk that spans the width of the slide
    -   `slide` places the output on the next slide. useful for larger, more complex plots.

    [See. the above in action.](https://mine-cetinkaya-rundel.github.io/quarto-tip-a-day/posts/05-output-location/)

-   Use [`aside` blocks](https://quarto.org/docs/presentations/revealjs/index.html#asides-footnotes) for peripheral suggestions.

### Other formatting

These approaches will surprise students the least.

-   Spell out `TRUE` and `FALSE` instead of the shorthand `T` and `F`. Explicit is better than implicit.
-   Prefer `tibble()` over `data.frame()` (find and replace)
-   Prefer base `|>` over magrittr `%>%` (find and replace)
