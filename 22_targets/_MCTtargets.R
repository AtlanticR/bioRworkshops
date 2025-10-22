# Load packages required to define the pipeline:
if(!require(librarian)) install.packages("librarian")
pkgs <- c("targets",
          "sf",
          "arcpullr",
          "robis",
          "dplyr")

librarian::shelf(pkgs)

tar_option_set(packages = basename(pkgs))


list(
  tar_target(
    name = MPAs,
    # getting sites from draft network:
    # https://open.canada.ca/data/en/dataset/bb048082-bc05-4588-b4f0-492b1f1b8737
    command = get_spatial_layer("https://egisp.dfo-mpo.gc.ca/arcgis/rest/services/open_data_donnees_ouvertes/draft_conservation_network_sites/MapServer/0",
                                where = "Classification_E='Existing site' AND LeadAgency_E='Fisheries and Oceans Canada'")
      ),

  tar_target(
    name = obis_data,
    command = {
      #getting OBIS data for northern bottlenose whale within the bounding box of the MPAs
      occurrence(scientificname = "Hyperoodon ampullatus",
                         geometry = st_as_text(st_as_sfc(st_bbox(MPAs)))) |>
        mutate(MPA_name = MPAs$SiteName_E)

      },
    pattern = map(MPAs)
  )
)
