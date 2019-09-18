context("mapbox_styles")

test_that("Test mapbox_styles", {
  expect_is(mapbox_style(1), "character")
  expect_is(mapbox_style(1, print = T), "character")
  expect_is(mapbox_style(1, optimized = T), "character")

  sl <- mapbox_style(owner = "user", styleid = "style_id")
  expect_is(sl, "character")
  expect_true(sl == "mapbox://styles/user/style_id")

  expect_error(mapbox_style(100))
})
