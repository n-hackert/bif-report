#!/usr/bin/env Rscript
library(tidyverse)
library(ggplot2)
library(cowplot)
library(ggmosaic)

# TODO: fix Air's inability to resolve imports that are made in source calls
source(here::here("R", "fig_gen", "utils.R"))

# ROW 1
# FIG 1A | PCA | differential splicing global stats

# read input data
pca_meta_all_ratios <- read_csv(
  here::here(
    "figures",
    "main",
    "source_data",
    "fig1",
    "leafcutter_pca_ratios_meta.csv"
  ),
  col_types = cols(time = col_factor(), .default = col_guess())
)
importance_all_ratios <- read_csv(
  here::here(
    "figures",
    "main",
    "source_data",
    "fig1",
    "leafcutter_pca_ratios_importance.csv"
  )
)

# generate panel
plt_pca_leafcutter <- ggplot(
  pca_meta_all_ratios,
  aes(x = PC1, y = PC2, color = time)
) +
  geom_point() +
  scale_color_manual(
    name = "Time after\nactivation (h)",
    values = color_scale_time,
    breaks = names(color_scale_time)
  ) +
  coord_fixed() +
  xlab(paste0("PC1: ", importance_all_ratios[1, 2], "% of variance")) +
  ylab(paste0("PC2: ", importance_all_ratios[2, 2], "% of variance")) +
  theme_panel()


# FIG 1B | BOX/JITTER | LEAFCUTTER SIGNIFICANCE COUNTS

# read input data
lc_ds_seq_counts <- read_csv(
  here::here(
    "figures",
    "main",
    "source_data",
    "fig1",
    "leafcutter_seq_ds_signif_counts.csv"
  )
)

# generate panel
plt_sig_ev_gene <- ggplot(
  lc_ds_seq_counts,
  aes(x = type, y = n_sig, fill = type)
) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.25) +
  # FDR <5%
  ylab("Number significant ") +
  scale_x_discrete(
    name = "",
    breaks = c("n_clust_sig", "n_genes_sig"),
    labels = c("Clusters", "Genes")
  ) +
  scale_fill_manual(
    name = "",
    breaks = c("n_clust_sig", "n_genes_sig"),
    values = c("dodgerblue1", "dodgerblue1")
  ) +
  theme_panel()

row1 <- plot_grid(
  plt_pca_leafcutter,
  plt_sig_ev_gene,
  ncol = 2,
  rel_widths = c(3, 1),
  align = "hv",
  axis = "tb"
)

# ROW 2/3
# FIG 1C | DS EXAMPLE | LINK AND LINE PLOTS

# svg version of images has been edited with inkscape
# to make time annotations nicer (alignment and "<n>h" addition)
plt_ds_8v4_il10 <- ggdraw() +
  draw_image(
    magick::image_read(
      here::here(
        "figures",
        "main",
        "static",
        "fig1",
        "8_vs_4_IL10_clu_35198_-.svg"
      ),
      density = 600
    )
  )

example_cluster_sig_stats <- read_csv(
  here::here(
    "figures",
    "main",
    "source_data",
    "fig1",
    "example_cluster_sig_stats.csv"
  ),
  col_types = cols(
    comp = col_factor(levels = levels(seq_comparisons_times)),
    .default = col_guess()
  )
)

plt_ds_tc_il10 <- example_cluster_sig_stats |>
  filter(genes == "IL10") |>
  mutate(
    comp = comp_target_mappings[comp],
    intron_lv = intron |>
      as_factor() |>
      fct_recode(
        a = "chr1:206769894:206770907:clu_35198_-",
        b = "chr1:206769894:206770399:clu_35198_-",
        c = "chr1:206769894:206770082:clu_35198_-"
      ) |>
      fct_relevel(c("a", "b", "c"))
  ) |>
  ggplot(aes(x = comp, y = deltapsi)) +
  geom_point() +
  geom_line(aes(group = intron)) +
  facet_wrap(~intron_lv, ncol = 1, strip.position = "right") +
  xlab("Time (h)") +
  ylab(expression(Delta ~ "PSI")) +
  theme_panel()

plt_ds_8v4_lef1 <- ggdraw() +
  draw_image(
    magick::image_read(
      here::here(
        "figures",
        "main",
        "static",
        "fig1",
        "8_vs_4_LEF1_clu_44435_-.svg"
      ),
      density = 600
    )
  )

plt_ds_tc_lef1 <- example_cluster_sig_stats |>
  filter(genes == "LEF1") |>
  mutate(
    comp = comp_target_mappings[comp],
    intron_lv = intron |>
      as_factor() |>
      fct_recode(
        a = "chr4:108079614:108083356:clu_44435_-",
        b = "chr4:108079614:108081586:clu_44435_-",
        c = "chr4:108081669:108083356:clu_44435_-"
      ) |>
      fct_relevel(c("a", "b", "c"))
  ) |>
  ggplot(aes(x = comp, y = deltapsi)) +
  geom_point() +
  geom_line(aes(group = intron)) +
  xlab("Time (h)") +
  ylab(expression(Delta ~ "PSI")) +
  facet_wrap(~intron_lv, ncol = 1, strip.position = "right") +
  theme_panel()

# ROW 4
# FIG 1C | MOSAIC | EVENT TYPE BY TIME

# read data, rMATS DS global stats
rmats_global_stats <- read_csv(
  here::here(
    "figures",
    "main",
    "source_data",
    "fig1",
    "rmats_global_ds_stats.csv"
  )
)

# data has to be transformed to work with mosaic plots
event_mosaic_df <- rmats_global_stats |>
  dplyr::select(
    comp,
    event_type,
    sig_events_jc
  ) |>
  uncount(sig_events_jc) |>
  mutate(
    # comp = factor(
    #   x = case_when(
    #     comp == "2_vs_0" ~ "0 vs 2",
    #     comp == "4_vs_2" ~ "\n2 vs 4",
    #     comp == "8_vs_4" ~ "4 vs 8",
    #     comp == "12_vs_8" ~ "\n8 vs 12",
    #     comp == "24_vs_12" ~ "12 vs 24",
    #     comp == "48_vs_24" ~ "\n24 vs 48",
    #     comp == "72_vs_48" ~ "48 vs 72",
    #     T ~ "err"
    #   ),
    #   levels = c(
    #     "0 vs 2",
    #     "\n2 vs 4",
    #     "4 vs 8",
    #     "\n8 vs 12",
    #     "12 vs 24",
    #     "\n24 vs 48",
    #     "48 vs 72"
    #   )
    # ),
    comp = comp_target_mappings[comp],
    event_type = factor(
      x = event_type,
      levels = c(
        "SE",
        "RI",
        "MXE",
        "A5SS",
        "A3SS"
      )
    )
  )

plt_rmats_ds_mosaic <- ggplot(event_mosaic_df) +
  geom_mosaic(
    aes(x = product(event_type, comp), fill = event_type),
    offset = 0.005,
    alpha = 1
  ) +
  scale_fill_manual(
    name = "Event type",
    values = color_scale_rmats_events
  ) +
  theme_panel() +
  scale_y_continuous() +
  xlab("Time (h)") +
  ylab("Relative contri-\nbution of type")


# FIG 1D | BAR | INTRON RETENTION EVENTS OVER TIME

# read data

rmats_ri_jc_stats_summary <- read_csv(
  here::here(
    "figures",
    "main",
    "source_data",
    "fig1",
    "rmats_ds_ri_jc_stats_summary.csv"
  ),
  col_types = cols(comp_target = col_factor())
)

plt_rmats_ds_ri <- ggplot(
  rmats_ri_jc_stats_summary,
  aes(
    x = comp_target,
    y = count,
    fill = comp_target,
    alpha = as.character(sign(count))
  )
) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_hline(yintercept = 0) +
  scale_alpha_manual(
    breaks = c("1", "-1"),
    values = c(1, 0.6)
  ) +
  scale_fill_manual(
    breaks = names(color_scale_time),
    values = color_scale_time
  ) +
  # FDR < 10%
  ylab("Intron count") +
  # hehehe
  scale_y_continuous(
    breaks = c(-2000, -1500, -1000, -500, 0, 500, 1000, 1500, 2000),
    labels = c(2000, 1500, 1000, 500, 0, 500, 1000, 1500, 2000),
    limits = c(-2000, 2000),
    sec.axis = sec_axis(
      trans = ~.,
      name = expression("  " %<-% "Retain        Exclude" %->% ""),
      labels = NULL,
      breaks = NULL
    )
  ) +
  # scale_x_discrete(
  #   breaks = names(target_comp_mappings_nl_alt),
  #   labels = target_comp_mappings_nl_alt
  # ) +
  xlab("Time (h)") +
  theme_panel()

row2 <- plot_grid(
  plt_rmats_ds_mosaic,
  plt_rmats_ds_ri,
  ncol = 2,
  rel_widths = c(1, 1)
)

# ASSEMBLY

# we love gridding grids
# fig1 <- plot_grid(
#   ncol = 1,
#   rel_heights = c(3, 2),
#   labels = c("", "e"),
#   plotlist = list(
#     # first two rows
#     plot_grid(
#       ncol = 2,
#       byrow = T,
#       labels = c("a", "c", "b", "d"),
#       align = c("hv"),
#       axis = c("lrtb"),
#       rel_widths = c(2, 3, 2, 3),
#       plotlist = list(
#         plt_pca_leafcutter + theme(legend.position = "none"),
#         plt_rmats_ds_mosaic + theme(legend.position = "none"),
#         plt_sig_ev_gene + theme(legend.position = "none"),
#         plt_rmats_ds_ri + theme(legend.position = "none")
#       )
#     ),

#     # last row with example plots and legends in l/r col
#     plot_grid(
#       ncol = 2,
#       byrow = F,
#       rel_widths = c(2, 1),
#       plotlist = list(
#         # left col
#         # example plots
#         # has 2 stacked example plots
#         plot_grid(
#           plt_ds_8v4_il10,
#           plt_ds_8v4_lef1,
#           ncol = 1
#         ),

#         # legend arrangement
#         # has 2 legends next to each other
#         # setting guides here, because it matters in the context the figure arrangement with separate legend
#         plot_grid(
#           ncol = 1,
#           plotlist = list(
#             get_legend(
#               plt_pca_leafcutter +
#                 guides(
#                   color = guide_legend(
#                     ncol = 3,
#                     nrow = 3
#                   )
#                 )
#             ),
#             get_legend(
#               plt_rmats_ds_mosaic +
#                 guides(
#                   fill = guide_legend(
#                     ncol = 2,
#                     nrow = 3
#                   )
#                 )
#             )
#           )
#         )
#       )
#     )
#   )
# )

fig1 <- plot_grid(
  ncol = 1,
  nrow = 5,
  labels = c("", "c", "d", "", ""),
  label_size = 7,
  rel_heights = c(1, 1, 1, 1, 0.2),
  align = "v",
  axis = "lr",
  plotlist = list(
    plot_grid(
      ncol = 2,
      nrow = 1,
      labels = c("a", "b"),
      label_size = 7,
      rel_widths = c(2, 1),
      align = "h",
      axis = "tb",
      plotlist = list(
        plt_pca_leafcutter + guides(color = guide_legend(ncol = 2)),
        plt_sig_ev_gene + theme(legend.position = "none")
      )
    ),
    plot_grid(
      ncol = 2,
      nrow = 1,
      labels = c("", ""),
      rel_widths = c(2, 1),
      plotlist = list(
        plt_ds_8v4_il10,
        # playing around with margins to make it align more nicely with leafviz svg
        plt_ds_tc_il10 + theme(plot.margin = margin(8, 1.5, 6, 1.5, "mm"))
      )
    ),
    plot_grid(
      ncol = 2,
      nrow = 1,
      labels = c("", ""),
      rel_widths = c(2, 1),
      plotlist = list(
        plt_ds_8v4_lef1,
        # playing around with margins to make it align more nicely with leafviz svg
        plt_ds_tc_lef1 + theme(plot.margin = margin(8, 1.5, 6, 1.5, "mm"))
      )
    ),
    plot_grid(
      ncol = 2,
      nrow = 1,
      labels = c("e", "f"),
      label_size = 7,
      rel_widths = c(1, 1),
      align = "h",
      axis = "tb",
      plotlist = list(
        plt_rmats_ds_mosaic + theme(legend.position = "none"),
        plt_rmats_ds_ri + theme(legend.position = "none")
      )
    ),
    get_legend(
      plt_rmats_ds_mosaic + theme(legend.direction = "horizontal")
    )
  )
)

# NOTE: consider changing approach to base height/width and ncol
save_plot(
  here::here(
    "figures",
    "main",
    "Figure1.svg"
  ),
  fig1,
  bg = "white",
  # DIMS
  # base_width = 6.75,
  # base_height = 9.375

  # from nature style guide
  # 2 col figure max width: 180 mm
  base_width = 180,
  # from nature style guide legend length vs. height:
  # <300 words ~185 mm
  # <150 words ~210 mm
  # <50 words ~225 mm
  base_height = 210,
  units = "mm",
  ncol = 1,
  nrow = 1
)
