# Install all required packages
ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])] 
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE) 
  sapply(pkg, require, character.only = TRUE)}

packages <- c('olsrr', 'caret', 'leaps','MASS','tidyverse', 'ggplot2', 'car', 'rstatix') 
ipak(packages)

install.packages("onewaytests")
library(onewaytests)
library(ggplot2)
library(cowplot)
library(tidyverse)
library(olsrr)
library(caret)
library(leaps)
library(MASS)
library(car)
library(rstatix)
library(stats)
library(easypackages)
libraries("psych","car","agricolae","tidyverse","knitr")
libraries("lsr","rstatix","emmeans","multcomp","multcompView")
libraries("kableExtra","gtsummary","lindia","broom")

getwd()

df <- read.csv("./other-llms-ents-density-len-v1.csv")
df

# pre-requisite testing before running ANOVA
# treatment levels: gpt, gemini, llama (models)
# blocks: 1, 2, 3, 4, 5 (iterations, not our main interest)

for (itr_value in 1:5) {
  itr_df <- df %>% filter(itr == itr_value)
  
  t_levels <- unique(itr_df$model)
  
  cat("\n\n\n************************Iteration:", itr_value, "*********************************\n")
  
  # 1. Normality test for "ents", "density" columns
  # within each treatment level (models)
  for (level in t_levels) {
    level_df <- itr_df %>% filter(model == level)
    print(level)
    print(nrow(level_df))
    
    
    normality_res <- shapiro.test(level_df$ents)
    if (normality_res$p.value < 0.05){
      cat(paste("[NORMALITY VIOLATION - entity] Model:", level, "- p-value:", round(normality_res$p.value, 4), "\n"))
    }
    
    print("-----normality test completed for entity-----")
    
    normality_res <- shapiro.test(level_df$density)
    if (normality_res$p.value < 0.05){
      cat(paste("[NORMALITY VIOLATION - density] Model:", level, "- p-value:", round(normality_res$p.value, 4), "\n"))
    }
    
    print("-----normality test completed for density-----")
  }
 
  
  # 2. test for homogeneous variance between levels (models) of this iteration
  # for "ents", "density" columns
  # itr_df <- itr_df %>% filter(!is.na(ents))
  itr_df$model <- as.factor(itr_df$model)
  
  levene_result <- leveneTest(ents ~ model, data = itr_df)
  if(levene_result$`Pr(>F)`[1] < 0.05){
    print("[HOMOGENOUS VARIANCE VIOLATION - entity] p-value:")
    print(level)
    print(levene_result)
  }
  
  print("-----homogeneous variance test completed for entity-----")
  
  levene_result <- leveneTest(density ~ model, data = itr_df)
  if(levene_result$`Pr(>F)`[1] < 0.05){
    print("[HOMOGENOUS VARIANCE VIOLATION - density] p-value:")
    print(levene_result)
  }
  
  print("-----homogeneous variance test completed for density-----")
  
  #View(itr_df)
  print("check for missing values in the dataframe:")
  print(sum(is.na(itr_df)))
  
  # 3. Welch's ANOVA test (assuming unequal variances) for "ents" , "density" columns for this iteration
  # previously used `aov` assuming homogeneous variance
  aov_res = oneway.test(ents ~ model, data=itr_df, var.equal = FALSE)
  print("....Welch's ANOVA for ents: ")
  print(aov_res)
  
  aov_summary <- summary(aov_res)
  print("\tANOVA summary")
  print(aov_summary)
  
  #p_value <- aov_summary[[1]]$`Pr(>F)`[1]
  #if(p_value < 0.05){
  #  print(paste("[SIGNIFICANT DIFF - entity] p-value: " , p_value))
  #}
  
  # Welch's ANOVA test (assuming unequal variances)
  # previously `aov`
  aov_res = oneway.test(density ~ model, data=itr_df, var.equal = FALSE)
  print("....Welch's ANOVA for density: ")
  print(aov_res)
  
  aov_summary <- summary(aov_res)
  print("\tANOVA summary")
  print(aov_summary)
  
  #p_value <- aov_summary[[1]]$`Pr(>F)`[1]
  #if(p_value < 0.05){
  #  print(paste("[SIGNIFICANT DIFF - density] p-value: " , p_value))
  #}
  
  # Pairwise t-tests with Welch's Correction adjusted for unequal variances 
  #pairwise_res = itr_df%>% pairwise_t_test(density ~ model,  pool.sd = FALSE, p.adjust.method = "bonferroni")
  #print(pairwise_res)
  
  # 4. Post Hoc Analysis using Games Howell test for "ents" , "density" columns for this iteration
  # better than pairwise (since pairwise is more conservative)
  # this method works for unequal variances and unqueal sample sizes (still robust on equal samples sizes)
  post_res = games_howell_test(ents ~ model, data = itr_df)
  print("----Post Hoc test for entity----")
  print(post_res)

  post_res = games_howell_test(density ~ model, data = itr_df)
  print("----Post Hoc test for density----")
  print(post_res)  
}


#test_df = df %>% filter(itr == 5)
#test_df <- test_df %>% filter(!is.na(ents))
#test_df$model <- as.factor(test_df$model)
#levene_result <- leveneTest(ents ~ model, data = test_df)
#print(levene_result)


#aov_res = aov(ents ~ model, data=test_df)
#print(aov_res)
#summary(aov_res)




