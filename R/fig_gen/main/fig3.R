#!/usr/bin/env Rscript

library(tidyverse)
library(cowplot)
library(ggbeeswarm)
library(ggrepel)

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

# manhattan plot panel
# read data
static_ASJU_logreg_manhattan_data <- read_csv(
  here::here(
    "figures",
    "main",
    "source_data",
    "fig3",
    "static_ASJU_logreg_manhattan_data.csv"
  ),
  col_types = cols(
    label = col_character(),
    .default = col_guess()
  )
)

# read scale helper
manhattan_chr_offset <- read_csv(
  here::here(
    "figures",
    "main",
    "source_data",
    "fig3",
    "static_ASJU_manhattan_chr_offset.csv"
  )
)

static_ASJU_manhattan_plt <- ggplot(
  static_ASJU_logreg_manhattan_data,
  aes(x = SJ_snp_pos_manh, y = f_pval_fdr, color = chr_col, label = label)
) +
  geom_point(size = 0.75) +
  geom_label_repel(
    nudge_y = 10,
    color = "black",
    label.padding = 0.1,
    # direction = "y",
    direction = "both",
    size = 2,
    segment.size = 0.2
  ) +
  theme_bw() +
  theme(panel.grid = element_blank()) +
  scale_x_continuous(
    breaks = manhattan_chr_offset$center,
    labels = manhattan_chr_offset$SJ_chr
  ) +
  scale_y_continuous(
    name = "FDR",
    breaks = c(0.1, 0.001, 1e-10, 1e-20, 1e-30),
    labels = c(0.1, 0.001, 1e-10, 1e-20, 1e-30),
    limits = c(1, 1e-30),
    trans = neg_log10_trans()
  ) +
  scale_color_manual(
    breaks = c("even", "odd"),
    values = c("dodgerblue1", "dodgerblue4")
  ) +
  theme_panel() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
    legend.position = "none"
  ) +
  xlab("Event SNP position")


# enrichment // currently irrelevant
# static_ASJU_enrichment_res <- read_csv(
#   here::here(
#     "figures",
#     "main",
#     "source_data",
#     "fig3",
#     "static_ASJU_enrichment_res.csv"
#   )
# )

# enrichment_plt <- static_ASJU_enrichment_res |>
#   filter(
#     observed_overlap_fdr10 > 3,
#   ) |>
#   ggplot(
#     aes(
#       x = log2(fold_enrichment_fdr10),
#       y = fct_reorder(paste(trait, type, sep = ", "), fold_enrichment_fdr10),
#       fill = -log10(padj_enrichment_fdr10),
#       color = padj_enrichment_fdr10 < 0.01,
#       size = observed_overlap_fdr10
#     )
#   ) +
#   geom_point(shape = 21, stroke = 1) +
#   xlab("log2-fold enrichment") +
#   ylab("Trait, Gene set type") +
#   theme_panel() +
#   theme(
#     legend.direction = "horizontal",
#     legend.box = "vertical",
#     legend.title.position = "top",
#     legend.position = "bottom",
#     legend.key.size = unit(3, "mm")
#   ) +
#   scale_fill_distiller(palette = "OrRd", direction = 1) +
#   scale_color_manual(
#     breaks = c(
#       "TRUE",
#       "FALSE"
#     ),
#     values = c(
#       "black",
#       "grey80"
#     )
#   ) +
#   facet_grid(rows = vars(fct_rev(group)), scales = "free_y", space = "free_y")

# fig 3 assembly
fig3 <- plot_grid(
  ncol = 1,
  nrow = 2,
  rel_heights = c(1, 2),
  labels = c("a", ""),
  label_size = 7,
  plotlist = list(
    fig3a,
    # plot_grid(
    #   ncol = 2,
    #   nrow = 1,
    #   rel_widths = c(3, 2),
    #   plotlist = list(
    plot_grid(
      ncol = 1,
      nrow = 2,
      rel_widths = c(3, 1),
      labels = c("b", "c"),
      label_size = 7,
      align = "v",
      plotlist = list(
        sj_n_qc_passing_events_per_contig_plt,
        static_ASJU_manhattan_plt
      )
    ) #,
    #     enrichment_plt
    #   )
    # )
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
  base_height = 185,
  # base_height = 120,
  units = "mm",
  ncol = 1,
  nrow = 1
)
