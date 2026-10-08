###### Raster 1: Basic terra operations #####
# before starting ---------------------------------------------------------

if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
               stars)

# raster data format ------------------------------------------------------

# rast() is a function to read data from your directory; requires "terra"
spr_ex <- rast("data/spr_example.tif")

# writeRaster() is a function to export raster data
writeRaster(x = spr_ex,
            filename = "data/spr_elev.tif",
            overwrite = TRUE)

# visualize raster data; geom_spatraster() (from "tidyterra" package)
ggplot() +
  geom_spatraster(
    data = spr_ex
    )

# if you want mapview() to work
star_ex <- st_as_stars(spr_ex)
mapview(star_ex)

# continuous data type in raster ------------------------------------------

v_elev <- values(spr_ex)

extract(spr_ex, y = cbind(6.0000, 50.0000))

#try to get the highest
extract(spr_ex, y = cbind(5.9, 49.85))

#lowest
extract(spr_ex, y = cbind(6.42, 49.81))

#random
extract(spr_ex, y = cbind(6.39, 49.79))

# extract data at multiple points
df_point <- tibble(
  lon = c(6, 5.9),
  lat = c(50, 49.96)
  )

extract(spr_ex, y = df_point)

# discrete data type in raster --------------------------------------------

# - 0, 1 binary representation
spr_for <- rast("data/spr_forest_nc.tif")

ggplot() +
  geom_spatraster(data = spr_for)

unique(spr_for)

v_binary <- values(spr_for)

mean(v_binary) * 100 # percent of forest in NC

# multiple classes - code values with multiple categories
spr_land <- rast("data/spr_land_reclass.tif")

# 1001 = forest, 1010 = crop, 1100 = urban
unique(spr_land)

# coordinate = lon -79.8063 and lat 36.0701
extract(spr_land, cbind(-79.8063, 36.0701))

# reclass data in raster --------------------------------------------------

# - matrix for category mapping
cm <- cbind(
  c(0, 1001, 1010, 1100),
  c(0, 1, 0, 0)
)

spr_bin <- classify(spr_land,
                    rcl = cm)

unique(spr_bin)

v_bin <- values(spr_bin)

mean(v_bin) * 100


# calculate % cropland
cm_crop <- cbind(
  c(0, 1001, 1010, 1100),
  c(0, 0, 1, 0)
)

spr_crop <- classify(
  x = spr_land,
  rcl = cm_crop
)

v_crop <- values(spr_crop)

mean(v_crop) * 100


# calculate % urban
cm_urban <- cbind(
  c(0, 1001, 1010, 1100),
  c(0, 0, 0, 1)
)

spr_urban <- classify(
  x = spr_land,
  rcl = cm_urban
)

v_urban <- values(spr_urban)

mean(v_urban) * 100

# exercise ----------------------------------------------------------------

#1.
spr_prec_ncne <- rast("data/spr_prec_ncne.tif")



#2.
# The rows and columns are depicted by the "size" segment. The number of rows is 162, while the number of columns is 532.

# Resolution as a pixel must always be a square, and the resolution in x and y is both 0.008333333.

# The spatial extent refers to the minimum and maximum longitude (x-axis) and latitude (y-axis). In this case, the longitude extent is -79.89191 to -75.45847, while the latitude extent is 35.24153 to 36.59153.

# The coordinate reference system refers to the method and mathematical approach to get numeric results. In this case our CRS is WGS 84.

# The minimum and maximum precipitation values refer to the least and most amount of precipitation measured. In this case, the minimum is 1063.099976, while the maximum is 1501.5.



#3.
ggplot() +
  geom_spatraster(
    data = spr_prec_ncne
  )



#4.
sf_site <- readRDS("data/sf_finsync_nc.rds")

df_xy <- st_coordinates(sf_site)

df_land <- extract(spr_land, df_xy)

df_land %>% 
  filter(code == 1001) %>% # forest = 111
  nrow()

df_land %>% 
  filter(code == 1010) %>%  # cropland = 2
  nrow()

df_land %>% 
  filter(code == 1100) %>% # urban = 9
  nrow()