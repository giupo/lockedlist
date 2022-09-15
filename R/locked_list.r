#' lockedlist class
#' @description persists a list over filesystem and provides thread safe
#'   access via a file lock
#'
#' @examples
#' path <- rutils::tempdir()
#' on.exit(unlink(path, recursive = TRUE))
#' ll <- lockedlist$new(path)
#' ll$set(list(A = 1))
#' x <- ll$get("A")
#' @export
#' @importFrom filelock lock unlock
#' @importFrom qs qread qsave
#' @importFrom rutils tempdir

lockedlist <- R6::R6Class("LockedList", # nolint
  public = list(
    #' @description
    #' Creates a lockedlist
    #' @param path path where data will be serialized
    #'    (defaults to `rutils::tempdir("LockedList")`)
    initialize = function(path = rutils::tempdir("LockedList")) {
      private$path <- path
      private$lock_path <- file.path(path, "lock")
      private$data_path <- file.path(path, "data.qs")

      # reload data from fs
      lock <- filelock::lock(private$lock_path)
      on.exit(filelock::unlock(lock))
      private$unlocked_reload()
    },

    #' @description
    #' retrievs data based on names
    #' @param name string identifing the object in the `data` list
    get = function(name) {
      lock <- filelock::lock(private$lock_path)
      on.exit(filelock::unlock(lock))
      private$unlocked_reload()
      private$data[name]
    },

    #' @description
    #' Set a list in this lockedlist
    #' @param obj_as_list a names list object
    set = function(obj_as_list) {
      lock <- filelock::lock(private$lock_path)
      on.exit(filelock::unlock(lock))

      private$unlocked_reload()
      obj_names <- names(obj_as_list)
      common <- intersect(obj_names, names(private$data))
      # as long as I cannot find a merge for named lists
      for (name in common) private$data[[name]] <- obj_as_list[[name]]

      new_obj <- setdiff(obj_names, names(private$data))
      if (length(new_obj)) private$data <- c(private$data, obj_as_list[new_obj])

      private$unlocked_save()
    },

    #' @description
    #' print a string repr of this object
    #' @param ... generic params (unused)
    print = function(...) {
      cat("lockedlist: ", private$path, ",", length(private$data), "objs")
    },

    #' @description
    #' yields the names of the `data` list
    names = function() {
      lock <- filelock::lock(private$lock_path)
      on.exit(filelock::unlock(lock))
      names(private$data)
    }
  ),

  private = list(
    lock_path = NULL,
    data_path = NULL,
    path = NULL,
    data = list(),

    unlocked_save = function() {
      qs::qsave(private$data, private$data_path)
    },

    unlocked_reload = function() {
      if (!file.exists(private$data_path)) return()
      private$data <- qs::qread(private$data_path)
    }
  )
)
