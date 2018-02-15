#### Clear Workspace
rm(list = ls())

library(ggplot2)
library(dplyr)
library(readr)
library(gridExtra)
library(alluvial)
library(waffle)
library(extrafont)
setwd("C:\\Users\\piyus\\Desktop\\Work\\MS\\Sem 3\\Data Visualization\\Project")
loan <- read_csv("final_loan.csv")

#### Variation of Interest Rate with Grade
ggplot(data=loan, aes(grade, int_rate)) + geom_boxplot(aes(fill=grade)) +
  theme(axis.text.x = element_blank()) +
  labs(list(title = "Interest Rate Variation with Grade",x = "Grade",y = "Interest Rate", fill = "Grade"))

#### Variation of Interest Rate with Sub Grade
ggplot(data=loan, aes(sub_grade, int_rate)) + geom_boxplot(aes(fill=sub_grade)) +
  theme(axis.text.x = element_blank()) +
  labs(list(title = "Interest Rate by Sub Grade",x = "Interest Rate",y = "Sub Grade", fill = "Sub Grade"))

#### Variation of Interest Rate with Delinquent occurences in credit file for the past 2 years
ggplot(data=loan, aes(delinq_2yrs,int_rate)) + geom_boxplot(aes(fill=delinq_2yrs,group=delinq_2yrs)) +
  theme(axis.text.x = element_blank()) +
  labs(list(title = "Interest Rate by Delinquent Incidences",x = "Delinquent Incidences",y = "Interest Rate", fill ="Delinquent Incidence"))

#### Variation of Interest Rate with Log of Annual Income
ggplot(loan, aes(int_rate,log(annual_inc))) + geom_hex() +
  labs(list(title = "Annual Income (log) variation with Interest Rate",x = "Interest Rate",y = "Log of Annual Income", fill = "Log(Annual Income)"))

loan$emp_length[loan$emp_length == '10+ years'] <- '>10 years'
loan$emp_length[loan$emp_length == 'n/a'] <- '>10 years'
loan$emp_length[loan$emp_length == '>10 years'] <- '> 10 years'
#### Variation of Interest Rate with Employment Length
ggplot(data=loan, aes(emp_length, int_rate)) + geom_boxplot(aes(fill=emp_length)) +
  theme(axis.text.x = element_blank()) +
    labs(list(title = "Interest Rate Variation with Employment Length",x = "Employment Length",y = "Interest Rate", fill = "Employment Length"))

#### Variation of Interest Rate with Purpose
ggplot(data=loan, aes(purpose, int_rate)) + geom_boxplot(aes(fill=purpose)) +
  theme(axis.text.x = element_blank()) +
  labs(list(title = "Interest Rate Variation with Purpose",x = "Purpose",y = "Interest Rate",fill = "Purpose"))