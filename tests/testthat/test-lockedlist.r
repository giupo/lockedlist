test_that("lockedlist creates a directory and a lock file", {
  path <- rutils::tempdir()
  on.exit(unlink(path, recursive = TRUE))
  x <- lockedlist$new(path)
  expect_true(file.exists(file.path(path, "lock")))
})

test_that("an empty lockedlist do not create a data file", {
  path <- rutils::tempdir()
  on.exit(unlink(path, recursive = TRUE))
  x <- lockedlist$new(path)
  expect_false(file.exists(file.path(path, "data.qs")))
})

test_that("an empty lockedlist do  create a data file when set is invoked", {
  path <- rutils::tempdir()
  on.exit(unlink(path, recursive = TRUE))
  x <- lockedlist$new(path)
  expect_false(file.exists(file.path(path, "data.qs")))

  x$set(list(A = 1))
  expect_true(file.exists(file.path(path, "data.qs")))
})

test_that("lockedlist persist if path persists", {
  path <- rutils::tempdir()
  on.exit(unlink(path, recursive = TRUE))

  x <- lockedlist$new(path)
  x$set(list(A = 1))
  expect_true(file.exists(file.path(path, "data.qs")))
  expect_true("A" %in% x$names())

  # create another object on the same path
  y <- lockedlist$new(path)
  expect_true("A" %in% y$names())
})

test_that("lockedlist prints the number of objs", {
  path <- rutils::tempdir()
  on.exit(unlink(path, recursive = TRUE))

  x <- lockedlist$new(path)
  x$set(list(A = 1))
  expect_true(file.exists(file.path(path, "data.qs")))
  expect_true("A" %in% x$names())

  expect_output(x$print(), "1 objs")
})

test_that("I can retrieve data from lockedlist", {
  path <- rutils::tempdir()
  on.exit(unlink(path, recursive = TRUE))

  x <- lockedlist$new(path)
  x$set(list(A = 1))

  expect_equal(x$get("A"), list(A = 1))
})

test_that("`set` merges common elements", {
  path <- rutils::tempdir()
  on.exit(unlink(path, recursive = TRUE))

  x <- lockedlist$new(path)
  x$set(list(A = 1))
  expect_true("A" %in% x$names())
  expect_equal(x$get("A"), list(A = 1))
  expect_false("B" %in% x$names())

  x$set(list(A = 2, B = 2))

  expect_true("A" %in% x$names())
  expect_equal(x$get("A"), list(A = 2))
  expect_true("B" %in% x$names())
})
