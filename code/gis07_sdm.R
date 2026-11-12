###### Species Distribution Modeling (SDM) ######
# Before Starting ---------------------------------------------------------
if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               ggeffects,
               sf,
               terra,
               tidyterra,
               exactextractr,
               mapview)

# Linking GIS To Ecology --------------------------------------------------
df_finsync <- read.csv("data/data_finsync_nc.csv")

## Returns 1426 rows
nrow(df_finsync)

df_st1 <- df_finsync %>% 
  filter(site_id == "finsync_nrs_nc-10013")

## Manipulate data format
df_rbs <- df_finsync %>% 
  pivot_wider(id_cols = c("site_id", "lon", "lat"),
              names_from = latin,
              values_from = presence,
              values_fill = 0) %>% 
  select(site_id,
         lon,
         lat,
         "Lepomis auritus") %>%
  rename(y = "Lepomis auritus")

## Associate environmental factors
sf_rbs <- df_rbs %>% 
  st_as_sf(coords = c("lon", "lat"),
           crs = 4326)

## Get temperature raster
spr_tmp_nc <- rast("data/spr_tmp_nc.tif")

sf_rbs_tmp <- extract(x = spr_tmp_nc,
                      y = sf_rbs,
                      bind = TRUE) %>% 
  st_as_sf()

df_rbs_tmp <- sf_rbs_tmp %>% 
  as_tibble() %>% 
  select(-geometry)

## Draw a figure that relates y (fish 1/0) to temperature
## y is on y-axis
## temperature is on x-axis
df_rbs_tmp %>% 
  ggplot(
    aes(
      x = temperature,
      y = y
    )
  ) +
  geom_point()

## Mapping
ggplot() +
  geom_spatraster(data = spr_tmp_nc) +
  geom_sf(
    data = sf_rbs,
          aes(color = factor(y))
    ) +
  scale_fill_viridis_c() +
  theme_bw()

# Statistical Analysis ----------------------------------------------------
m <- glm(y ~ temperature,
         data = df_rbs_tmp,
         family = "binomial")

summary(m)

## Visualize model output and type of output needed for project
df_pred <- ggpredict(m, terms = "temperature [9.35:17.35, by = 0.01]")

ggplot() +
  geom_point(
    data = df_rbs_tmp,
    aes(
      x = temperature,
      y = y
    )
  ) +
  geom_line(
    data = df_pred,
    aes(
      x = x,
      y = predicted
    )
  ) +
  geom_ribbon(
    data = df_pred,
    aes(
      x = x,
      ymin = conf.low,
      ymax = conf.high
    ),
    fill = 'grey',
    alpha = 0.2
  ) +
  labs(
    x = "Air temperature",
    y = "Probability of occurance"
  ) +
  theme_bw()