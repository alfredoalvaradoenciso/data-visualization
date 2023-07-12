library(tidyverse)
library(ggrepel)
library(ggtext)

library(showtext)
font_add_google("Lato")
showtext_auto()

df_mac <- readr::read_csv('C:/Users/Dell/Desktop/WB/tenyears.csv')

# Also define the group of countries that are going to be highlighted
highlights <- c( "ARG", "BRA", "CHL", "COL", "MEX", "BOL")
n <- length(highlights)

df_mac_indexed_2008 <- df_mac %>% 
  group_by(iso_a3) %>%
  mutate(
    # Create 'group', used to color the lines.
    group = if_else(iso_a3 %in% highlights, iso_a3, "other"),
    group = as.factor(group)
  ) %>% 
  mutate(
    group = fct_relevel(group, "other", after = Inf),
    name_lab = if_else(year == 2019, name, NA_character_)
  ) %>% 
  ungroup()



# This theme extends the 'theme_minimal' that comes with ggplot2.
# The "Lato" font is used as the base font. This is similar
# to the original font in Cedric's work, Avenir Next Condensed.
theme_set(theme_minimal(base_family = "Lato"))


theme_update(
  # Remove title for both x and y axes
  axis.title = element_blank(),
  # Axes labels are grey
  axis.text = element_text(color = "grey40"),
  # The size of the axes labels are different for x and y.
  axis.text.x = element_text(size = 20, margin = margin(t = 5)),
  axis.text.y = element_text(size = 17, margin = margin(r = 5)),
  # Also, the ticks have a very light grey color
  axis.ticks = element_line(color = "grey91", size = .5),
  # The length of the axis ticks is increased.
  axis.ticks.length.x = unit(1.3, "lines"),
  axis.ticks.length.y = unit(.7, "lines"),
  # Remove the grid lines that come with ggplot2 plots by default
  panel.grid = element_blank(),
  # Customize margin values (top, right, bottom, left)
  plot.margin = margin(20, 40, 20, 40),
  # Use a light grey color for the background of both the plot and the panel
  plot.background = element_rect(fill = "white", color = "grey98"),
  panel.background = element_rect(fill = "white", color = "grey98"),
  # Customize title appearence
  plot.title = element_text(
    color = "grey10", 
    size = 28, 
    face = "bold",
    hjust = 0.5,
    margin = margin(t = 15)
  ),
  # Customize subtitle appearence
  plot.subtitle = element_markdown(
    color = "grey30", 
    size = 16,
    lineheight = 1.35,
    margin = margin(t = 15, b = 40)
  ),
  # Title and caption are going to be aligned
  plot.title.position = "plot",
  plot.caption.position = "plot",
  plot.caption = element_text(
    size = 16,
    lineheight = 1.2, 
    hjust = 0,
    margin = margin(t = 40) # Large margin on the top of the caption.
  ),
  # Remove legend
  legend.position = "none"
)


plt <- ggplot(
  # The ggplot object has associated the data for the highlighted countries
  df_mac_indexed_2008 %>% filter(group != "other"), 
  aes(year, price_rel, group = iso_a3)
) + 
  # Geometric annotations that play the role of grid lines
  geom_vline(
    xintercept = seq(2010, 2019, by = 3),
    color = "grey91", 
    size = .6
  ) +
  geom_segment(
    data = tibble(y = seq(0, 200000, by = 50000), x1 = 2010, x2 = 2019),
    aes(x = x1, xend = x2, y = y, yend = y),
    inherit.aes = FALSE,
    color = "grey91",
    size = .6
  ) +
  geom_segment(
    data = tibble(y = 0, x1 = 2010, x2 = 2019),
    aes(x = x1, xend = x2, y = y, yend = y),
    inherit.aes = FALSE,
    color = "grey60",
    size = .8
  ) +
  ## Lines for the non-highlighted countries
  geom_line(
    data = df_mac_indexed_2008 %>% filter(group == "other"),
    color = "grey75",
    size = .6,
    alpha = .5
  ) +
  ## Lines for the highlighted countries.
  # It's important to put them after the grey lines
  # so the colored ones are on top
  geom_line(
    aes(color = group),
    size = .9
  )
plt

plt <- plt + 
  geom_text_repel(
    aes(color = group, label = name_lab),
    family = "Lato",
    fontface = "bold",
    size = 8,
    direction = "y",
    xlim = c(2021, NA),
    hjust = 0,
    segment.size = .7,
    segment.alpha = .5,
    segment.linetype = "dotted",
    box.padding = .4,
    segment.curvature = -0.1,
    segment.ncp = 3,
    segment.angle = 20
  ) +
  ## coordinate system + scales
  coord_cartesian(
    clip = "off",
    ylim = c(0, 200000)
  ) +
  scale_x_continuous(
    expand = c(0, 0),
    limits = c(2010, 2021), 
    breaks = seq(2010, 2021, by = 3)
  ) +
  scale_y_continuous(
    expand = c(0, 0),
    breaks = seq(0, 200000, by = 50000)
  )
plt

###
#plt <- plt + 
#  scale_color_manual(
#    values = c(rcartocolor::carto_pal(n = n, name = "Bold")[1:n-1], "grey50")
#  ) +
#  labs(
#    title = "GDP per person employed",
#    subtitle = "",
#    caption = "Source: WB. PPP, constant 2017 international USD. Graph shows LAC and EAP countries."
#  )
#plt

