#!/usr/bin/env zsh
# a script to make figure generation easier

set -u
set -o pipefail
setopt NULL_GLOB

# hard-coding this to prevent mess-ups when run outside of project dir
ROOT="/Users/n-hackert/Documents/Code/mga_lab/t_cell_manuscript/20250929_manuscript_v02"

# Color definitions (using ANSI escape codes)
COLOR_RESET='\033[0m'
COLOR_BOLD='\033[1m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_RED='\033[0;31m'
COLOR_BLUE='\033[0;34m'
COLOR_CYAN='\033[0;36m'

# ---------------------------------------

cd "$ROOT" || { echo "${COLOR_RED}Cannot cd to $ROOT${COLOR_RESET}"; exit 2; }
ran=0
skipped=0
failed=0

# Arrays to store figure actions for summary
typeset -a summary_lines

echo "${COLOR_BOLD}Project root:${COLOR_RESET} $ROOT"

# Process both main and supplementary figures
for folder in main supplementary; do
  echo "\n${COLOR_CYAN}${COLOR_BOLD}=== Processing ${folder} figures ===${COLOR_RESET}"
  
#   # Set figure prefix based on folder
#   if [[ $folder == "main" ]]; then
#     fig_prefix="Figure"
#   else
#     fig_prefix="FigureS"
#   fi
  fig_prefix="Figure"
  
  # Add folder header to summary
  summary_lines+=("${COLOR_CYAN}${COLOR_BOLD}=== ${folder} figures ===${COLOR_RESET}")
  
  for r in R/fig_gen/${folder}/fig*.R; do
    [[ -e $r ]] || continue  # skip if no files found
    base=${r##*/}            # e.g. fig3.R
    num=${base#fig}          # e.g. 3.R
    num=${num%.R}            # e.g. 3
    fig="figures/${folder}/${fig_prefix}${num}.svg"
    printf "\n${COLOR_BLUE}Checking:${COLOR_RESET} %s -> %s\n" "$r" "$fig"
    
    action=""
    if [[ ! -e $fig ]]; then
      echo "  ${COLOR_YELLOW}reason: figure missing -> will run.${COLOR_RESET}"
      action="will run (missing)"
    elif [[ $r -nt $fig ]]; then
      echo "  ${COLOR_YELLOW}reason: R script is newer than figure -> will run.${COLOR_RESET}"
      action="will run (outdated)"
    else
      echo "  ${COLOR_GREEN}reason: up-to-date -> skipping.${COLOR_RESET}"
      summary_lines+=("  ${fig_prefix}${num}: ${COLOR_GREEN}skipped (up-to-date)${COLOR_RESET}")
      (( skipped++ ))
      continue
    fi
    
    echo "  running: Rscript $r"
    if Rscript "$r"; then
      echo "  ${COLOR_GREEN}✓ done.${COLOR_RESET}"
      summary_lines+=("  ${fig_prefix}${num}: ${COLOR_GREEN}ran successfully${COLOR_RESET}")
      (( ran++ ))
    else
      echo "  ${COLOR_RED}✗ ERROR: Rscript failed for $r${COLOR_RESET}" >&2
      summary_lines+=("  ${fig_prefix}${num}: ${COLOR_RED}FAILED${COLOR_RESET}")
      (( failed++ ))
    fi
  done
done

# Print detailed summary
echo "\n${COLOR_CYAN}${COLOR_BOLD}========================================${COLOR_RESET}"
echo "${COLOR_BOLD}SUMMARY${COLOR_RESET}"
echo "${COLOR_CYAN}${COLOR_BOLD}========================================${COLOR_RESET}"
for line in "${summary_lines[@]}"; do
  echo "$line"
done
echo "${COLOR_CYAN}${COLOR_BOLD}========================================${COLOR_RESET}"
echo "${COLOR_BOLD}Total:${COLOR_RESET} ${COLOR_GREEN}ran=$ran${COLOR_RESET}  ${COLOR_YELLOW}skipped=$skipped${COLOR_RESET}  ${COLOR_RED}failed=$failed${COLOR_RESET}"

exit $failed
