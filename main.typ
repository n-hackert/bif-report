// the main template function
#import "template.typ": report
// some helpful functions that will at least partially become obsolete
#import "utils.typ": panel_ref, mr, todo


#show: report.with(
  title: "Alternative splicing dynamics and allele-specific alternative splicing in T cell activation",
)

= Abstract

Non-coding risk variants for multiple autoimmune diseases likely affect gene regulation in memory CD4#super[+] T cells.
However, co-localization analyses with expression and splicing quantitative trait loci have only provided putative functional relevance to up to 38% of tested disease-associated variants, emphasizing the need to ascertain cell state-specific regulatory effects.
Here, we investigate dynamic alternative splicing in stimulated memory CD4#super[+] T cells from 24 healthy individuals and develop and apply a computational method to quantify allele-specific junction usage, reflecting the influence of genetic variation on RNA splicing.

We found that differential splicing upon activation of memory CD4#super[+] T cells is pervasive throughout the transcriptome, showing a strong time-dependent dynamic with differential splicing in up to 8091 genes.
Transcriptome-wide intron retention and transcript isoform diversity both reduced upon activation.
// Diversity of transcript isoform expression showed a global reduction upon activation, however, there were groups of genes markedly expanding their isoform diversity upon activation.
We further developed SNPJunkie, a tool to quantify allelic junction counts from fragments aligned to one or more SNP-junction combinations (events).
Based on SNPJunkie event quantifications, we found widespread evidence of allele-specific junction usage, occurring in many genes central to T cell function as well as autoimmune disease risk genes.

Our work highlights the dynamic nature of alternative splicing during T cell activation and introduces a new computational method allowing fast and unbiased quantification of the effects of genetic variation on exon-exon junction usage on the level of individual samples.


= Original aims

/*

Hypothesis: Explanations only needed for deviations from the bold approach statements and overarching aims

Old plots / diff from paper needed
- Aim I.1: show at least some Pvals from linearly modeling lc junctions / clusters
- Aim I.2: show the volcano result from proteomics initial analyses ("noncanonical isoforms")
- Aim I.2: is there some JCAST diagnostic plot that I have potentially built in the past?
- Aim II.1: plot showing the overlap of our dynASJU genes with NatGenet dynASE genes
- Aim II.2: enrichment plot for dynASJU genes
- Aim II.3: revisit IL4R example plot, check cluster for other example plots that align w/ proposed criteria

Explanation needed
- Aim I.2 was not finished, but worked on
- Aim II.3 was not finished, but worked on
- some methodological deviations from the proposal in Aims II.1, II.2

Comments on aims from original proposal:
Aim I:
- Hypothesis key points
  - splicing shows a highly dynamic pattern throughout time course
  - transcript isoform diversity expands upon activation
  - alternatively spliced tx can be detected by LC-MS/MS
- Aim I.1
  - realignment of T cell dataset w/ STAR and processing w/ leafcutter // we did exactly that
  - novel junction and isoform discovery potential // deprioritized, can we show something here? // reads more like an argument for the leafcutter approach, we did not make any claims about wanting to find novel isoforms
  - intron cluster with 2nd order poly(time) llms for introns // deprioritized as this did yield to many significant hits, can we show something here?
- Aim I.2
  - characterization of differential isoform usage/splicing using LC-MS/MS // we did not perform LC-MS/MS
  - generate a custom DB to scan proteomic spectra with higher sensitivity toward our dataset // was indeed built and tested on public datasets and JCAST was used as indicated in the proposal // can we show something here?

Aim II
- Hypothesis key points
  - a number of variants only has regulatory activity in activated T cells
  - activation-specific regulatory variants are enriched in autoimmune disease risk loci
- Aim II.1
  - dynASE re-analysis and correlation of dynASE w/ splicing patterns, determine dynASE genes that owe their expression to splicing patterns // we sort of did that, although with a modified approach directly allowing us to call what we see dynASJU instead of having to go through a correlation proxy
  - approach very focused on fraction of genes showing dynASE because of splicing // might need to compare Maria's dynASE supplementary table with our dynASJU genes
- Aim II.2
  - perform enrichment for loci w/ evidence of allele-specific alternative splicing // we did precisely that
  - disease gene identification: GWAS catalog -> SNPSea -> disease gene // we did not do that, but instead opted to pull disease genes from the OTG platform
  - enrichment strategy: observed overlaps against overlaps from 1000 null sets of randomly selected, size matched genomic regions // needs confirmation, but approach was probably very similar
- Aim II.3
  - map variants to autoimmune disease genes // we did that based on location of the variant
  - select 3 genes for validation based on effect size, lead risk variant association, immunological function // we can show at least the IL4R example here, but check, if there is other worthwhile examples on the cluster
  - experimental validation based on qPCR // was not done

*/

*Title:* Alternative splicing dynamics during adaptive immune response

*Aim I. Characterize the dynamics of alternative splicing during the activation of memory CD4#super[+] T cells.*
We aimed to quantify differential intron excision in various activation states of memory CD4#super[+] T cells and analyze how splicing patterns change dynamically throughout the time of activation.
We further aimed to validate the existence of putative protein products from alternatively spliced mRNA transcripts using mass spectrometry.
#underline[We hypothesized] that alternative splicing will be highly dynamic throughout the activation of memory CD4#super[+] T cells and that isoform usage is expanded upon activation.

_#underline[Approach]_
#enum(numbering: (..nums)=>text("Aim I." + nums.pos().map(str).join("."), weight: "bold"))[
  *Quantify alternative splicing and define how splicing changes throughout the activation of memory CD4#super[+] T cells.*
  Leveraging time course RNA sequencing (RNA-seq) data that was previously published by the host laboratory (#cite(<gutierrez-arcelus2020>, form: "prose")), we aimed to identify and quantify dynamic alternative splicing events throughout the activation of memory CD4#super[+] T cells.
][
  *Characterize differential isoform usage using mass spectrometry.*
  We set out to perform liquid chromatography tandem mass spectrometry (LC-MS/MS) to identify and quantify differential isoform usage at the protein level.
  We aimed to enhance this approach by generating a custom in-silico database with JCAST @lau2019, a tool allowing the prediction of splice junction protein sequences from alternative splicing events detected in RNA-seq data.
]


*Aim II. Characterize allele-specific splicing in autoimmune disease loci.*
We aimed to identify and quantify allele-specific alternative splicing in heterozygous loci, to capture effects of genetic regulatory variants on splicing.
We subsequently aimed to quantify their cell-state specific effects over the time of memory T cell activation.
Using genetic variants reported from genome-wide association studies (GWAS), we aimed to perform an enrichment analysis of the identified dynamic allele-specific splicing sites for genetic risk loci associated with autoimmune disease to establish their potential role as key pathogenetic mechanism in autoimmunity.
#underline[We hypothesized] that there exist genetic variants dynamically influencing alternative splicing and that these variants are enriched in autoimmune disease loci.

_#underline[Approach]_
#enum(numbering: (..nums)=>text("Aim II." + nums.pos().map(str).join("."), weight: "bold"))[
  *Quantify the proportion of ASE caused by alternative splicing effects.*
  We aimed to quantify dynASE as reported previously (Gutierrez-Arcelus et al. 2020) and quantify the proportion of dynASE partially or completely caused by alternative splicing events.
][
  *Assess allele-specific splicing enrichment in autoimmune disease risk loci.*
  We set out to perform an enrichment analysis of genetic loci showing evidence for dynamic allele-specific alternative splicing for autoimmune disease risk genes as reported by recent GWAS.
][
  *Map the variants affecting splicing for key autoimmune disease genes and validate their regulatory effect.*
  Based on their effect size, immunological relevance and association to autoimmune disease risk, we aimed to select allele-specific alternative splicing events in three genes for further validation by quantitative PCR.
]

= Change of original aims

There were no changes to the aims outlined in the initial proposal.
No aims were stopped or suspended and no additional aspects were pursued during the project.
It should be noted, however, that aims I.2 and II.3 were only partially completed due to delays in the realization of preceding aims and the resulting time constraints.
// TODO: I.2 better explanation, should show proteomics data that was analyzed as well as riboseq preps if worth it
// Aim I.2: we only generated the database and tested the approach in public datasets
// frame as change of approach? priority shift?
/*

suggestion for aim I.2 framing

To improve the accuracy of finding splice isoforms in proteomic data and to aid in designing appropriate experiments, we introduced an additional approach to resolve aim I.
This approach consisted in an in silico analysis of existing T cell proteome datasets based on a custom database built using JCAST as intended
This yielded ...

*/

= Main
/*
  from reqs doc: The main text describes the most important results, how they were obtained (model systems, approaches and methods), and their impact on the field. It should not exceed four to five pages and end with a brief discussion and outlook

  from reqs doc: Begin the main text of your final report with a short introduction. It should be comprehensible to all scientists, e.g. physicists, biochemists, and molecular biologists. This part should introduce readers to the field, place your work in the context of the known facts, and state the question(s) you aimed to resolve

  structure for main
  - introduction
  - results
  - methods ("how they were obtained")
  - discussion ("impact")
*/

== Introduction

// TODO: this still needs to be pulled from the gdoc
Autoimmune diseases affect an estimated 7.6 to 9.4% of the global population and, typically being of higher prevalence in female than in male populations, pose one of the top 10 leading causes of death for women up to the age of 65 and 75 years in the US and the UK respectively @thomas2010a.
There exist symptomatic treatments to attenuate inflammation in these chronic diseases which, however, have proven to be highly variable in their effectiveness and applicability to different subgroups of patients.
// TODO: check this sentence, maybe read a recent reveiw
Even though recent advances have achieved deep remissions, autoimmune diseases are generally considered incurable to date @ramirez-valle2024.

In order to work towards the development of causal treatments, and to develop and improve prevention strategies, it is crucial to understand the different molecular mechanisms causing autoimmunity in humans @gutierrez-arcelus2016.
Our understanding of the function of the immune system has been advanced by experiments in mouse models.
Nonetheless there is the need to translate those findings to the human organism @davis2008.
It has long been known that the genetic investigation of autoimmune diseases poses an important step towards understanding their complex, environmentally influenced etiology @vyse1996.
In the last decade, genome-wide association studies (GWAS), have allowed scientists to identify hundreds of genetic loci associated with an increased risk for autoimmune diseases @parkes2013.
Studying the mechanisms through which these genetic variants can impair the physiological function of the human immune system is a key step towards understanding autoimmunity.
However, given that about 90% of the susceptibility variants are non-coding, the mechanisms through which they act upon immunophenotypes have only been defined for a very small fraction of them @farh2015.

Genetic studies provide evidence for an enrichment of these variants in distant regulatory elements of memory CD4#super[+] T cells, which renders them a very promising target for investigation @trynka2013 @farh2015 @onengut-gumuscu2015.
It can further be hypothesized that most of the risk variants for autoimmune diseases affect gene regulation in specific immune cell types, which together disrupt immune cell function.
This in turn could lead to the emergence of intermediate immune-phenotypes triggering autoimmunity and causing disease.
An integral question in this regard is through which mechanisms gene regulation is impaired.
However, only about 25% of risk variants co-localize with genetic variants that are associated with gene expression levels, i.e., eQTL in immune cells @chun2017.
We and others have previously shown that this is at least in part due to the high dependence of regulatory effects of genetic variants on the activation state of lymphocytes @gutierrez-arcelus2020, indicating that a part of the “missing regulatory effects” of autoimmune disease risk variants is hidden in activated cell states which have yet to be systematically ascertained.

Another explanation for the relatively small overlap between eQTL and genomic risk variants is provided by regulatory effects that cannot be assessed by quantifying total gene expression levels.
Instead, their investigation necessitates the exploration of different transcriptomic phenotypes such as alternative splicing.
// TODO: update to match the current state of the literature
As these phenotypes have been less explored, there is the need to improve the understanding of their regulation and their behavior in resting and specific cellular activation states.
Alternative splicing is a phenomenon present in up to 95% of human multi exon genes and has a high relevance in the immune system, in lineage differentiation and maturation @pan2008 @ergun2013 @shalek2013 @schaub2017 @rotival2019 . 
For example, a specific isoform of the transcription factor _FOXP3_, _FOXP3$Delta 2 Delta 7$_, has been implicated in the hampering of the physiological inhibitory function of regulatory T cells by promoting their differentiation to Th17 cells @mailer2015.

In order to satisfy the need to better understand how disease risk variants act on specific cell states and what role alternative splicing plays in this respect, we proposed to investigate dynamic allele-specific splicing during the activation of memory CD4#super[+] T cells and to characterize its functional consequences.

/*
previous snippets (google doc)

Transition to our work; make sure it’s well contextualized and emphasize questions

To date, autoimmune diseases still constitute an incurable form of disease affecting a significant fraction of the global population1,2. To work towards causal treatments for autoimmunity, it is central to better understand how genetic variants exert their effects on cellular processes3. Genetic risk variants for autoimmune diseases, as uncovered by recent genetic studies, are mostly non-coding and enriched in distant regulatory elements in memory CD4+ T cells4–6. However, only 25% of these non-coding variants have been shown to co-localize with variants associated with gene expression levels (expression quantitative trait loci, eQTL)7, leaving 75% unaccounted for. Our group and others previously demonstrated the relevance of ascertaining cell state specific effects of regulatory variants on gene expression in T cells, extending the mechanistic understanding of those variants8,9.
We previously demonstrated that allelic expression of genetic variants in autoimmune disease risk genes dynamically changes throughout T cell activation (add ref), providing a potential explanation for the low fraction of risk variants colocalizing with static regulatory variants.

Here, we show that autoimmune disease risk variants can dynamically regulate junction usage during T cell activation. We developed SNPJunkie, a rust tool, to quantify allele specific junction usage from spliced, personalized alignments of short-read bulk RNA Sequencing data. We show that SNPJunkie enables the detection of allele specific junction usage events in resting and activating T cells and that allele specific junction usage changes dynamically with T cell activation. Static as well as dynamic allele-specific junction usage events are enriched in ???autoimmune disease risk genes???. Add sentence about impact

*/

== Results

// fig 1 including rMATS and leafcutter global res
#figure(
  image("figures/main/Figure1.svg"),
  placement: top,
  caption: [
    *Differential splicing upon T cell activation.*
    *a* Principal Component analysis of samples, including technical replicates, (n=200) based on LeafCutter quantifications.
    *b* Number of significant LeafCutter clusters (left) and number of genes with significant LeafCutter clusters (right) for each differential splicing comparison (n=7) at 5% FDR
    *c* and *d* Examples of differentially spliced LeafCutter clusters in autoimmune disease risk genes _IL10_ (top) and _LEF1_ (bottom). Left side: Cluster plots from one differential splicing test. All significant $Delta"PSI"$ values throughout the time course are shown on the right of the cluster plot for each LeafCutter intron ("a", "b", "c").
    *e* Types of significant differential splicing events detected by rMATS (SE skipped exon, A5SS alternative 5' splice sites, A3SS alternative 3' splice sites, MXE mutually exclusive exons, RI retained intron).
    *f* Number of significant intron retention (upper half) and excision (lower half) events as classified by rMATS at FDR 10%.
    Differential splicing was tested between time shown on the X-axes and preceding time.  
  ]
) <fig1>

// leafcutter results
=== Transcriptome-wide splicing patterns are markedly affected by T cell activation

We assessed alternative splicing in a public dataset of CD4#super[+] memory T cells from 24 healthy individuals that were subjected to high-depth RNA sequencing at 8 points in time (0h, 2h, 4h, 8h, 12h, 24h, 48h, 72h) after anti-CD3/CD28 stimulation.
We applied LeafCutter's annotation-free splicing quantification algorithm based on split-read clustering to quantify splicing and tested for differential splicing between pairs of consecutive points in time.
A Principal Component Analysis (PCA) of LeafCutter quantifications showed a strong separation of samples by time after activation (#panel_ref(<fig1>, "a")).
Differential splicing was widespread across the transcriptome of activated memory CD4#super[+] T cells with significant differential splicing at 5% FDR ranging from 2564 LeafCutter clusters in 2399 genes (12 vs. 8 hours) to 12127 clusters spread across 8091 genes (48 vs. 24 hours) (#panel_ref(<fig1>, "b")).

Notably, we found differential splicing events in genes with high relevance for T cell biology, such as _LEF1_ (#panel_ref(<fig1>, "c")) and _IL10_ (#panel_ref(<fig1>, "d")).
// note to self: DO follow up on what is known here and check ASJU
We further observed differential splicing among genes with known regulatory functions in alternative splicing, the most notable example being the serine/arginine-rich (SR) protein family member _SRSF2_.

// rMATS results
=== Alternative splicing throughout T cell activation is driven by exon skipping

To validate the widespread nature of differential splicing, and to assess which alternative splicing event classes drive splicing changes after T cell activation, we applied rMATS to our dataset.
Relying more heavily on genome annotations than LeafCutter, rMATS allows the classification of differential splicing events into one in five categories: skipped exon, alternative 5' splice sites, alternative 3' splice sites, mutually exclusive exons, retained intron.
// we could confirm that splicing occurs a lot
// TODO: numbers and fig1e annotations
Differential splicing analysis by rMATS yielded a median of 11226 significant differential splicing events across all sequential comparisons (range 6264 -- 13107 events at 12 vs 8 hours and 8 vs 4 hours), confirming LeafCutter results.
With a median of 50% of all differential splicing events at 5% FDR, the most abundant mechanism of splicing in differentially spliced genes was constituted by exon skipping, followed by mutually exclusive exons, alternative 5’ or 3’ splice sites and intron retention (#panel_ref(<fig1>, "c")).


=== Intron retention decreases after early activation and increases in late activation

Interestingly, we found that the directionality of differential splicing of introns (retention/excision) showed a strong dependence on T cell activation state.
While there is a strong skew towards the excision of introns in early T cell activation (ranging from 817 to 1873 intron excision events compared to 180 to 560 inclusion events before 72 hours) this pattern is reversed after 48 hours, strongly favoring the retention of introns (303 excision events vs 1637 inclusion events) (#panel_ref(<fig1>, "d")).

=== Transcriptome-wide transcript isoform diversity reduces after activation

We next sought to understand how differential splicing influences the diversity of gene-expression at both, the gene and transcript isoform level.
We found that the number of lowly expressed genes ($log_2("TPM")<=3$) showed a reduction upon T cell activation while the number of genes expressed expressed between a $log_2("TPM")$ of 7 and 12 exhibited an increase in expression.
Few very highly expressed genes were also expressed less abundantly.
There was no similar time-dependent trend in the samples' library sizes.

// figure 2 isoform diversity analysis results
#figure(
  image("figures/main/Figure2.svg"),
  placement: top,
  caption: [
    *Isoform diversity reduction upon activation.*
    *a* Number of genes expressed above $1 log_2("TPM")$ per sample (N = 184).
    *b* Change in gene-wise Gini indices throughout time. X-axis: Gini-index value bins, Y-Axis: number of genes per bin at each time. Boxes are colored by time.
    *c* Median difference in number of transcript isoforms expressed per gene for highly variable genes. X-axis: time, Y-axis: genes, partitioned into k-medoids-based groups, Color: difference in numbers of transcripts expressed compared to 0h.
  ]
) <fig2>

We thus focused on genes expressed above a threshold of $1 log_2("TPM")$ throughout all times to detect changes in transcript isoform diversity.
Isoform diversity was measured both, by the number of expressed transcript isoforms as well as the Gini index.
We found that the number of genes expressing 8 or more different transcript isoforms decreased upon T cell activation, while there was a simultaneous increase in the number of genes expressing 1 to 5 isoforms.
When calculating the gene-wise Gini index for genes expressing 2 or more isoforms, we found that Gini indices increased globally after activation, indicating a concentration of abundances on fewer transcripts.
Importantly, we only found sparse evidence of correlation between a gene's Gini index and its expression levels.
We therefore concluded that, while there is some level of dependence, decreasing gene expression levels are not the main driver of the global reduction in transcript isoform diversity.

Based on their isoform diversity patterns with time, we selected highly variable (n = 1977) genes and defined five different gene groups, exhibiting distinct isoform diversity dynamics (#panel_ref(<fig2>, "c")).
Despite the global reduction in isoform diversity, three of those groups showed a complete or partial increase in the median number of transcripts expressed with respect to the measured points in time.
The two remaining gene groups showed a (weak or strong) decrease in the number of transcripts they expressed and were thus concordant with the global pattern.

=== SNPJunkie enables quantification of allelic split-reads from RNA sequencing data

Genetic variation is a key factor that both, influences alternative splicing patterns in resting immune cells, and how splicing patterns may change upon activation.
In the past, numerous approaches have been developed to map genetic variation to quantitative changes in alternative splicing, called splicing quantitative trait loci (sQTL).
// TODO: check if we're correctly citing regtools here (how many samples do we need for a normal regtools workflow)
Methods relying on split-read alignments @li2018a @cotto2023 to quantify mRNA-splicing have been particularly successful for mapping sQTLs, as they reduce the reliance on genome annotations and enable the mapping of sQTLs with a high level of granularity.
However, these methods usually rely on large sample sizes, i.e., $n > 100$ samples, and are thus not suited for mapping splicing regulatory variants in single samples.
Allele-specific expression analyses have enabled the mapping of genetic variants to overall gene expression levels in single samples.
Adapting these methods to capture not only overall gene expression levels, but also splicing patterns provides a promising avenue for the investigation of splicing regulatory variants.

// TODO: this flow / sentence is not amazing...
Therefore, in order to understand how genetic variation influences mRNA splicing in individual samples, we developed a computational framework allowing the allele-specific quantification of exon-exon junction counts from spliced allelic RNA-seq alignments (#panel_ref(<fig3>, "a")).

We first generated allele-specific alignments from raw RNA-seq reads for each individual (n = 24) using STAR @dobin2013.
To minimize allelic bias, we ran STAR in WASP mode and subsequently filtered out all alignments that did not pass WASP filtering.
Subsequently, we processed allele-specific alignments with a custom Rust software package, called SNPJunkie.
SNPJunkie parses STAR-WASP generated BAM files and quantifies allelic read counts for all SNP-junction combinations that are supported by at least one alignment in the respective file.
Each SNP-junction combination detected by the SNPJunkie pipeline is termed a SNPJunkie "event" and is defined by its SNP and junction coordinates.
The variables of interest for each event are counts that have been mapped to either the reference or alternative allele of this event's SNP.
This approach enables the stratification of allelic reads for a given SNP by whether an allelic alignment stems from a junction (or 'split') alignment.
Please refer to the respective methods section (@methods_snpjunkie) for a thorough description of SNPJunkie.


// figure 3: SNPJunkie pipeline intro, dynamic asju examples (and enrichment?)
#figure(
  image("figures/main/Figure3.svg"),
  placement: top,
  caption: [
    *SNPJunkie enables allele-specific quantification of junction reads and testing for allele-specific junction usage.*
    *a* Conceptual overview of the SNPJunkie pipeline. Step 1: Spliced and allele-specific alignment of RNA-seq reads to the genome are generated using STAR in WASP mode. Allelic bias is minimized using WASP. Step 2: Allele-specific quantification of junction counts are generated from those alignments using SNPJunkie. Each detected SNP-junction combination is counted towards a SNPJunkie "event". Events that share a SNP and either their donor or acceptor site are grouped for statistical testing. Step 3: A logistic regression framework is used to test for asymmetries in allelic imbalances across events of a group. This is done per group across the entire genome.
    *b* Number of QC passing events extracted with SNPJunkie across all samples (N = 184).
    *c* Manhattan plot showing static allele-specific junction usage across all samples (N = 184).
  ]
) <fig3>

=== Static allele-specific junction usage

When applying SNPJunkie to the our time course dataset, we detected a median of 7442 QC-passing events per sample (range: 3169 -- 17946 events, #panel_ref(<fig3>, "b")).
We reliably detected events across samples of the same individual, as indicated by a high median Jaccard similarity index of 0.601 between events in samples from the same individuals. As expected, there was lower concordance between the events detected in different individuals (median Jaccard similarity index of 0.148)

We subsequently used SNPJunkie event counts to test for sites that show allele-specific alternative splice junction usage.
SNPJunkie events were grouped by SNP as well as whether their junctions share a donor or acceptor splice site (#panel_ref(<fig3>, "a"), middle panel).
At sites that show evidence of allele-specific junction usage (ASJU), we expect significant differences in how allelic reads are distributed across junction reads associated aligned to different junctions but the same SNP, i.e., different SNPJunkie events sharing a SNP.
We used a logistic regression framework to test whether there are event-specific allelic imbalances in each SNPJunkie event group.

Across all samples, we found a total of 1795 event groups showing evidence of ASJU  (FDR \<5%, #panel_ref(<fig3>, "c")).
ASJU genes included genes with known central function in T cell immune responses as well as known disease risk genes, such as _IL2_, _IL7R_ and _CLEC2D_.
ASJU genes were moderately enriched in autoimmune disease risk gene sets, hinting at ASJU as a relevant mechanism through which genetic risk for autoimmune disease may be conferred.

// TODO: think about conceptionally mentioning the below info
// 
// For more robust associations of a SNP with splicing phenotypes, it is helpful to compare how this SNP influences junctions that share this SNP and also their donor or acceptor site.
// Here, we would test whether allelic imbalance co-vaires (??) with SNP-junction association.
// An allele influencing the inclusion of an exon in a transcipt could for example be associated with heavy usage of junction 1, whereas the other allele would be associated with the usage of junction 2.
// To test this, we ran a fishers exact test on our event groups.


=== Dynamic changes in event specific allelic imbalance

As described previously, there is a dynamic change in allelic expression at many SNPs in autoimmune disease risk loci upon activation of memory CD4#super[+] T-cells @gutierrez-arcelus2020.
Having quantified allelic counts not at the level of total allelic counts at a given SNP, but at the level of the combination of each SNP with its co-occurring junctions, we next sought to understand how allelic imbalance changes dynamically upon activation at different SNPJunkie events.
We thus tested for sites where dynamics in a SNPJunkie event's counts significantly differ from the dynamics of all other counts at that SNP that are not part of the event and thus do not support usage of its junction.

At 5% FDR, there were 270 events with allelic expression dynamics significantly differing from their SNPs overall allelic expression dynamics.
Similar to static ASJU, event-specific dynamic allelic expression was found in genes associated with autoimmune disease risk and known to play important roles in the regulation of T cell responses (#panel_ref(<fig4>, "b, c, d")).
Event though there was a strong signal from the HLA region, mainly in the HLA class I genes, _HLA-A_ and _HLA-C_, it should be noted that our genome-wide mapping approach did not specifically account for the high polymorphy in this region and further investigation with a targeted approach is needed to validate this finding.


== Methods

=== CD4#super[+] memory T cell bulk RNA sequencing data

We obtained RNA sequencing data from memory CD4#super[+] T cells at 8 points in time after anti-CD3/CD28 stimulation as described previously @gutierrez-arcelus2020.
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

#figure(
  image("figures/main/Figure4.svg"),
  caption: [
    *Allele-specific expression specific to junction reads changes dynamically upon T cell activation*
    *a* Manhattan plot showing SNPJunkie events where dynamic allelic expression profiles significantly differ from overall allelic expression at a SNP. Significant events in autoimmune disease risk genes are highlighted.
    *b-c* Examples of SNPJunkie events with dynamic event-specific allelic imbalance when compared to all reads at their SNP not part of the event. Top: reference fraction for all reads at the SNP that are part vs. not part of the SNPJunkie event in question. Middle and bottom: Read counts for the reference and alternative allele at the SNP and the event, respectively.
  ]
) <fig4>

==== LeafCutter intron cluster quantification

We extracted junctions from the aligned reads using regtools @cotto2023 v1.0.0 `junctions exctract` command, requiring the default minimum anchor length of 8 bp, minimum intron size of 70 bp and maximum intron size of 500 000 bp.
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
Based on an analysis of silhouette widths, we set k=5, as it led to a maximized silhouette score of 0.268.

=== SNPJunkie pipeline

The SNPJunkie pipeline consists of three steps:
1. Generation of allele-specific and spliced alignments using STAR in WASP mode.
2. Quantification of allele-specific junction read counts from BAM files using a custom Rust software package, SNPJunkie.
3. Statistical testing using logistic regression frameworks. Different frameworks are used to test for allele-specific junction usage in single samples and to test for event-specific dynamic allelic expression across multiple samples of the same individual.

==== RNA-seq alignment

Raw RNA sequencing reads were aligned to the hg38 reference genome using STAR @dobin2013.
For each sample, genotype information of the respective individual was provided through `--varVCFfile` and WASP mapping was enabled by setting `--waspOutputMode SAMtag`.
STAR output files were unsorted BAM files (`--outSAMtype BAM Unsorted`) and set to include the vA, vG and vW WASP tags (`--outSAMattributes NH HI AS nM MD vA vG vW`).
We subsequently sorted and indexed BAM files using samtools @li2009, and marked duplicate reads using picard.

==== SNPJunkie software package<methods_snpjunkie>

The SNPJunkie software package is a custom Rust binary that parses paired end STAR-WASP alignment BAM files that include the vA, vG and vW WASP mapping tags.
Briefly, its main runner executes the following steps:

1. Parse CLI arguments.
2. Initialize a BAM file reader.
3. Parse the BAM file's header.
4. Initialize a PairStream from the BAM reader, providing an iterator over the two mates of individual alignments.
5. Initialize the SNPJunkie structure to track results.
6. Run the main loop. It iterates over pairs of reads that are returned from the PairStream.
  1. Check if the read pair passes basic quality control and covers a valid junction.
  2. Check if the read pair passes WASP filters.
  3. Record the read pair's data to the SNPJunkie struct.
7. Annotate resulting counts with metadata (e.g. gene names if a VCF and/or GTF file was provided).
8. Write result tables to disk.

MIT-licensed source code will be provided upon publication of the manuscript.


==== Statistical testing

Statistical testing for allele-specific junction usage as well as dynamic event specific allelic imbalance was performed using a logistic regression framework.

For allele-specific junction usage, only events with at least 10 total counts were considered.
Each event read count was encoded individually based on whether it supports the reference ($1$) or alternative ($0$) allele.
We required at least one count for the reference and alternative alleles.
Event groups were assigned based on whether events shared their SNP and either a donor or acceptor splice site.
Reads' junctions were encoded numerically as integers between $1$ and the total number of events $n$, i.e., different junctions associated with the group's SNP that were part of the event group. 

For each group, we performed an F-test between the following two simple logistic regression models.
To account for overdispersion, we fit quasi-binomial logistic regression models.

$ H_0: "allele" ~ 1 $
$ H_1: "allele" ~ "event" $

To test for dynamic event-specific allelic imbalances, we adapted our logistic regression framework.
Dynamic testing was performed on a per-event per-individual basis.
Only events with at least 20 counts in at least 5 points in time were tested.
However, for each event we included not only this event's reads in the data, but all reads at the event's SNP.
Reads were individually encoded by their allelic identity as described above.
We additionally encoded whether a read at the SNP in question was part of the tested event ($1$) or not ($0$).
A read's point in time was encoded as a scaled value between $1$ and $8$.

For each event, we first tested whether a read's group (event vs non-event) allows predicting its allelic identity and ran a second, nested model only for events that passed a Bonferroni threshold of $0.05/("n tested events")$.
We next performed an F-test between the following two quasi-binomial logistic regression models, testing for whether a dynamic interaction term between group and time allows predicting the reads' allelic identities.
Resulting p-values were corrected for the number of tested events using the FDR correction method.

$ H_0: "allele" ~ "group" + "poly(time, 2)" $
$ H_1: "allele" ~ "group" + "poly(time, 2)" + "group:poly(time, 2)" $

=== Autoimmune disease risk genes

We downloaded data for 11 autoimmune diseases from the Open Targets Genetics @buniello2025 @ghoussaini2021a platform.
Gene sets for enrichment analyses were curated from the Open Targets L2G and Colocalisation analyses.
Enrichment analysis was performed by comparing the observed overlaps of ASJU genes and disease risk genes against at 1,000 null sets of N randomly selected genomic regions, N being the number of disease loci.

== Discussion

Here, we provide an in-depth characterization of alternative splicing and its genetic regulation CD4#super[+] T cell activation.
We find that alternative splicing is a pervasive mechanism in the T cell transcriptome after activation and that many genes central to T cell function are dynamically affected by differential splicing upon cell stimulation.
We further show that there is a transcriptome-wide increase in intron excision upon T cell activation and that differential splicing leads to a global reduction in transcript isoform diversity after activation.
Intron excision in T cell activation has been described previously and it has been hypothesized that it may act as a regulatory mechanism to increase the availability of mature mRNA transcripts and thereby support the coordination of efficient T cell responses @ni2016a.

To elucidate cell-state specific genetic regulation of alternative splicing responses, we develop a novel computational pipeline, termed SNPJunkie.
SNPJunkie enables the stratification of allelic counts by whether the supporting alignment stems from has been mapped to a specific exon-exon junction.
This novel approach allowed us to test for static allele-specific junction usage as well as dynamic event-specific allelic expression.
We showed that there is widespread evidence for ASJU in many genes central to T cell biology and that ASJU genes are enriched in autoimmune disease risk genes.
This novel computational approach has allowed us to identify disease-relevant events with allelic imbalance that would have been missed or de-prioritized by conventional allele-specific expression analyses.

Dynamic event-specific allelic expression was less widespread and mostly concentrated to the HLA region.
As, for genome-wide testing, we did not map reads to a high-resolution HLA-personalized genome, validation of this finding requires further investigation.


#bibliography(
  "20251218_report_v01.bib",
  style: "nature",
  title: "References",
)

#pagebreak()

= Publications

Journal articles as well as conference abstracts that result from the time of my funding from the BIF and the collaborations it enabled are listed below.

== Journal articles

*Hackert NS*\*, Radtke FA\*, Exner T\*, Lorenz HM, Müller-Tidow C, Nigrovic PA, Wabnitz G, Grieshaber-Bouyer R. Human and mouse neutrophils share core transcriptional programs in both homeostatic and inflamed contexts. _Nat Commun._ 2023 Dec 8;14(1):8133. doi: 10.1038/s41467-023-43573-9. PMID: 38065997; PMCID: PMC10709367.
\*equal contribitions

Kim T, Martínez-Bonet M, Wang Q, *Hackert N*, Sparks JA, Baglaenko Y, Koh B, Darbousset R, Laza-Briviesca R, Chen X, Aguiar VRC, Chiu DJ, Westra HJ, Gutierrez-Arcelus M, Weirauch MT, Raychaudhuri S, Rao DA, Nigrovic PA. Non-coding autoimmune risk variant defines role for ICOS in T peripheral helper cell development. _Nat Commun._ 2024 Mar 9;15(1):2150. doi: 10.1038/s41467-024-46457-8. PMID: 38459032; PMCID: PMC10923805.

Kilian M, Friedrich MJ, Lu KH, Vonhören D, Jansky S, Michel J, Keib A, Stange S, *Hackert N*, Kehl N, Hahn M, Habel A, Jung S, Jähne K, Sahm F, Betge J, Cerwenka A, Westermann F, Dreger P, Raab MS, Meindl-Beinker NM, Ebert M, Bunse L, Müller-Tidow C, Schmitt M, Platten M. The immunoglobulin superfamily ligand B7H6 subjects T cell responses to NK cell surveillance. _Sci Immunol._ 2024 May 3;9(95):eadj7970. doi: 10.1126/sciimmunol.adj7970. Epub 2024 May 3. PMID: 38701193.

Aguiar VRC, Franco ME, Aziz NA, Fernandez-Salinas D, Chiñas M, Colantuoni M, Xiao Q, *Hackert N*, Liao Y, Cervantes-Diaz R, Todd M, Wauford B, Wactor A, Prahalad V, Laza-Briviesca R, Darbousset R, Wang Q, Jenks S, Cashman KS, Zumaquero E, Zhu Z, Case J, Cejas P, Gomez M, Ainsworth H, Marion M, Benamar M, Lee P, Henderson L, Chang M, Wei K, Long H, Langefeld CD, Gewurz BE, Sanz I, Sparks JA, Meidan E, Nigrovic PA, Gutierrez-Arcelus M. A multi-omics resource of B cell activation reveals genetic mechanisms for immune-mediated diseases. _medRxiv_ [Preprint]. 2025 Jun 14:2025.05.22.25328104. doi: 10.1101/2025.05.22.25328104. PMID: 40475139; PMCID: PMC12140513.


== Conference contributions

*Hackert NS*, Radtke F, Exner T, Mueller-Tidow C, Lorenz HM, Nigrovic P, Wabnitz G, Grieshaber-Bouyer R. A Core Inflammation Program Conserved Across Human and Murine Neutrophils. American College of Rheumatology Convergence 2022; 10.–14. November 2022; Philadelphia, Pennsylvania. Abstract 1687. Online poster presentation

*Hackert NS*, Aguiar V, Grieshaber-Bouyer R, Gutierrez-Arcelus M. Alternative splicing dynamics and allele-specificity during T cell activation. American Society of Human Genetics Annual Meeting 2023; 1.–5. November 2023; Washington, D.C. Abstract 2023-A-2526-ASHG.
Platform presentation (328 out of 3,519 accepted abstracts)


= Key words

Autoimmune disease; immunology; T cells; splicing; functional genomics; genetic variation; allelic imbalance