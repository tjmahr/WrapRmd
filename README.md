# WrapRmd

[![Travis-CI Build Status](https://travis-ci.org/tjmahr/WrapRmd.svg?branch=master)](https://travis-ci.org/tjmahr/WrapRmd)

An [RStudio Addin](https://rstudio.github.io/rstudioaddins/) to wrap paragraphs
of RMarkdown text without inserting line breaks into inline R code.

## Installation

You can install the plain version WrapRmd from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("tjmahr/WrapRmd")
```

The plain version is suitable for wrapping simple paragraphs of markdown text,
as in the gifs below.

To install the developmental branch, which uses
[commonmark](https://cran.r-project.org/web/packages/commonmark/index.html) to
reformat markdown, use:

``` r
devtools::install_github("tjmahr/WrapRmd", ref = "experimental")
```

The developmental version can handle markdown lists and will not break links,
but it has some quirks that have to be ironed out.


## Overview

Here is some nice looking RMarkdown:

```
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum a `r max(iris$Sepal.Length)`, viverra nisl at, luctus ante = `r length(letters) * 2 + 100`.
```

You highlight the text, and hit `Ctrl/Cmd + Shift + /` to wrap the text and get:

```
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum a `r
max(iris$Sepal.Length)`, viverra nisl at, luctus ante = `r length(letters) * 2 +
100`.
```

This RStudio Addin wraps text, but doesn't insert line breaks into inline R
code, yielding:

```
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum
a `r max(iris$Sepal.Length)`, viverra nisl at, luctus ante =
`r length(letters) * 2 + 100`.
```

![An animation of the above](demo.gif)

## Notes

Then go to Tools > Addins in RStudio to select and configure addins. I've mapped 
this one addin to the shortcut `Ctrl + Shift + Alt + /`.

Currently, the package wraps lines using a maximum line width of 80 characters.

It should work on multiple paragraphs:

![Animation of wrapping paragraphs separately](multi_paragraph.gif)
