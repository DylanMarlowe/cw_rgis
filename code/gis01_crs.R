# Coordinate Reference System
if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview)
# "p_load" loads multiple packages at once



# Get fish site data
df_fish <- read_csv("data/data_finsync_nc.csv")
print(df_fish)



# Remove duplicates in the data
sf_site <- df_fish %>% 
  distinct(site_id, lon, lat) %>% 
  st_as_sf(coords = c("lon", "lat"),
           crs = 4326)
# "distinct" gathers only specific entries.
# "st_as_sf" converts regular df into geometric df (good for coordinates)
# "coords" must start with "lon", then "lat" aka "x", then "y"
#"crs" or "coordinate reference system" is used to apply a system to follow



# Mapping
mapview(sf_site)



# Export
saveRDS(sf_site, "data/sf_finsync_nc.rds")



# Projection
sf_ft_wgs <- sf_site %>% 
  slice(c(1, 2))

sf_ft_utm <- sf_ft_wgs %>% 
  st_transform(crs = 32617)

mapview(sf_ft_wgs)

st_distance(sf_ft_utm)
# "slice" simplifies the rows we have, according to what we choose
# "sf_transform" changes crs (degrees to meters here)
#"sf_distance" measures distanc between distance measurements



# Exercises
#1
df_quakes <- as_tibble(quakes)
#latitude - lat
#longitude - long


#2
sf_quakes <- df_quakes %>% 
  st_as_sf(coords = c("long", "lat"),
           crs = 4326)

mapview(sf_quakes)


#3
sf_ft_quakes<- sf_quakes %>% 
  slice(c(1, 2))
  
sf_ft_quakes_proj <- sf_ft_quakes %>% 
  st_transform(crs = 32760)

st_distance(sf_ft_quakes_proj)


#4
saveRDS(sf_quakes, file = "data/sf_quakes.rds")