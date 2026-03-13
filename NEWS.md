# WrapRmd 0.0.0.9008

  - New addin: assign_argument_defaults_addin to evaluate comma-separated 
    assignment expressions in a selection such as `x = 10, label = "test"`. 
    This addin makes it easy to assign default argument values for 
    interactively working on the body of a function.
  - Bump minimum R version to 4.2.0 (April 2022) because of `|>` and `_` syntax.
  - Rewrite README and refresh .gif demos.

# WrapRmd 0.0.0.9007

  - New addin: flip_backslashes_addin to convert `\` to `/`

# WrapRmd 0.0.0.9006

  - LaTeX-looking words (matching `\[A-Za-z]{`) are unescaped if 
    commonmark escaped the leading backslash.

# WrapRmd 0.0.0.9005

  - Inline math (that starts and ends with a `$` character) is treated like R 
  code during text-wrapping. It is protected from line breaks and having 
  `\` escapes from being inserted.

# WrapRmd 0.0.0.9004

  - Added support for avoiding inserting line breaks into `bookdown`
    cross-references (such as `Figure\ \@ref(fig:example)`).

# WrapRmd 0.0.0.9003

  - Added a `NEWS.md` file to track changes to the package.
