###### Vector 2: Spatial Join ######
# Before Starting ---------------------------------------------------------

if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview)

rm(list = ls()) # Erase old objects in environment

# Read, Visualize, and Join -----------------------------------------------

# Read data
sf_site <- readRDS("data/sf_finsync_nc.rds")
sf_nc_county <- readRDS("data/sf_nc_county.rds")

# Visualize
mapview(sf_nc_county, legend = FALSE) + mapview(sf_site, legend = FALSE)

# Join county info to sf_site
sf_site_join<- st_join(x = sf_site,
                       y = sf_nc_county)

# Counting With Mapping Example -------------------------------------------

# Count the number of fish survey sites within Guilford county
sf_site_guilford <- sf_site_join %>% 
  filter(county == "guilford")

# Count the number of sites in Clay county
sf_site_clay <- sf_site_join %>% 
  filter(county == "clay")

# Re-read stream layer
sf_str <- readRDS("data/sf_stream_gi.rds")

# Produce a map with Guilford County polygon, sites, and stream lines
# Use ggplot() mapping function
sf_gi_county <- sf_nc_county %>% 
  filter(county == "guilford")

ggplot() +
  geom_sf(data = sf_gi_county) +
  geom_sf(data = sf_str,
          color = "blue") +
  geom_sf(data = sf_site_guilford,
          color = "red")

# Geometric Analysis ------------------------------------------------------

# Length #

sf_str_proj <- st_transform(sf_str,
                            crs = 32617)

# Calculate the length of each stream line segment
v_str_l <- st_length(sf_str_proj)

head(v_str_l)

sf_str_w_len <- sf_str %>%
  mutate(length = v_str_l)

# Area #

sf_nc_county_proj <- st_transform(sf_nc_county,
                                  crs = 32617)

# Calculate the area of county polygons
v_area <- st_area(sf_nc_county_proj)

# Create a column "area" in sf_nc_county_proj
# Identify which county is the largest
sf_nc_county_w_area <- sf_nc_county_proj %>% 
  mutate(area = as.numeric(v_area) / 1E+6) %>% #Conversion from m^2 to km^2
  arrange(desc(area))

# Subset polygons for mapping
sf_county1k <- sf_nc_county_w_area %>% 
  filter(area > 1000) #1000 km^2

# Map the subset of counties
ggplot() +
  geom_sf(data = sf_county1k)

# Exercise ----------------------------------------------------------------

#1
sf_quakes <- readRDS("data/sf_quakes.rds")

sf_nz <- readRDS("data/sf_nz.rds")

mapview(sf_nz) + mapview(sf_quakes)

sf_quakes_join <- st_join(sf_quakes,
                          sf_nz)

sf_quakes_nz <- sf_quakes_join %>% 
  drop_na(fid)

nrow(sf_quakes_nz) # Three earthquake events in New Zealand



#2
sf_site_county <- sf_site_join

df_n <- sf_site_join %>% 
  as_tibble() %>% 
  group_by(county) %>% 
  summarize(n = n()) %>% 
  ungroup()



#3

sf_n_site <- left_join(x = sf_nc_county,
                       y = df_n)

sf_n10 <- sf_n_site %>% 
  filter(n > 10)



#4
ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_n_site %>% 
            filter(n > 1),
          fill = "grey") +
  geom_sf(data = sf_n10,
          fill = "salmon")