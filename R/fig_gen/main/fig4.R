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

# dynamic junction-read allele-specific expression manhattan
jrsae_manhattan_data <- read_csv(
  here::here(
    "figures",
    "main",
    "source_data",
    "fig4",
    "jrsae_manhattan_data.csv"
  )
)

jrsae_manhattan_chr_offset <- read_csv(
  here::here(
    "figures",
    "main",
    "source_data",
    "fig4",
    "jrsae_manhattan_chr_offset.csv"
  )
)

jrsae_manhattan_plt <- ggplot(
  jrsae_manhattan_data,
  aes(x = SJ_snp_pos_manh, y = f_padj, color = chr_col, label = label)
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
  scale_x_continuous(
    breaks = jrsae_manhattan_chr_offset$center,
    labels = jrsae_manhattan_chr_offset$SJ_chr
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


#examples
jrsae_example_data <- read_csv(
  here::here(
    "figures",
    "main",
    "source_data",
    "fig4",
    "jrsae_example_data.csv"
  ),
  col_types = cols(
    time = readr::col_factor(
      levels = names(color_scale_time)
    ),
    .default = col_guess()
  )
)


example_plts <- jrsae_example_data |>
  # filter(gene_name %in% c("RBM6", "STING1")) |>
  nest(
    data = everything(),
    .by = c(individual, SJ_id)
  ) |>
  pull(data) |>
  map(\(df) {
    labels <- ggdraw() +
      draw_label(
        unique(df$gene_name),
        size = 7,
        fontface = "bold",
        x = 0.15,
        y = 0.8,
        hjust = 0
      ) +
      draw_label(
        str_remove(unique(df$S_snp_id), ":.+$"),
        size = 6,
        fontface = "plain",
        x = 0.15,
        y = 0.5,
        hjust = 0
      ) +
      draw_label(
        unique(df$J_junc_id),
        size = 6,
        fontface = "plain",
        x = 0.15,
        y = 0.2,
        hjust = 0
      )

    ref_frac_plt <- df |>
      pivot_longer(
        cols = c(SJ_ref_frac, non_SJ_ref_frac),
        names_to = c("group"),
        values_to = c("ref_frac")
      ) |>
      ggplot(aes(x = time_scaled, y = ref_frac, color = group)) +
      geom_point() +
      geom_line() +
      scale_x_continuous(
        breaks = time_scaled_mappings$time_scaled,
        labels = time_scaled_mappings$time
      ) +
      scale_color_manual(
        name = "Group",
        breaks = c("SJ_ref_frac", "non_SJ_ref_frac"),
        values = c("#023047ff", "#fb8500ff"),
        labels = c("Part of event", "Not part of event")
      ) +
      theme_panel() +
      theme(legend.position = "none") +
      xlab("Time") +
      ylab("Reference fraction")

    counts_plt <- df |>
      pivot_longer(
        cols = c(SJ_count_ref, SJ_count_alt, S_count_ref, S_count_alt),
        names_to = c("group", "allele"),
        names_sep = "_count_",
        values_to = c("count")
      ) |>
      ggplot(aes(x = time, y = count, fill = allele)) +
      geom_bar(stat = "identity", position = "dodge2") +
      # TODO: properly set ref and alt color scales for entire project
      scale_fill_manual(
        name = "Allele",
        breaks = c("ref", "alt"),
        values = c("#219ebcff", "#ffb703ff"),
        labels = c("Reference", "Alternative")
      ) +
      theme_panel() +
      facet_wrap(
        ~group,
        nrow = 2,
        scales = "free_y",
        labeller = as_labeller(c(
          "S" = "Total counts at SNP",
          "SJ" = "Event counts"
        ))
      ) +
      theme(legend.position = "none") +
      xlab("Time") +
      ylab("Counts")

    list(
      labels = labels,
      ref_frac_plt = ref_frac_plt,
      counts_plt = counts_plt
    )
  })

# fig 4 assembly

fig4 <- plot_grid(
  ncol = 1,
  nrow = 3,
  rel_heights = c(5, 11, 1),
  labels = c("a", "", ""),
  label_size = 7,
  plotlist = list(
    jrsae_manhattan_plt,
    plot_grid(
      ncol = 3,
      nrow = 3,
      rel_heights = c(1, 4, 8),
      rel_widths = c(1, 1),
      # seems to be a bug with byrow
      labels = c("b", "c", "d"),
      # labels = c("b", "", "", "c", "", "", "d", "", ""),
      label_size = 7,
      plotlist = flatten(example_plts),
      byrow = F
    ),
    plot_grid(
      ncol = 2,
      rel_widths = c(1, 1),
      plotlist = list(
        (pluck(example_plts, 1, "ref_frac_plt") +
          theme(legend.position = "right", legend.direction = "horizontal")) |>
          get_plot_component("guide-box", return_all = T) |>
          pluck(1),
        (pluck(example_plts, 1, "counts_plt") +
          theme(legend.position = "right", legend.direction = "horizontal")) |>
          get_plot_component("guide-box", return_all = T) |>
          pluck(1)
      )
    )
  )
)

# NOTE: consider changing approach to base height/width and ncol
save_plot(
  here::here(
    "figures",
    "main",
    "Figure4.svg"
  ),
  fig4,
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
  units = "mm",
  ncol = 1,
  nrow = 1
)
