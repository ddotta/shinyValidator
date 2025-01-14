#' Profile a shiny app
#'
#' Start Shiny + profvis in the background. Chrome connects
#' to the app and then closes to interrupt profvis.
#' The profile report is then saved and exported in the public
#' folder needed for CI/CD.
#'
#' @inheritParams audit_app
#'
#' @return Write a .Rprof file to be reused by CI/CD to publish the report on GitLab pages
#' @export
profile_app <- function(timeout = 5, headless_actions = NULL) {
  message("\n---- BEGIN CODE PROFILE ---- \n")
  prof_app <- start_r_bg(profile_bg)
  # chrome is just needed to trigger onSessionEnded callback from app_server
  chrome <- shinytest2::AppDriver$new(
    "http://127.0.0.1:3515",
    load_timeout = timeout * 1000
  )
  if (!is.null(headless_actions)) {
    run_monkey_test(chrome, headless_actions, screenshot = FALSE)
  }
  chrome$stop()
  Sys.sleep(1) # required so that we can get_result()

  if (!dir.exists("public")) dir.create("public")
  htmlwidgets::saveWidget(prof_app$get_result(), "public/code-profile.html")
}
