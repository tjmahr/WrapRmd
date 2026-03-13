# WrapRmd

An [RStudio Addin](https://rstudio.github.io/rstudioaddins/) to wrap paragraphs
of RMarkdown text without inserting line breaks into inline R code.

<img src = "man/figures/main-demo.gif" width="600" alt="Animation of the addin running in RStudio"/>

## Installation

Install WrapRmd from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("tjmahr/WrapRmd")
```

## Overview

Here is some nice looking RMarkdown text, but it runs well past the 80 character
width we'd like to maintain in our document.

```
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum a `r max(iris$Sepal.Length)`, viverra nisl at, luctus ante = `r length(letters) * 2 + 100`.
```

The inline R code `r max(iris$Sepal.Length)` runs from column 72 to column 96.
The most natural place to insert a line break is the space `r` between
`max(iris$Sepal.Length)`. That would unfortunately break the inline R code.

If we highlight the text and call the Wrap Rmd addin, we get the following:

```
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum a
`r max(iris$Sepal.Length)`, viverra nisl at, luctus ante =
`r length(letters) * 2 + 100`.
```

Importantly, there is *no* line break inserted inside of the inline R code
`r max(iris$Sepal.Length)`, meaning that wrapping the text will not break inline
R code.

### Normalization

This package uses
[commonmark](https://cran.r-project.org/web/packages/commonmark/index.html) to
wrap and reformat markdown text. This pipeline is advantageous because
commonmark handles the difficult work of parsing the markdown text. But because
wrapping goes through commonmark, selected text may be normalized or escaped
during rewrapping. What the WrapRmd package provides is some additional work to
handle inline R Markdown and to undo some of the commonmark normalization that
conflicts with RMarkdown features.

In the following animation, we can see three (useful) commonmark normalizations:
HTML entities are converted into proper characters, the text in the list is
wrapped and cleaned up, and the issue numbers get an escape on the `#`
character.

<img src = "man/figures/commonmark-normalization.gif" width="600" alt="Animation of the addin running in RStudio"/>


### Other notes

**How to run addins**. There are two ways to run or view addins.

1.  Tools \> Addins, to view addins, run them, or set keyboard shortcuts.

2.  Tools \> Show Command Palette, then start typing the name of the addin to
    run. As a reminder, the Command Palette's keyboard shortcut is
    `Ctrl+Shift+P` or `Cmd+Shift+P`.

**Package options**. There are three package options with the following default
values. See `?commonmark::markdown_commonmark()`

``` r
WrapRmd.width = 80         # desired width of output text
WrapRmd.smart = FALSE      # whether to use "smart" punctuation 
WrapRmd.extensions = TRUE  # whether to enable GitHub extensions
```


## Bonus Addins

**Flip Backslashes to Forward Slashes**: Converts Windows-style backslashes
(`\`) to forward slashes (`/`) in the current selection.

**Knit Selection**: Runs the selected text through knitr/commonmark to
preview what the rendered markdown/html output will look like.

<img src = "man/figures/knit-selection.gif" width="600" alt="Animation of the addin running in RStudio and the console showing the knitted text."/>

**Assign argument defaults**: Evaluates comma-separated `x = y` expressions in
the current selection and assigns each value in the global environment.

Note how the environment pane populates with new variables in this example:

<img src = "man/figures/assign-defaults.gif" width="600" alt="Animation of the addin running in RStudio and the environment pane populating with new variables."/>

