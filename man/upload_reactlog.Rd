% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reactlog.R
\name{upload_reactlog}
\alias{upload_reactlog}
\title{Generate Shiny app reactlog}
\usage{
upload_reactlog(timeout = 5, headless_actions = NULL)
}
\arguments{
\item{timeout}{Time to wait after starting the subprocess (s). Useful is you know
how much time the app takes to load.}

\item{headless_actions}{Custom code passed as a string to manipulate the app with headless
web browser, for instance
\code{"headless_app$set_inputs(obs = 200); headless_app$run_js('1+1');"}.
If NULL, the app will undergo a classic random Monkey test session.}
}
\description{
Runs app in subprocess, controls it with headless browser
and generate reactlog file for GitLab CI/CD.
}
