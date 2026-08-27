#Only have to install once in R, after that just using library() to load:
# install.packages("tidyverse")
# library(tidyverse)



# Taken from BioStats textbook, Chapter 5:
set.seed(123)

iris_sub <- as_tibble(iris) %>% 
  group_by(Species) %>% 
  sample_n(3) %>% 
  ungroup()

print(iris_sub)



#Functions:
filter(iris_sub, Species == "virginica")

filter(iris_sub, Species %in% c("virginica", "versicolor"))

filter(iris_sub, Species != "setosa")

filter(iris_sub, Petal.Length < 5)

filter(iris_sub, Petal.Length > 5 | Sepal.Length > 5)

filter(iris_sub, Petal.Length > 5,
       Sepal.Length > 5)



#Sorting
arrange(iris_sub, Sepal.Width) #ascending order

arrange(iris_sub, desc(Sepal.Width)) #descending order



#Assignment <- and 5.1.3 Exercise
iris_3 <- filter(iris_sub,
                 Sepal.Width > 3)

iris_setosa <- filter(iris_sub,
                      Species == "setosa")

iris_3_setosa <- filter(iris_sub, Sepal.Width > 3,
                        Species == "setosa")



#Select()
select(iris.sub,
       Sepal.Length,
       Sepal.Width) #Selects these columns

select(iris.sub,
       -Sepal.Length,
       -Sepal.Width) #Selects everything but these columns

select(iris.sub,
       -c(Sepal.Length,
          Sepal.Width)) #Selects everything but these columns

select(iris_sub,
       starts_with("Sepal")) #Finds anything that starts with this

select(iris_sub,
       contains("Sepal")) #Finds anything that contains this



#Mutate()

x_max <-  nrow(iris_sub)

x <- 1:x_max

mutate(iris_sub,
       row_id = x)

mutate(iris_sub,
       mu_sl = mean(Speal.Length)) #Finds the mean

mutate(iris_sub,
       sep.area = Sepal.Length * Sepal.Width / 2) #Finds the area

mutate(group_by(iris_sub, Species),
       mu_sl = mean(Sepal.Length)) #Groups and finds the mean



# 5.2.3 Exercise

iris_pw <- select(iris_sub,
                  Petal.Width,
                  Species)

iris_petal <- select(iris_sub,
                     starts_with("petal"))

iris_pw_two <- mutate(iris_sub,
                      pw_two_times = Petal.Width * 2)



#Pipe

iris_sub %>%
  filter(Species == "virginica")

iris_sub %>%
  group_by(Species) %>%
  mutate(mu_sl = mean(Sepal.Length))
  ungroup() #Groups and find the mean using pipes, then ungroups



# 5.3.2 Exercise
  
iris_pipe <- iris_sub %>%
  filter(Species == "setosa") %>%
  mutate(pw_two_times = Petal.Width * 2)



#summarize()

iris_summary <- iris_sub %>%
  group_by(Species) %>%
  summarize(mu_sl = mean(Sepal.Length),
            sum_sl = sum(Sepal.Length))