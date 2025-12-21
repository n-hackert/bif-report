library(RColorBrewer)
library(circlize)
library(ggplot2)
library(cowplot)

# double check if needed
library(grid)

# TODO: fill spaces and delete
panel_placeholder <- function(title) {
  placeholder <- ggdraw() +
    draw_grob(
      grobTree(
        rectGrob(
          width = unit(0.9, "npc"),
          height = unit(0.9, "npc"),
          gp = gpar(fill = "grey95", col = "black", lwd = 1)
        ),
        textGrob(
          title,
          gp = gpar(fontface = "bold", fontsize = 12)
        )
      )
    )
}


# set some reasonable defaults for plots
# currently mostly text sizes

theme_panel <- function(
  # 7pt: max size from nature style guide
  text_base_size = 7,
  text_rel = 1,
  title_rel = 1,
  plot_title_rel = 1,
  caption_rel = 1
) {
  theme_bw(
    # text base size
    base_size = text_base_size
  ) +
    theme(
      # remove background grid
      panel.grid = element_blank(),

      # remove legend
      # legend.position = "none",

      # putting legend right to make cowplot get_legend work by default
      legend.position = "right",

      # set text sizes
      # titles
      plot.title = element_text(size = rel(plot_title_rel)),
      plot.subtitle = element_text(size = rel(title_rel)),
      plot.caption = element_text(size = rel(caption_rel)),
      plot.tag = element_text(size = rel(title_rel)),

      axis.title = element_text(size = rel(title_rel)),
      legend.title = element_text(size = rel(title_rel)),

      # facet titles
      strip.text = element_text(size = rel(title_rel)),

      # normal text
      axis.text = element_text(size = rel(text_rel)),
      legend.text = element_text(size = rel(text_rel)),
    )
}


ref_color <- "#00509d"
alt_color <- "#fdc500"
# some useful factors
seq_comparisons_times <- factor(
  x = c(
    "2_vs_0",
    "4_vs_2",
    "8_vs_4",
    "12_vs_8",
    "24_vs_12",
    "48_vs_24",
    "72_vs_48"
  ),
  levels = c(
    "2_vs_0",
    "4_vs_2",
    "8_vs_4",
    "12_vs_8",
    "24_vs_12",
    "48_vs_24",
    "72_vs_48"
  )
)

comp_target_mappings <- c(
  `2_vs_0` = "2",
  `4_vs_2` = "4",
  `8_vs_4` = "8",
  `12_vs_8` = "12",
  `24_vs_12` = "24",
  `48_vs_24` = "48",
  `72_vs_48` = "72"
) |>
  fct()

target_comp_mappings_nl_alt <- c(
  `2` = "0 vs 2",
  `4` = "\n2 vs 4",
  `8` = "4 vs 8",
  `12` = "\n8 vs 12",
  `24` = "12 vs 24",
  `48` = "\n24 vs 48",
  `72` = "48 vs 72"
)

target_comp_mappings <- c(
  `2` = "0 vs 2",
  `4` = "2 vs 4",
  `8` = "4 vs 8",
  `12` = "8 vs 12",
  `24` = "12 vs 24",
  `48` = "24 vs 48",
  `72` = "48 vs 72"
)

# some useful scales
color_scale_time <- c(
  `0` = "#ffbe0b",
  `2` = "#fd8a09",
  `4` = "#fb5607",
  `8` = "#ff006e",
  `12` = "#c11cad",
  `24` = "#8338ec",
  `48` = "#5f5ff6",
  `72` = "#3a86ff"
)

color_scale_seq_comparisons <- c(
  `2_vs_0` = "#fd8a09",
  `4_vs_2` = "#fb5607",
  `8_vs_4` = "#ff006e",
  `12_vs_8` = "#c11cad",
  `24_vs_12` = "#8338ec",
  `48_vs_24` = "#5f5ff6",
  `72_vs_48` = "#3a86ff"
)

color_scale_rmats_events <- c(
  A3SS = "#ef476f",
  A5SS = "#ffd166",
  MXE = "#06d6a0",
  RI = "#118ab2",
  SE = "#073b4c"
)

generate_rd_bu_colfun_sym <- function(min = -1, max = 1) {
  max_abs <- max(abs(c(min, max)))
  generate_rd_bu_colfun(-max_abs, max_abs)
}

generate_rd_bu_colfun <- function(min = -1, max = 1) {
  size = max - min
  ramp <- colorRampPalette(rev(brewer.pal(n = 11, name = "RdBu")))(25)
  colfun <- colorRamp2(seq(min, max, size / 24), ramp)

  return(colfun)
}

generate_or_rd_colfun <- function(min = 0, max = 1) {
  size = max - min
  ramp <- colorRampPalette(rev(brewer.pal(9, "OrRd")[4:9]))(25)
  colfun <- colorRamp2(seq(min, max, size / 24), ramp)

  return(colfun)
}
