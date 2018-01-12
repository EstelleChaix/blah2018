#!/bin/bash
#Treatment of manual annotation data file 
#Remove unreleavant data and unrelevant relations
cut -f 8,13,18 data_set/manualexportnormalized.txt | grep -P -v '\t\t|\t$' | grep -v -P 'Comparison|Encodes' > processed_data/manualgeneinteraction.txt
sed -i -e "s/Conditional_//g" processed_data/manualgeneinteraction.txt
#Unique link only, and unidirectional for relation "interact with" and "Binds_To" (Arg1 < Arg2)
awk -F "\t" '{print$0"\t""Manual";}' processed_data/manualgeneinteraction.txt | awk '{if((($1=="Interacts_With")||($1=="Binds\_To"))&&($2>$3))printf($1"\t"$3"\t"$2"\t"$4"\n"); else printf ($0"\n")}'  | sort -u > processed_data/unidirectional_uniq_manual.txt
wc -l processed_data/unidirectional_uniq_manual.txt 
#To build the network use: unidirectional_uniq_manual.txt
#
#Treatment of automatic annotation data file
cut -f 6,5,9 data_set/blahautomatic.txt | uniq | awk -F "\t" '{print$2"\t"$1"\t"$3"\t""Automatic";}' > processed_data/uniq_automatic.txt
#Change the name of the relation
sed -i -e "s/Interaction/Interacts\_With/g" processed_data/uniq_automatic.txt
awk '{if ($3>$2) printf ($0"\n"); else printf($1"\t"$3"\t"$2"\t""Automatic""\n")}' processed_data/uniq_automatic.txt | sort -u > processed_data/unidirectional_uniq_automatic.txt
wc -l processed_data/unidirectional_uniq_automatic.txt
#To build the network use: unidirectional_uniq_automatic.txt
#
#Treatment of exterior database file: BIOGRID , previously add on data_set repository by yourself
cut -f 6,7 data_set/BIOGRID-ORGANISM-Arabidopsis_thaliana_Columbia-3.4.156.tab2.txt | awk '{if ($2>$1) printf("Interacts\_With""\t"$0"\t""Biogrid""\n"); else printf("Interacts\_With""\t"$2"\t"$1"\t""Biogrid""\n")}' | sort -u > processed_data/biogrid.txt 
wc -l processed_data/biogrid.txt
