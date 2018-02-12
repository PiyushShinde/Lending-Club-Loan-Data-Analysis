library(sqldf)
library(ggplot2)
library(broom)

loan_small<-loan[,c("member_id","issue_d","id")]

loan_small$issue_d_ym <- format(as.Date(loan_small$issue_d), "%Y-%m")
loan_small$issue_d_year <- format(as.Date(loan_small$issue_d), "%Y")
loan_small$issue_d_month <- format(as.Date(loan_small$issue_d), "%m")

df.temp <- sqldf("select issue_d_ym,issue_d_year,issue_d_month, count(distinct id) as no_apps from loan_small group by issue_d_ym,issue_d_year,issue_d_month")

ts = ts(data=df.temp$no_apps, start = c(2007,6), frequency = 12)

df = data.frame(cnt_customers=as.matrix(ts),yearmonth=time(ts))

ggplot(df, aes(y=cnt_customers, x=yearmonth)) + geom_point() + geom_line() + geom_smooth(method.args=list(degree=2)) + ylab("Number of applications") + xlab("Year")
 

df.lo = loess(cnt_customers~yearmonth, degree=2, data=df)
df.lo.df = augment(df.lo)

ggplot(df.lo.df, aes(x=yearmonth, y=.resid)) + geom_point() + geom_line()

ts.stl = stl(ts,s.window=12, s.degree=1)
year.cut = cut_number(time(ts),n=5)
ts.df2 = data.frame(yearmonth=time(ts),ts.stl$time.series,year.cut)
ggplot(ts.df2, aes(x=yearmonth, y=seasonal)) + geom_line() + facet_wrap(~year.cut, ncol=1, scales="free_x") + ylab("Number of Applications") + xlab("Year")
monthplot(ts.stl,choice = "seasonal")

ggplot(df.temp,aes(issue_d_year,log(no_apps))) + geom_boxplot()

ggplot(df.temp,aes(issue_d_month,log(no_apps))) + geom_boxplot()
ggplot(df.temp[which(df.temp$issue_d_year==2007),],aes(issue_d_month,no_apps)) + geom_boxplot()
ggplot(df.temp[which(df.temp$issue_d_year==2008),],aes(issue_d_month,no_apps)) + geom_boxplot()
#ggplot(df.temp,aes(issue_d_month,no_apps)) + geom_boxplot()

lst = as.numeric(loan$tot_cur_bal)
hist(lst)
summary(lst)
boxplot(lst)
