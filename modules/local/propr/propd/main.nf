process PROPR_PROPD {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/mulled-v2-401a215d4024df776a98d90a352048199e342a3d:5ba9bbf6cd4f4f98983526673c223d2e7d829b36-0':
        'biocontainers/mulled-v2-401a215d4024df776a98d90a352048199e342a3d:5ba9bbf6cd4f4f98983526673c223d2e7d829b36-0' }"

    input:
    tuple val(meta), path(count), path(samplesheet), val(contrast_variable), val(reference), val(target)

    output:
    tuple val(meta), path("*.propd.rds")                 , emit: rds
    tuple val(meta), path("*.propd.results.tsv")         , emit: results
    tuple val(meta), path("*.propd.results_filtered.tsv"), emit: results_filtered, optional: true
    tuple val(meta), path("*.propd.adjacency.csv")       , emit: adjacency       , optional: true
    tuple val(meta), path("*.propd.connectivity.tsv")    , emit: connectivity    , optional: true
    tuple val(meta), path("*.propd.hub_genes.tsv")       , emit: hub_genes       , optional: true
    tuple val(meta), path("*.propd.fdr.tsv")             , emit: fdr             , optional: true
    path "*.warnings.log"                                , emit: warnings
    path "*.R_sessionInfo.log"                           , emit: session_info
    path "versions.yml"                                  , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    template 'propd.R'
}
