library(tidyverse)



# point figure ------------------------------------------------------------

## Ctrl-Shift-R makes what is above, which you can name whatever you want

## Ctrl + Shift + M creates a pipe (%>%)

## "aes()" creates the axes, "geom_point()" creates the data on the graph, and "+" adds a new layer to ggplot, while "%>%" adds a new function entirely

iris %>%
  ggplot(
    aes(x = Sepal.Length,
        y = Sepal.Width)
  ) +
  geom_point()

## aes(..., color = COLUMNAME) to color by data
iris %>% 
  ggplot(
    aes(x = Sepal.Length,
        y = Sepal.Width,
        color = Species)
  ) +
  geom_point()

iris %>% 
  ggplot(
    aes(x = Sepal.Length,
        y = Sepal.Width)
  ) +
  geom_point(color = "darkgreen")



# line figure -------------------------------------------------------------

## "geom_line()" creates the data on the graph

df_x <- tibble(x = 1:50,
               y = 2 * x)

df_x %>% 
  ggplot(
    aes(x = x,
        y = y)
  ) +
  geom_line()



# histogram ---------------------------------------------------------------

iris %>% 
  ggplot(
    aes(x = Sepal.Length)
  ) +
  geom_histogram()



# boxplot -----------------------------------------------------------------

iris %>% 
  ggplot(
    aes(x = Species,
        y = Sepal.Length)
  ) +
  geom_boxplot()

## Change color (border)
iris %>% 
  ggplot(
    aes(x = Species,
        y = Sepal.Length,
        color = Species)
  ) +
  geom_boxplot()

## Change color (inside box)
iris %>% 
  ggplot(
    aes(x = Species,
        y = Sepal.Length,
        fill = Species)
  ) +
  geom_boxplot()



# exercise ----------------------------------------------------------------

# Q1 - Using 'iris' data, identify the longest Sepal.Length using arrange() function:

iris %>% 
  arrange(desc(Sepal.Length))

# Q2 - Using 'iris' data, filter/select individulas with Sepal.Width greater than 3.0:

iris %>% 
  filter(Sepal.Width > 3.0)

# Q3 - Using 'iris' data, select the columns "Petal.Length" and "Petal.Width", and arrange the order of the rows by "Petal.Length". Assign the results to object "df_petal":

df_petal <- iris %>% 
  select(Petal.Length, Petal.Width) %>% 
  arrange(desc(Petal.Length))

# Q4 - Calculate mean Sepal.Width by Species. Assign the results to "df_mean":

df_mean <- iris %>% 
  group_by(Species) %>% 
  summarize(mean = mean(Sepal.Width))

# Q5 - Create a point figure of Petal.Width (y-axis) and Sepal.Width(x-axis) with colors distinguishing Species:

iris %>% 
  ggplot(
    aes(x = Sepal.Width,
        y = Petal.Width,
        color = Species)
  ) +
  geom_point()