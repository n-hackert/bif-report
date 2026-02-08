# BIF fellowship report

## CAVEAT

This project has hard coded paths etc. sanitize before publishing.

## Description

Similar to manuscript repo, however, here we are dealing with the BIF side of things.

This folder contains the manuscript files as well as figure generation code in a subfolder.

```{sh}
.
├── R                   # figure generators and utils R code only
│   ├── fig_gen
│   └── utils.R
├── README.md
├── figures             # static figure files / for the most: PDFs and source data NOT in vcs
│   └── source_data     # source data, properly formatted analysis res
├── main.typ            # report file
├── tables              # static table files / for the most source data NOT in vcs
│   └── source_data
└── template.typ        # custom template code
```

## NOTE: INPUT FROM EXISTING DOCUMENTS INCLUDED

- google doc "Report" in "BIF_MD_fellowship_report" (wip)

## TODOs

- [ ] ask Maria about how she usually goes about grant-report writing
  - [ ] what are the things that you are usually held accountable for
  - [ ] which elements do not matter as much and do not need to be considered in depth
- [ ] check JCAST and proteomics analyses that were run on the cluster
- [ ] use formatters in main file if needed, or rethink their use
- [ ] page margins
- [ ] include content from google doc and document it accordingly
- [x] finish checking reqs file
- [x] remove abstract formatter, and add as section
- [x] add sections that are required
- [x] font and size

### Plan

0. [ ] re-read Aims section of proposal and clarify where we need to explain novel approaches or properly align analyses
1. [ ] explore dynamic ASJU testing and see how we can use analysis results best
2. [ ] align explanation of dynASJU SNPJunkie w/ Aim II.1 explanation
3. [ ] compare binom ASE with logreg ASJU SNP involvement in a similar plot (same categories, look at time dynamics) // MAIN goal, directionality likely not reasonable here but think about effect sizes or if directionality makes sense in some respect
