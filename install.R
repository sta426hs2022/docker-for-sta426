#install.packages("BiocManager", quiet=TRUE)
#BiocManager::install(version='3.14', update=TRUE, ask=FALSE, quiet=TRUE)

#if(BiocManager::version() != '3.14') { 
#  BiocManager::install(version='3.14', update=TRUE, ask=FALSE, quiet=TRUE)
#}

#BiocManager::install('remotes', quiet=TRUE)
#Sys.setenv(R_REMOTES_NO_ERRORS_FROM_WARNINGS='true')
#BiocManager::install('png', update=TRUE, ask=FALSE, quiet=TRUE)

pkgs <- c("dplyr", "ggplot2", "tidyr", "remotes", "limma", "edgeR",
          "S4Vectors", "DRIMSeq", "SingleCellExperiment", "tximeta", 
          "msigdbr", "rmarkdown")

#pkgs <- c("dplyr", "ggplot2", "tidyr", "limma", "edgeR",
#          "S4Vectors", "DRIMSeq", "SingleCellExperiment", "tximeta", "msigdbr")
#          "rprojroot", "pheatmap",
#          "Rsubread", "BSgenome.Scerevisiae.UCSC.sacCer3", "TxDb.Scerevisiae.UCSC.sacCer3.sgdGene",
#          "affy", "preprocessCore",
#          "pasilla", "DEXSeq",
#          "Rtsne", "uwot","muscat",
#          "SummarizedExperiment", "flowCore", "CATALYST", "diffcyt", "FlowSOM",
#          "DNAcopy", "BayesPeak", "GenomicRanges",
#          "Seurat", "DropletUtils", "rmarkdown", "tinytex")

ap.db <- available.packages(contrib.url(BiocManager::repositories()))
ap <- rownames(ap.db)
fnd <- pkgs %in% ap
pkgs_to_install <- pkgs[fnd]

ok <- BiocManager::install(pkgs_to_install, update=FALSE, ask=FALSE, quiet=TRUE) %in% rownames(installed.packages())
