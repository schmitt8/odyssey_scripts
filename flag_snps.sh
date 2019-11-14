#!/bin/sh
 
#SBATCH -p test
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem-per-cpu 8000
#SBATCH -t 0-01:00:00
#SBATCH -J flag_snps
#SBATCH -o flag_snps_%j.out
#SBATCH -e flag_snps_%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=schmitt@fas.harvard.edu # Email to which notifications will be sent






module load centos6/0.0.1-fasrc01
module load java/1.8.0_45-fasrc01

GATK_HOME=/n/home12/schmitt/gatk-4.1.3.0/

$GATK_HOME/gatk --list




$GATK_HOME/gatk VariantFiltration --java-options "-Xmx8g -XX:ParallelGCThreads=1" \
-V  Hsup_unfiltered_snps.vcf.gz \
--filter-expression "vc.hasAttribute('DP') && DP/38 > 11" \
--filter-name "MaxCoverage" \
--filter-expression "vc.hasAttribute('DP') && DP/38 < 5" \
--filter-name "MinCoverage" \
--filter-expression "QD < 2.0" \
--filter-name "QD2" \
--filter-expression "QUAL < 30.0" \
--filter-name "QUAL30" \
--filter-expression "SOR > 3.0" \
--filter-name "SOR3" \
--filter-expression "FS > 60.0" \
--filter-name "FS60" \
--filter-expression "MQ < 40.0" \
--filter-name "MQ40" \
--filter-expression "MQRankSum < -12.5" \
--filter-name "MQRankSum-12.5" \
--filter-expression "ReadPosRankSum < -8.0" \
--filter-name "ReadPosRankSum-8" \
-O Hsup_flagged_snps.vcf.gz
