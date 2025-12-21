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

- [ ] remove abstract formatter, and add as section
- [ ] use formatters in main file if needed, or rethink their use
- [ ] font and size
- [ ] page margins
- [ ] add sections that are required
- [ ] include content from google doc and document it accordingly
- [ ] finish checking reqs file
