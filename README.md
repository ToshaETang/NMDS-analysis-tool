# NMDS-analysis-tool

Use it online：https://toshatang.shinyapps.io/NMDS_analysis_tool/  
Download it to local PC：https://github.com/ToshaETang/NMDS-analysis-tool/tree/main/NMDS_analysis_tool  

---------------  

## WHAT IS NMDS  
NMDS stands for Non-metric Multidimensional Scaling. It's a method used in statistics and data analysis to visualize the similarities or dissimilarities among a set of objects.  

In NMDS analysis, a dissimilarity matrix is computed based on the pairwise dissimilarities between objects (e.g., species compositions in ecological studies, or any other kind of data where distances or dissimilarities can be computed). NMDS then finds a low-dimensional representation of the data, typically in two or three dimensions, while preserving the original dissimilarities as much as possible.  

This low-dimensional representation can then be visualized using scatterplots or other graphical methods, allowing analysts to explore the underlying structure of the data and identify patterns or clusters. NMDS is especially useful when the data cannot be easily represented in a Euclidean space, or when the relationships between objects are non-linear or complex.  

------------  

## USER GUIDE
### DATA PREPROCESSING

![CSV](https://github.com/ToshaETang/NMDS-analysis-tool/blob/main/picture/CSV.png)   

**1. Choose the CSV file you want to process.**  
   ![CSV_input_file_form](https://github.com/ToshaETang/NMDS-analysis-tool/blob/main/picture/CSV_input_file_form.png)  
   The file should look like this form.  
   
**3. Choose the variables in the flie you want to do NMDS analysis.**  
**4. Make sure the file content is correct.**  
**5. Download the binary matrix file. (It will be used at the NMDS analysis)**  
   ![CSV_binary_matrix](https://github.com/ToshaETang/NMDS-analysis-tool/blob/main/picture/CSV_binary_matrix.png)    
   You will get the binary matrix file which looks like this.   
   If two variables correspond, the field will be 1; otherwise, it will be 0.  

### NMDS ANALYSIS  
If you wish, this feature can be used independently.  
![NMDS](https://github.com/ToshaETang/NMDS-analysis-tool/blob/main/picture/NMDS.png)  
**1. Choose the binary matrix file.**  
You can use the feature above to make binary matrix file or use your own file.  
Remember the binary matrix file should look like this.  
![CSV_binary_matrix](https://github.com/ToshaETang/NMDS-analysis-tool/blob/main/picture/CSV_binary_matrix.png)    

**2. See the NMDS result.**  

------------  
## TRY YOURSELF  
1. Download the example file at **NMDS_analysis_tool/tryThisData.csv**
2. Choose **area** as variable_1 and **species** variable_2.  
