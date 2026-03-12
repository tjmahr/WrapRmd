test_that("Can parse and evaluate comma-separated expressions", {
  text_easy <- "
    n_id = 20,
    n_per_t = 50,
    seed = 20260312
  "

  env <- new.env()
  assigned <- parse_argument_text_and_eval(text_easy, env)
  expected_names <- c("n_id", "n_per_t", "seed")
  expect_equal(assigned, expected_names)
  expect_all_true(ls(env) %in% expected_names)
  expect_equal(env$n_id, 20)

  text_harder <- "
    # some arguments won't have values. also there can be comments
    x,
    n_id = 20,
    # the arguments here should not be evaluated
    f = function(x = TRUE) NULL,
    n_per_t = 50,
    # arguments can refer to each otehr
    n_test = n_id + 10,
    # dots should be ignored and trailing commas should be tolerated
    ...,
    seed = 20260312,
  "

  env <- new.env()
  assigned <- parse_argument_text_and_eval(text_harder, env)

  expected_names <- c("n_id", "f", "n_per_t", "n_test", "seed")
  expect_equal(assigned, expected_names)
  expect_all_true(ls(env) %in% expected_names)
  expect_equal(env$n_id, 20)
  expect_equal(env$n_test, 30)
})
