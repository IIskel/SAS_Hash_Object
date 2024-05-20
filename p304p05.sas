**************************************************************;
*  LESSON 4, PRACTICE 5                                      *;
**************************************************************;

data work.storm_cat345_facts;
    if _N_=1 then do;  /* #we define hash object only once that means during the first iteration.*/
       if 0 then set pg3.storm_range; /*if 0 is always false so it will not execute, but it will help set the table compile time only*/
     declare hash Storm(dataset:'pg3.storm_range'); /*We initialize the hash table*/
       Storm.definekey('StartYear','Name','Basin');
       Storm.definedata('Wind1','Wind2','Wind3','Wind4');
       Storm.definedone(); 
       
     declare hash StormSort(ordered: 'descending', multidata: 'yes'); /*We are defining the new hash table we want to create, and the table 
     																will be in a descending oreder, aslo it support multiple unique ID */
    	StormSort.definekey('MaxWindMPH','Season', 'Name'); /*We are diefining Key value which decides the descending order*/
    	StormSort.definedata('Season', 'Name', 'Wind1', 'Wind2', 'Wind3', 'Wind4', 'MaxWindMPH'); /*Also this columns will be kept in the last table*/
    	StormSort.definedone();
    end;

    set pg3.storm_summary_cat345 end=last; /*This is the second table we are going to concatenate to define the new hash table*/
    if Storm.find(key:year(StartDate),key:Name,key:Basin)=0 then StormSort.add(); /* At this point we are searching for the
    											same value in the initial table to concatenate(i.e We need to look for the column which can help concatenation) 
    											and after we found the key for concatenation we will add the  mach to the hash table */
    if last=1 then StormSort.output(dataset: 'work.cat345_sort'); /*the when we reach the last row we need the table to be displayed 
    																so we push it to the output table*/
    keep Name Basin Wind1-Wind4 Season MaxWindMPH StartDate; 
run;

/* The following proc sort is the correct replica of what has been done above */

/* proc sort data=work.storm_cat345_facts */
/*           out=work.cat345_sort */
/*              (keep=Season Name Wind1-Wind4 MaxWindMPH); */
/*     by descending MaxWindMPH descending Season descending Name; */
/* run; */

title1 'Storm Statistics for Category 3, 4, and 5';
title2 'sorted by descending (MaxWindMPH, Season, and Name)';
proc print data=work.cat345_sort n;  
	where MaxWindMPH=173;
run;
title;