library(readxl)
library(ggplot2)
library(cowplot)
library(maps)
library(sqldf)
library(fiftystater)
library(mapproj)
library(hexbin)
loanf <- read_excel("loanf.xlsx")
loanf<-subset(loanf,annual_inc>0)
hist(loanf$int_rate)

ggplot(data=loanf,aes(int_rate)) + geom_histogram(bins=20) + xlab("Interest Rate") + facet_wrap(~loanf$grade)

ggplot(data=loanf,aes(int_rate)) + geom_histogram(bins=20) + xlab("Interest Rate") + facet_wrap(~loanf$term) 

ggplot(data=loanf,aes(group=int_rate)) + geom_boxplot()

ggplot(data=loanf,aes(x=grade,y=loanf$loan_amnt,col=term)) + geom_boxplot() + ylab("Interest rate") + xlab("Credit grade")

loanf20.high <- subset(loanf,int_rate>20)
loanf20.low <- subset(loanf,int_rate<=20)

ggplot(loanf,aes(addr_state,int_rate)) + geom_boxplot()

ggplot(loanf,aes(addr_state)) + geom_bar() + geom_boxplot(aes(y=int_rate/0.0005)) + scale_y_continuous(sec.axis = sec_axis(~.*0.0005, name = "Interest rate")) + ylab("Number of applications") + xlab("State")

ggplot(loanf,aes(addr_state)) + geom_bar() + scale_y_log10()

ggplot(data=loanf,aes(x=int_rate)) + geom_histogram(bins=20) + xlab("Interest Rate") + facet_wrap(~loanf$term)

p1 = ggplot(loanf,aes(x=int_rate)) + 
  geom_histogram(data=subset(loanf,int_rate<=20 & term == "36 months"),aes(x=int_rate),fill="#588c7e",bins=15) + 
  geom_histogram(data=subset(loanf,int_rate>20 & term == "36 months"),aes(x=int_rate),fill="#8c4646",bins=15) +
  xlab("Interest rate") + ylab("Frequency") + ggtitle("Loan with a 36 months term")

p2 = ggplot(loanf,aes(x=int_rate)) + 
  geom_histogram(data=subset(loanf,int_rate<=20 & term == "60 months"),aes(x=int_rate),fill="#588c7e",bins=15) + 
  geom_histogram(data=subset(loanf,int_rate>20 & term == "60 months"),aes(x=int_rate),fill="#8c4646",bins=15) + 
  xlab("Interest rate") + ylab("Frequency") + ggtitle("Loans with a 60 months term")

plot_grid(p1,p2)

loanf$intcat<-cut(loanf$int_rate,seq(0,30,6),labels=c(1:5))
loanf$intcat<-cut(loanf$int_rate,seq(0,30,3))
#loanf$intcat[is.na(loanf$intcat)]<-1
ggplot(loanf,aes(x=funded_amnt,fill=intcat)) + geom_histogram(bins=20) + facet_wrap(~grade, scales = "free_y")
ggplot(data=loanf,aes(x=intcat,y=loanf$annual_inc)) + geom_boxplot() + ylab("Loan Amount") + xlab("Interest Rate")

min(log(loanf$annual_inc))
loanf$salcat<-cut(log(loanf$annual_inc),seq(7,17,2))
loanf$salcat<-cut(log(loanf$annual_inc),seq(7,18,2),labels=c(1:5))
View(map.df)


ggplot(map.df, aes(map_id = state, label=state)) + 
  # map points to the fifty_states shape data
  geom_map(aes(fill = log(apps)), map = fifty_states) + 
  expand_limits(x = fifty_states$long, y = fifty_states$lat) +
  coord_map() +
  scale_x_continuous(breaks = NULL) + 
  scale_y_continuous(breaks = NULL) +
  labs(x = "", y = "") +
  theme(legend.position = "bottom", legend.key.width=unit(2,"cm"),
        panel.background = element_blank())

mapdf=map.df
map.df2 = sqldf("select a.*, b.population from mapdf as a, uspop as b where a.state=b.state")
map.df2$apr = map.df2$apps / map.df2$population
map.df2$aprl = log(map.df2$apr)

all_states <- map_data("state")
map.df2$region = map.df2$state
total <- merge(all_states,map.df2,by="region")
head(total)
total <- total[total$region!="district of columbia",]
map.lables = sqldf("select state_abb, avg(long) as long, avg(lat) as lat from total group by state_abb")
p <- ggplot()
p <- p + geom_polygon(data=total, aes(x=long, y=lat, group = group, fill=total$aprl),colour="white"
) + scale_fill_continuous(low = "thistle2", high = "darkred", guide="colorbar")
P1 <- p + theme_bw()  + labs(fill = "Log(Number of loan applications/population)" 
                             ,title = "Loan applications distribution across states", x="", y="")
P2<-P1 + scale_y_continuous(breaks=c()) + scale_x_continuous(breaks=c()) + theme(panel.border =  element_blank())
P2 + geom_text(data = map.lables,aes(long, lat, label=state_abb))
write.csv(map.lables,"lable_map.csv")

df3 = sqldf("select loan_status, grade, count(distinct member_id) as apps from loanf group by loan_status, grade")

ggplot(loanf,aes(log(annual_inc),log(loan_amnt),col=intcat)) + geom_point() + geom_jitter()

ggplot(data=loanf, aes(member_id)) + 
  geom_histogram( bins=20,aes(fill=..count..)) +
  scale_fill_gradient("Count", low = "#9ab5f9", high = "black") + facet_wrap(~intcat, scales = "free_y")

loanf.gip=subset(loanf,purpose!="educational"&purpose!="renewable_energy"&purpose!="wedding"&purpose!="house"&purpose!="vacation")
ggplot(loanf.gip,aes(grade)) + geom_bar(aes(fill=intcat)) + facet_wrap(~purpose, scales = "free_y") + xlab("Credit grade") + ylab("Number of applications(Free y scale)")
ggplot(loanf.gip,aes(salcat)) + geom_bar(aes(fill=grade))

ggplot(loanf,aes(intcat, installment,col=term)) + geom_boxplot(outlier.shape=NA)

hbin <- hexbin(loanf$loan_amnt,loanf$installment,xbins=20)
hbin <- hexbin(loanf$loan_amnt,loanf$installment)
plot(hbin)

hbin <- hexbin(log(loanf$annual_inc),loanf$int_rate)
plot(hbin)

hbin <- hexbin(log(loanf$annual_inc),log(loanf$loan_amnt))
plot(hbin)


ggplot(loanf, aes(y=annual_inc,x=intcat)) + geom_boxplot()


ggplot(loanf,aes(log(annual_inc),log(loan_amnt))) + geom_hex()

write.csv(total,"total.csv")
