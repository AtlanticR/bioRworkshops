library(targets)

tar_option_set()  # default settings

list(
  tar_target(name=x,
             15),

  tar_target(name=
               y, 6),
  tar_target(name=
               z, x + y)
)
