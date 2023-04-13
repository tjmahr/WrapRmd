test_that("interleaving strings", {
  # sneak private function out
  str_interleave <- WrapRmd:::str_interleave

  # 2:1 interleave
  expect_equal(
    str_interleave(c("s1", "s2"), c("_l1_")),
    "s1_l1_s2")

  # 3:2 interleave
  expect_equal(
    str_interleave(c("s1", "s2", "s3"), c("_l1_", "_l2_")),
    "s1_l1_s2_l2_s3")

  # 1:X -- Ignore interleavers if just one string
  expect_equal(str_interleave(c("s1"), c("_l1_")), "s1")
  expect_equal(str_interleave(c("s1"), character(0)), "s1")

  # 3:1 -- error
  expect_error(str_interleave(c("s1", "s2", "s3"), c("_l1_")))
})
