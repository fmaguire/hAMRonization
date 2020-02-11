rule run_rgi:
    input:
        contigs = lambda wildcards: _get_seq(wildcards, 'assembly'),
    output:
        report = "results/{sample}/rgi/rgi.json"
    message: "Running rule run_rgi on {wildcards.sample} with contigs"
    log:
       "logs/rgi_{sample}.log"
    conda:
      "../envs/rgi.yaml"
    threads:
       config["params"]["threads"]
    params:
        output_prefix = "results/{sample}/rgi/rgi",
        gene_db = config["params"]["rgi"]["gene_db"]
    shell:
       """
       rgi load --card_json {params.gene_db}
       rgi main --input_sequence {input.contigs} --output_file {params.output_prefix} --clean --num_threads {threads} 2> >(tee {log} >&2)
       """
