install.packages("ggplot2")  # For plotting
install.packages("dplyr")    # For data manipulation
install.packages("lubridate")
library(ggplot2)
library(dplyr)
library(lubridate)
library(tidyr)

january_data <- read.csv("data/all-202401.csv")
february_data <- read.csv("data/all-202402.csv")
march_data <- read.csv("data/all-202403.csv")


all_data <- rbind(january_data, february_data, march_data)

# clean data, we only want to deal with desktop and companies that have 3 months of data
all_data <- all_data %>% filter(device != "phone") 
all_data <- all_data %>% filter(device != "tablet") 
all_data <- all_data %>% filter(origin != "https://www.on.com") 
all_data <- all_data %>% filter(origin != "https://www.hoka.com") 


# add an actual date column to use as an x-axis
all_data$date_type <- ym(all_data$yyyymm)
print(all_data)

ggplot(all_data, aes(x=date_type, y=p75_fcp, group=origin, color=origin)) +
  geom_line() +
  theme(
    legend.position = "bottom",
    plot.background = element_rect(fill = "white", color = NA), 
    panel.background = element_rect(fill = "white", color = NA),
    legend.text = element_text(size = 11, family = "Arial", face = "bold")) +
  guides(color = guide_legend(ncol = 2)) +
  geom_line(size = 1.5) + # Thicker lines  
  scale_x_date(date_labels = "%B %Y", date_breaks = "1 month") +
  labs(
    x = "Month",
    y = "FCP",
    title = "First Contentful Paint - p75th"
  ) 

ggplot(all_data, aes(x=date_type, y=p75_lcp, group=origin, color=origin)) +
  geom_line() +
  theme(
    legend.position = "bottom",
    plot.background = element_rect(fill = "white", color = NA), 
    panel.background = element_rect(fill = "white", color = NA),
    legend.text = element_text(size = 11, family = "Arial", face = "bold")) +
  guides(color = guide_legend(ncol = 2)) +
  geom_line(size = 1.5) + # Thicker lines
  scale_x_date(date_labels = "%B %Y", date_breaks = "1 month") +
  labs(
    x = "Month",
    y = "LCP",
    title = "Largest Contentful Paint - p75th"
  ) 

  
ggplot(all_data, aes(x=date_type, y=p75_ttfb, group=origin, color=origin)) +
  geom_line() +
  theme(
    legend.position = "bottom",
    plot.background = element_rect(fill = "white", color = NA), 
    panel.background = element_rect(fill = "white", color = NA),
    legend.text = element_text(size = 11, family = "Arial", face = "bold")) +
  guides(color = guide_legend(ncol = 2)) +
  geom_line(size = 1.5) + # Thicker lines
  scale_x_date(date_labels = "%B %Y", date_breaks = "1 month") +
  labs(
    x = "Month",
    y = "TTFB",
    title = "Time to First Byte - p75th"
  ) 


all_average_data <- all_data %>%
  group_by(origin) %>%
  summarise(avg_value = mean(desktopDensity))

# Lookup function to rename groups
lookup <- function(x) {
  lookup_table <- c("https://www.adidas.com" = "Adidas", "https://www.newbalance.com" = "New Balance", "https://www.nike.com" = "Nike", "https://www.underarmour.com" = "Under Armour")
  return(lookup_table[x])
}

# Create the bar plot
ggplot(all_average_data, aes(x = origin, y = avg_value, fill = origin)) +
  geom_bar(stat = "identity") +
  scale_x_discrete(labels = function(x) lookup(x)) + 
  labs(title = "Percent of Desktop Users", x = "Origin", y = "Percentage") +
  theme_minimal()


all_grouped_average_data <- all_data %>%
  group_by(origin) %>%
  summarise(
    avg_fast_lcp = mean(fast_lcp)*10000,
    avg_p75_lcp = mean(p75_lcp)
  )

all_grouped_average_data_long <- all_grouped_average_data %>%
  gather(key = "variable", value = "mean_value", avg_fast_lcp, avg_p75_lcp)


min_value2 <- min(all_grouped_average_data$avg_fast_lcp)
max_value2 <- max(all_grouped_average_data$avg_fast_lcp)

# Create the bar plot
ggplot(all_grouped_average_data_long, aes(x = origin, y = mean_value, fill = variable)) +
  geom_bar(stat = "identity", position = "dodge") +  # Position bars side by side
  scale_x_discrete(labels = function(x) lookup(x)) +  # Rename x-axis labels using the lookup function
  labs(title = "LCP vs Percentage of Fast LCP", x = "Group", y = "Average Value") +
  scale_y_continuous(
    name = "Average LCP", 
    sec.axis = sec_axis(
      trans = ~ . / 10000, 
      name = "Average Percentage of Fast LCP"
    )  # Secondary y-axis for 'avg_value2'
  ) +
  theme_minimal()



all_average_4g_data <- all_data %>%
  group_by(origin) %>%
  summarise(avg_value = mean(X_4GDensity))



# Create the bar plot
ggplot(all_average_4g_data, aes(x = origin, y = avg_value, fill = origin)) +
  geom_bar(stat = "identity") +
  scale_x_discrete(labels = function(x) lookup(x)) + 
  labs(title = "Percentage of 4g Users", x = "Origin", y = "Percentage") +
  theme_minimal()

