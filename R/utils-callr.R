#' Start run_app as background process
#'
#' Required by \link{start_r_bg}.
#'
#' @keywords internal
shiny_bg <- function() {
  options(shiny.port = 3515)
  pkgload::load_all()
  run_app()
}

#' Start shinyloadtest recorder in the background
#'
#' Required by \link{start_r_bg}.
#'
#' @keywords internal
recorder_bg <- function() {
  shinyloadtest::record_session(
    target_app_url = "http://127.0.0.1:3515",
    host = "127.0.0.1",
    port = 8600,
    output_file = "recording.log",
    open_browser = FALSE
  )
}

#' Start Shiny + profvis recorder in the background
#'
#' Required by \link{start_r_bg}.
#'
#' @keywords internal
profile_bg <- function() {
  options(keep.source = TRUE, shiny.port = 3515)
  pkgload::load_all()
  profvis::profvis(
    {
      profvis::pause(0.2)
      .profile_code <<- TRUE
      run_app()
    },
    simplify = FALSE,
    split = "v"
  )
}

#' Start run_app as background process
#'
#' Also enables reactlog.
#'
#' Required by \link{start_r_bg}.
#'
#' @keywords internal
reactlog_bg <- function() {
  options("shiny.port" = 3515)
  pkgload::load_all()
  .enable_reactlog <<- TRUE
  reactlog::reactlog_enable()
  run_app()
}

#' Start background R process
#'
#' Start process in the background. Required by
#' \link{record_app}, ...
#'
#' @param fun Passed to \link[callr]{r_bg}.
#'
#' @return Process or error
#' @keywords internal
start_r_bg <- function(fun) {
  process <- callr::r_bg(
    func = fun,
    stderr= "",
    stdout = ""
  )

  while (any(is.na(pingr::ping_port("127.0.0.1", 3515)))) {
    message("Waiting for Shiny app to start...")
    Sys.sleep(0.1)
  }

  attempt::stop_if_not(
    process$is_alive(),
    msg = "Unable to launch the subprocess"
  )

  process
}

is_inside_ci <- function() {
  !identical(Sys.getenv("CI", unset = ""), "")
}
