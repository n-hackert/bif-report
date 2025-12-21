#!/usr/bin/env Rscript

library(tidyverse)
library(cowplot)
library(ggbeeswarm)

source(
  here::here(
    "R",
    "fig_gen",
    "utils.R"
  )
)

# read in explanatory panel
fig3a <- ggdraw() +
  draw_image(
    magick::image_read(
      here::here(
        "figures",
        "main",
        "static",
        "fig3",
        "Figure3a.svg"
      ),
      density = 600
    )
  ) +
  theme(plot.margin = unit(c(0, 10, 0, 10), "mm"))

# QC: events detected
# read detected events stats
sj_n_qc_passing_events_per_contig <- read_csv(
  here::here(
    "figures",
    "main",
    "source_data",
    "fig3",
    "sj_n_qc_passing_events_per_contig.csv"
  )
) |>
  # make factors behave
  mutate(
    SJ_chrom = fct_reorder(SJ_chrom, as.numeric(str_remove(SJ_chrom, "^chr"))),
    SJ_chrom_num = fct(
      x = str_remove(SJ_chrom, "^chr"),
      levels = str_remove(levels(SJ_chrom), "^chr")
    )
  )

sj_n_qc_passing_events_per_contig_plt <- sj_n_qc_passing_events_per_contig |>
  ggplot(
    aes(
      x = SJ_chrom_num,
      y = n
    )
  ) +
  geom_boxplot(outlier.shape = NA, fill = "dodgerblue2") +
  geom_quasirandom(groupOnX = T, size = 0.01) +
  theme_panel() +
  xlab("Chromosome") +
  ylab("N QC-passing events")

# QC: event similarity across samples
sj_qc_passing_events_similarity_jaccard <- read_csv(
  here::here(
    "figures",
    "main",
    "source_data",
    "fig3",
    "sj_qc_passing_events_similarity_jaccard.csv"
  )
)

sj_qc_passing_events_similarity_jaccard_plt <- sj_qc_passing_events_similarity_jaccard |>
  ggplot(aes(x = ind_si == ind_so, y = jaccard)) +
  geom_violin(
    draw_quantiles = c(0.25, 0.5, 0.75),
    fill = "dodgerblue1"
  ) +
  theme_panel() +
  ylab("Shared events between samples (Jaccard)") +
  xlab("Samples of same individual") +
  scale_x_discrete(
    breaks = c(F, T),
    labels = c("No", "Yes")
  )

fig3 <- plot_grid(
  ncol = 1,
  nrow = 2,
  rel_heights = c(1, 1),
  labels = c("a", "", "d"),
  label_size = 7,
  plotlist = list(
    fig3a,
    plot_grid(
      ncol = 2,
      nrow = 1,
      rel_widths = c(3, 1),
      labels = c("b", "c"),
      label_size = 7,
      plotlist = list(
        sj_n_qc_passing_events_per_contig_plt,
        sj_qc_passing_events_similarity_jaccard_plt
      )
    )
  )
)

# NOTE: consider changing approach to base height/width and ncol
save_plot(
  here::here(
    "figures",
    "main",
    "Figure3.svg"
  ),
  fig3,
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
  # base_height = 185,
  base_height = 120,
  units = "mm",
  ncol = 1,
  nrow = 1
)
