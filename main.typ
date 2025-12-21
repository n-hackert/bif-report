// the main template function
#import "template.typ": report
// some helpful functions that will at least partially become obsolete
#import "utils.typ": panel_ref, mr, todo


#show: report.with(
  title: "Alternative splicing dynamics and allele-specific splicing in T cell activation",
)

= Abstract

Non-coding risk variants for multiple autoimmune diseases likely affect gene regulation in memory CD4#super[+] T cells.
However, co-localization analyses with expression and splicing quantitative trait loci (QTL) have only provided putative functional relevance to up to 38% of tested disease-associated variants, emphasizing the need to ascertain cell state-specific regulatory effects.
Here, we investigate dynamic alternative splicing in activated T cells and develop and apply a computational method to quantify allele-specific junction usage, reflecting the influence of genetic variation on RNA splicing.

= Original aims

[Placeholder]

= Change of original aims

[Placeholder]

= Main
// The main text describes the most important results, how they were obtained (model systems, approaches and methods), and their impact on the field. It should not exceed four to five pages and end with a brief discussion and outlook

== Introduction
// Begin the main text of your final report with a short introduction. It should be comprehensible to all scientists, e.g. physicists, biochemists, and molecular biologists. This part should introduce readers to the field, place your work in the context of the known facts, and state the question(s) you aimed to resolve

[Placeholder]

== Results

// leafcutter results
=== Transcriptome-wide splicing patterns are markedly affected by T cell activation

We assessed alternative splicing in a public dataset of CD4#super[+] memory T cells from 24 healthy individuals that were subjected to high-depth RNA-sequencing at 8 points in time (0h, 2h, 4h, 8h, 12h, 24h, 48h, 72h) after anti-CD3/CD28 stimulation.
We applied LeafCutter's annotation-free splicing quantification based on split-read clustering to quantify splicing and test for differential splicing between pairs of consecutive points in time.
A Principal Component Analysis (PCA) of LeafCutter quantifications showed a strong separation of samples by time after activation (#panel_ref(<fig1>, "a")).
Differential splicing was widespread across the transcriptome of activated memory CD4#super[+] T cells with significant differential splicing at 5% FDR ranging from 2564 LeafCutter clusters in 2399 genes (12 vs. 8 hours) to 12127 clusters spread across 8091 genes (48 vs. 24 hours) (#panel_ref(<fig1>, "b")).

// == Differential splicing of splicing factors and key immune genes

// As previously demonstrated, many genes that regulate splicing, such as _SRSF2_ and other splicing factors are differentially spliced in activated T cells (#mr).
Notably, we found differential splicing events in genes with high relevance for T cell biology, such as _LEF1_ (#panel_ref(<fig1>, "c")) and _IL10_ (#panel_ref(<fig1>, "d")).

// rMATS results
=== Alternative splicing throughout T cell activation is driven by exon skipping

To validate the pervasiveness of differential splicing, and to assess which biological forms of alternative splicing drive splicing changes after T cell activation, we applied rMATS to our dataset.
Relying more heavily on genome annotations than LeafCutter, rMATS allows the classification of differential splicing events into one in five categories: skipped exon, alternative 5' splice sites, alternative 3' splice sites, mutually exclusive exons, retained intron.
With a median of 50% of all differential splicing events at 5% FDR, the most abundant mechanism of splicing in differentially spliced genes was constituted by exon skipping, followed by mutually exclusive exons, alternative 5’ or 3’ splice sites and intron retention (#panel_ref(<fig1>, "c")).

=== Intron retention decreases after early activation and increases in late activation

Interestingly, we found that the directionality of differential splicing of introns (retention/excision) showed a strong dependence on T cell activation state.
While there is a strong skew towards the excision of introns in early T cell activation (ranging from 817 to 1873 intron excision events compared to 180 to 560 inclusion events before 72 hours) this pattern is reversed after 48 hours, strongly favoring the retention of introns (303 excision events vs 1637 inclusion events) (#panel_ref(<fig1>, "d")).

// fig 1 including rMATS and leafcutter global res
#figure(
  image("figures/main/Figure1.svg"),
  caption: [
    *Differential splicing upon T cell activation.*
    *a* Principal Component analysis of samples, including technical replicates, (n=200) based on LeafCutter quantifications.
    *b* Number of significant LeafCutter clusters (left) and number of genes with significant LeafCutter clusters (right) for each differential splicing comparison (n=7) at 5% FDR
    *c* and *d* Examples of differentially spliced LeafCutter clusters in autoimmune disease risk genes _IL10_ (top) and _LEF1_ (bottom). Left side: Cluster plots from one differential splicing test. All significant $Delta"PSI"$ values throughout the time course are shown on the right of the cluster plot for each leafcutter intron ("a", "b", "c").
    *e* Types of significant differential splicing events detected by rMATS (SE skipped exon, A5SS alternative 5' splice sites, A3SS alternative 3' splice sites, MXE mutually exclusive exons, RI retained intron).
    *f* Number of significant intron retention (upper half) and excision (lower half) events as classified by rMATS at FDR 10%.
    Differential splicing was tested between time shown on the X-axes and preceding time.  
  ]
) <fig1>

=== Isoform diversity reduction upon T cell activation

We next sought to understand how differential splicing influences the diversity of gene-expression at both, the gene and transcript isoform level.
We found that the number of lowly expressed genes ($log_2("TPM")<=3$) showed a reduction upon T cell activation while the number of genes expressed expressed between a $log_2("TPM")$ of 7 and 12 exhibited an increase in expression (figs1).
Few very highly expressed genes were also expressed less abundantly.
There was no similar time-dependent trend in the samples' library sizes (figs2).

We thus focused on genes expressed above a threshold of $1 log_2("TPM")$ throughout all times to detect changes in transcript isoform diversity.
Isoform diversity was measured both, by the number of expressed transcript isoforms as well as the Gini index.
We found that the number of genes expressing 8 or more different transcript isoforms decreased upon T cell activation, while there was a simultaneous increase in the number of genes expressing 1 to 5 isoforms (figs3).
When calculating the gene-wise Gini index for genes expressing 2 or more isoforms, we found that Gini indices increased globally after activation, indicating a concentration of abundances on fewer transcripts.
Importantly, we only found sparse evidence of correlation between a gene's Gini index and its expression levels with time (figs4).
We therefore concluded that, while there is some level of dependence, decreasing gene expression levels are not the main driver of the global reduction in transcript isoform diversity.

=== Gene groups of isoform diversity changes

Based on how the number of transcipts expressed changed throughout time per highly vairable gene (n = 1977), we found five different groups of genes exhibiting distinct isoform diversity dynamics.
Despite the global reduction in isoform diversity, three of those groups showed a complete or partial increase in the median number of transcripts expressed with respect to the measured points in time.
The two remaining gene groups showed a (weak or strong) decrease in the number of transcripts they expressed and were thus concordant with the global pattern.

// figure 2 isoform diversity analysis results
#figure(
  image("figures/main/Figure2.svg"),
  caption: [
    *Isoform diversity reduction upon activation.*
    *a* Number of genes expressed above $1 log_2("TPM")$ per sample (N = 184).
    *b* Change in gene-wise Gini indices throughout time. X-axis: Gini-index value bins, Y-Axis: number of genes per bin at each time. Boxes are colored by time.
    *c* Median difference in number of transcript isoforms expressed per gene for highly variable genes. X-axis: time, Y-axis: genes, partitioned into k-medoids-based groups, Color: difference in numbers of transcripts expressed compared to 0h.
  ]
) <fig2>

=== SNPJunkie enables quantification of allelic split-reads from RNA-sequencing data

We next sought to understand how genetic variants affect alternative mRNA-splicing in resting and activated T cells.
In the past, numerous approaches have been developed to map genetic variants that are associated with quantitative variations in splicing-related phenotypes, called splicing quantitative trait loci (sQTL).
// TODO: check if we're correctly citing regtools here (how many samples do we need for a normal regtools workflow)
Methods relying on split-read alignments @li2018a @cotto2023 to quantify mRNA-splicing have been particularly successful, reducing the reliance on genome annotations and enabling the mapping of sQTLs with an high level of granularity.
However, these methods usually rely on large numbers of samples and are therefore not applicable for smaller datasets or individual samples.
Testing for allele-specific differences RNA-seq alignments has been successful for understanding the regulatory impact of variants on the total expression of genes in individual samples, however, only few methods exist for the assessment of allele-specific splicing and even fewer methods focus on understanding allele-specificity in the usage of individual junctions.
We thus developed a computational approach to quantify allelic counts for individual junctions from spliced RNA-seq alignments (#panel_ref(<fig3>, "a")).

[Placeholder]

// Overall, our tool was able to detect ... SNP-junction combinations ("events").
// Of those events, ... were left when applying ... QC criteria.
// These events were reliably detected across the time-course samples within individuals, as evidenced by a Jaccard index of ...
// Inter-individual similarity of events was lower (Jaccard: ...).

// We then used this data to test for allele specific junction usage.
// We did that in a few different ways
// - first we checked for significant AI in junction-stratified allelic counts
// - we compared this to AI without junction-stratification

// AI in junction-stratified counts by itself does not really tell us that much.
// For more robust associations of a SNP with splicing phenotypes, it is helpful to compare how this SNP influences junctions that share this SNP and also their donor or acceptor site.
// Here, we would test whether allelic imbalance co-vaires (??) with SNP-junction association.
// An allele influencing the inclusion of an exon in a transcipt could for example be associated with heavy usage of junction 1, whereas the other allele would be associated with the usage of junction 2.
// To test this, we ran a fishers exact test on our event groups.
// We found ...

// Old bullets
// - description of SNPJunkie method
//   - we needed something allowing us to quantify allelic imbalance for split reads from RNA-seq data
//   - SNPJunkie takes all split alignments that pass STAR filters and checks quantifies their allelic count (Fig. 3a)
// - SNPJunkie performance on the T cell dataset
//   - our approach yielded ... unique SNP-junction combinations for which allelic counts could be quantified (Fig. 3b)
//   - we QCed the allelic counts retrieved by SNPJunkie
//     - basic QC: allelic imbalance across events, filters, HLA exclusion??
//     - more downstream QC: we checked the similarity of events that we found, are they robust across samples of ... ? (Fig. 3c)

// figure 3
#figure(
  image("figures/main/Figure3.svg"),
  caption: [
    *SNPJunkie enables allele-specific quantification of junction reads and testing for allele-specific junction usage.*
    *a* Conceptual overview of the SNPJunkie pipeline. Step 1: Spliced and allele-specific alignment of RNA-seq reads to the genome are generated using STAR in WASP mode. Allelic bias is minimized using WASP. Step 2: Allele-specific quantification of junction counts are generated from those alignments using SNPJunkie. Each detected SNP-junction combination is counted towards a SNPJunkie "event". Events that share a SNP and either their donor or acceptor site are grouped for statistical testing. Step 3: Fisher's exact test is used to test for asymmetries in allelic imbalances across events of a group. This is done per group across the entire genome.
    *b* Number of detected SNPJunkie events per chromosome in each sample (N = 184).
    *c* Similarity of detected SNPJunkie events between samples of the same (right) and different (left) individuals. Similarity is quantified by calculating the Jaccard index between all SNPJunkie events of two samples. Shown is a pooled distribution of the Jaccard indices across all combinations that are either done within or across individuals.
  ]
) <fig3>

== Discussion

[Placeholder]

// TODO remove this or merge it with main text
== Methods

=== CD4#super[+] memory T cell bulk RNA-sequencing data

We obtained RNA-sequencing data from memory CD4#super[+] T cells at 8 points in time after anti-CD3/CD28 stimulation as described previously @gutierrez-arcelus2020.
Briefly, memory CD4#super[+] T cells were isolated from the PBMCs of 24 donors by magnetic selection.
Donors were between 20–50 years old, of European ancestry and had no history of autoimmune disease.
Isolated cells were plated and rested for 12 hours, marking the beginning (0h) of the time course experiment.
Cells were subsequently stimulated using human T-activator CD3/28 Dynabeads (Gibco) and collected at 2, 4, 8, 12, 24, 48 and 72 hours after stimulation.
101bp paired-end RNA sequencing was performed at the Broad Institute on Illumina HiSeq 2000 or 2500 sequencers following TruSeq stranded library preparation.

=== Splicing quantification and differential splicing analyses

==== Quality control, preprocessing and alignment<methods_ds_qc_trim>

Raw sequencing reads were processed using version v3.11.2 of the nf-core/rnaseq pipeline.
Briefly, quality control as well as adapter and quality trimming were performed with Trim Galore @krueger2023 v0.6.7, a wrapper around FastQC @zotero-item-860 v0.11.9 and Cutadapt @EJ200 v3.4, and reads were subsequently aligned to the hg38 reference genome using STAR @dobin2013 v2.7.9a.
Importantly, STAR was run in two-pass mode and with `--outSAMstrandField intronMotif`, generating an XS tag with strand information for all spliced alignments.
The pipeline was run using Nextflow @ditommaso2017 v23.04.1 and tasks were run inside singularity @kurtzer2017 @trudgian2025 v3.2.1 containers.

==== LeafCutter intron cluster quantification

We extracted juntions from the aligned reads using regtools @cotto2023 v1.0.0 `junctions exctract` command, requiring the default minimum anchor length of 8 bp, minimum intron size of 70 bp and maximum intron size of 500 000 bp.
// Strand information was inferred from the a record's XS tag (`regtools junctions extract -s XS ...`)
We subsequently clustered junctions with LeafCutter @li2018a using its `leafcutter_cluster_regtools.py` script, requiring at least 50 reads in support of a cluster and permitting introns of lengths up to 500 000 bp.

==== LeafCutter differential splicing

We tested for differential splicing between consecutive points in time (2h against 2h, 4h against 2h, ...) using a custom wrapper script around the `differential_splicing` function from the LeafCutter package with identical default parameters (`max_cluster_size=Inf`, `min_samples_per_intron=5`, `min_samples_per_group=3`, `min_coverage=20`, `timeout=30`, `init='smart'`).

==== rMATS differential splicing

We additionally tested for differential splicing between consecutive points in time using rMATS-turbo @shen2014 v4.1.2.
We ran rMATS directly on the BAM files resulting from STAR alignment as described above.
rMATS was run in paired-end mode, using a fr-firststrand library type and setting read length to 101 bp.

=== Isoform diversity analyses

==== Preprocessing and transcript abundance quantification

Adapter and quality trimming was performed using the nf-core/rnaseq pipeline as described above (@methods_ds_qc_trim), however, different versions of Nextflow (v24.04.4), the nf-core/rnaseq pipeline (v3.15.1) and singularity-ce (v3.8.3) were used.
Trimmed reads were used to quantify transcript expression with Salmon @patro2017 v1.10.1 in mapping-based mode, passing the extra `--gcBias --seqBias --numBootstraps 30` args, accounting for GC and sequence-specific biases and adding bootstrapped transcript abundance estimates.

==== Calculation of number of genes expressed

We calculated the number of genes expressed in each sample at different thresholds $0 <= T <= 14$ based on gene abundance estimates ($log_2("TPM")$).

As we observed a global reduction in the number of expressed genes, we only considered genes that were constantly expressed above $1 log_2("TPM")$ when calculating isoform diversity metrics (@methods_ntx and @methods_gini).

==== Number of transcripts expressed per gene <methods_ntx>

Following pre-filtering, we calculated the number of expressed transcripts per gene, counting all transcripts of a gene with non-zero expression as expressed transcripts.

==== Gini index per gene<methods_gini>

We calculated the Gini index for each sufficiently expressed gene (see above) that showed non-zero expression of two or more transcript isoforms as a measure of inequality of the distribution of abundances between those expressed transcript isoforms.

==== Isoform diversity clusters

Following pre-filtering and calculation of number of transcripts expressed per gene ($"ntx"$), we calculated the difference in numbers of transcripts expressed at time $t$ compared to 0h: $Delta"ntx"_t="ntx"_t-"ntx"_"0h"$.
Based on the median of the $Delta"ntx"$ metric across samples, we clustered highly variable genes ($sigma(Delta"ntx")>1$) using the partitioning around medoids clustering algorithm based on manhattan distances.
Based on an analysis of silhoulette widths, we set k=5, as it led to a maximized silhoulette score of 0.268.

#pagebreak()

#bibliography(
  "20251218_report_v01.bib",
  style: "nature",
  title: "References",
)

#pagebreak()

= Publications
// TODO: list single references here (secondary bibliography? check typst) 
// Please list all your publications (published, in press, or submitted) and poster abstracts resulting from the time of our funding (please denote shared authorships)

// TODO: key words are to be given in a final paragraph