##### Vector 1 #####
# Before starting ---------------------------------------------------------

if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview)

rm(list = ls()) # Erases old objects in environment



# Read and export ---------------------------------------------------------

# SHAPE format - how to read vector data

sf_nc_county <- st_read(dsn = "data/nc.shp",
                        quiet = TRUE)



# SHAPE format - how to export shape files

st_write(sf_nc_county,
         dsn = "data/sf_nc_county.shp",
         append = FALSE)



# RDS format

saveRDS(sf_nc_county,
        file = "data/sf_nc_county.rds")

sf_nc_county <- readRDS(file = "data/sf_nc_county.rds")



# Point -------------------------------------------------------------------

sf_site <- readRDS("data/sf_finsync_nc.rds")

mapview(sf_site,
        col.regions = "black",
        legend = FALSE)



# Select and map the first 10 sites

sf_site_f10 <- sf_site %>% 
  slice(1:10)

mapview(sf_site_f10,
        col.regions = "red",
        legend = FALSE)



# Line --------------------------------------------------------------------

sf_str <- readRDS("data/sf_stream_gi.rds")

mapview(sf_str,
        color = "steelblue",
        legend = FALSE)



# Polygon -----------------------------------------------------------------

sf_nc_county <- readRDS("data/sf_nc_county.rds")

mapview(sf_nc_county,
        col.regions = "darkgreen",
        legend = FALSE)



# Select "guilford" county, then map (EXPECT ON EXAM)

sf_nc_gi <- sf_nc_county %>% 
  filter(county == "guilford")

mapview(sf_nc_gi,
        col.regions = "darkgreen",
        legend = FALSE)



# Static map in ggplot format ---------------------------------------------

ggplot() +
  geom_sf(data = sf_nc_county)

ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str) +
  geom_sf(data = sf_site)



# Exercise ----------------------------------------------------------------

#1.
sf_str_as <- readRDS("data/sf_stream_as.rds")



#2.

print(sf_str_as) # Geodetic CRS: WGS 84

print(sf_nc_county) # Geodetic CRS: WGS 84



#3.

ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str_as)



#4.

sf_nc_as <- sf_nc_county %>% 
  filter(county == "ashe")

ggplot() +
  geom_sf(data = sf_nc_as) +
  geom_sf(data = sf_str_as)



# Before compiling --------------------------------------------------------

# Ctrl + A and then Ctrl + Enter and Run code to see errors