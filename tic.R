get_stage("before_install") %>%
  add_code_step(update.packages(ask = FALSE))

get_stage("install") %>%
  add_code_step(remotes::install_deps(dependencies = TRUE))

if (ci_on_travis()) {
  get_stage("deploy") %>%
    add_code_step(rmarkdown::render_site())

  if (ci_has_env("id_rsa")) {
    get_stage("before_deploy") %>%
      add_step(step_setup_ssh())

    get_stage("deploy") %>%
      add_step(step_push_deploy(path = "_site", branch = "gh-pages"))
  }
}
