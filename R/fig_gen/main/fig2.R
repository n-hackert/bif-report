#!/usr/bin/env Rscript

library(tidyverse)
library(ComplexHeatmap)

source(
  here::here(
    "R",
    "fig_gen",
    "utils.R"
  )
)

# ngenes panel
ngenes_expr_stats <- read_csv(
  here::here(
    "figures",
    "supplementary",
    "source_data",
    "ngenes_expr_stats.csv"
  ),
  col_types = cols(
    time = col_factor(
      levels = names(color_scale_time)
    ),
    .default = col_guess()
  )
)

ngene_plt <- ngenes_expr_stats |>
  filter(threshold == 1) |>
  ggplot(
    aes(x = time, y = ngenes, fill = time)
  ) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(size = 0.5) +
  scale_fill_manual(
    breaks = names(color_scale_time),
    values = color_scale_time,
    name = "Time (h)"
  ) +
  xlab("Time after activation (h)") +
  ylab("Number of genes expressed above threshold") +
  theme_panel()

# gini panel
gene_gini_coefs <- read_csv(
  here::here(
    "figures",
    "main",
    "source_data",
    "fig2",
    "gene_gini_coefs.csv"
  ),
  col_types = cols(
    time = col_factor(
      levels = names(color_scale_time)
    ),
    .default = col_guess()
  )
)

gene_gini_plt <- gene_gini_coefs |>
  mutate(
    gini_bins = cut_width(gene_gini, 0.1, boundary = 0)
  ) |>
  group_by(sample, gini_bins) |>
  summarize(
    ngenes = n(),
    time = unique(time),
    individual = unique(individual)
  ) |>
  ggplot(aes(x = gini_bins, fill = time, y = ngenes)) +
  scale_fill_manual(
    name = "Time (h)",
    values = color_scale_time,
    breaks = names(color_scale_time)
  ) +
  xlab("Gini index") +
  ylab("Number of genes") +
  geom_boxplot(outlier.size = 0.1, fatten = 0.75) +
  theme_panel()

# we're doing funny heatmap things now
delta_ntx_summary <- read_csv(
  here::here(
    "figures",
    "main",
    "source_data",
    "fig2",
    "delta_ntx_expr_summary_clust.csv"
  )
)

# ordered levels by decreasing average ntx
delta_ntx_clu_levels <- delta_ntx_summary |>
  group_by(cluster) |>
  summarize(avg_dntx = mean(median_delta_ntx)) |>
  ungroup() |>
  arrange(desc(avg_dntx)) |>
  pull(cluster) |>
  as.character()

# View(delta_ntx_mat)
delta_ntx_mat <- delta_ntx_summary |>
  pivot_wider(
    id_cols = gene_id,
    names_from = time,
    values_from = median_delta_ntx
  ) |>
  column_to_rownames("gene_id") |>
  as.matrix()

delta_ntx_meta <- delta_ntx_summary |>
  dplyr::select(
    -c(
      time,
      median_ntx,
      median_delta_ntx
    )
  ) |>
  distinct() |>
  mutate(
    cluster = fct(as.character(cluster), levels = delta_ntx_clu_levels),
    # the genes we would like to highlight
    # show imd genes with strongest evidence
    highlight_gene = replace_na(imd_closest_gene & imd_coloc & imd_l2g, F)
  )

stopifnot(
  all.equal(
    rownames(delta_ntx_mat),
    delta_ntx_meta$gene_id
  )
)

gen_max_col_val <- max(
  c(
    abs(quantile(delta_ntx_mat, 0.005)),
    abs(quantile(delta_ntx_mat, 0.995))
  )
)

# min_col_val <- quantile(delta_ntx_mat, 0.001)
# max_col_val <- quantile(delta_ntx_mat, 0.999)

# TODO: check if sym is needed or if we should do this differently
# col_fun = generate_rd_bu_colfun_sym(min_col_val, max_col_val)
col_fun = generate_rd_bu_colfun(-gen_max_col_val, gen_max_col_val)

anno_right <- rowAnnotation(
  gene_symbols = anno_mark(
    at = which(delta_ntx_meta$highlight_gene),
    labels = delta_ntx_meta$gene_symbol[delta_ntx_meta$highlight_gene],
    labels_gp = gpar(
      fontsize = 7
    )
  )
)

delta_ntx_hm <- Heatmap(
  delta_ntx_mat,

  # cols
  cluster_columns = F,
  column_title = "Time (h)",
  column_title_gp = gpar(fontsize = 7),
  column_names_gp = gpar(fontsize = 7),
  column_title_side = "bottom",
  column_names_rot = 0,

  # rows
  # cluster_rows = cluster_within_group(delta_ntx_mat, delta_ntx_meta$cluster),
  row_split = delta_ntx_meta$cluster,
  show_row_dend = F,
  show_row_names = F,
  row_title = "Gene clusters (k-medoids)",
  row_title_gp = gpar(fontsize = 7),
  clustering_distance_rows = "manhattan",
  clustering_method_rows = "average",
  cluster_row_slices = F,

  # annotations
  right_annotation = anno_right,

  # other
  col = col_fun,
  border = T,

  # legend
  heatmap_legend_param = list(
    # title = expression(Delta*"iso"),
    title = "N more or fewer\nisoforms than 0h",
    title_gp = gpar(fontsize = 7, fontface = "bold"),
    labels_gp = gpar(fontsize = 7),
    # legend_height = unit(6, "cm"),
    border = T,
    at = round(seq(-gen_max_col_val, gen_max_col_val, length.out = 11))
  )
)

# half page height
# for full dims see save_plot call below
hm_height <- convertHeight(unit(105, "mm"), "in", valueOnly = T)
hm_width <- convertHeight(unit(180, "npc"), "in", valueOnly = T)
delta_ntx_hm_plt <- grid.grabExpr(
  draw(delta_ntx_hm),
  height = hm_height,
  width = hm_width
)

# TODO: consider example plots
# - pick a gene with high / low Gini-expression correlation
# - show how expression and Gini / ntx change over time

fig2 <- plot_grid(
  nrow = 3,
  ncol = 1,
  labels = c("", "", "c"),
  label_size = 7,
  rel_heights = c(9, 1, 10),
  align = c("v"),
  axis = c("lr"),
  plotlist = list(
    plot_grid(
      ncol = 2,
      nrow = 1,
      labels = c("a", "b"),
      label_size = 7,
      rel_widths = c(1, 3),
      align = c("hv"),
      axis = c("tblr"),
      byrow = T,
      plotlist = list(
        ngene_plt + theme(legend.position = "none"),
        gene_gini_plt + theme(legend.position = "none")
      )
    ),
    get_legend(
      ngene_plt +
        theme(legend.direction = "horizontal") +
        guides(
          fill = guide_legend(
            nrow = 1
          )
        )
    ),
    # panel_placeholder("Heatmap")
    delta_ntx_hm_plt
  )
)

# NOTE: consider changing approach to base height/width and ncol
save_plot(
  here::here(
    "figures",
    "main",
    "Figure2.svg"
  ),
  fig2,
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
