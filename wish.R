require(plyr)
require(ggplot2)
require(scales)
require(ggthemes)

theme_set(theme_tufte())
theme_update(axis.text=element_text(family='Heiti SC Light', size=8),title=element_text(family='Heiti SC Light'), legend.text=element_text(family='Heiti SC Light'), strip.text=element_text(family='Heiti SC Light'))

#user_id of 11-15
user.ids<-unique(subset(daelog, time>as.POSIXct("2013-11-15 14:40:00") & time<as.POSIXct("2013-11-15 23:59:59"))$user_id)

#read applog
applog<-read.table("~/Desktop/temp/temp.all", fill=T, strip.white=T, as.is=T, sep="\t", col.names=1:6)
names(applog)<-c("time","user_id","event","d1","d2","d3")
applog<-subset(applog, user_id %in% user.ids)
applog<-mutate(applog, 
               time=as.POSIXct(time),
               date=as.Date(time, tz="UTC-8"))


#read daelog
daelog<-read.table("~/Desktop/temp/dae_access.log.all", fill=T, strip.white=T, as.is=T, sep="\t")
names(daelog)<-c("time", "user_id", "category")
daelog<-subset(daelog, user_id %in% user.ids)
daelog<-mutate(daelog, 
               time=as.POSIXct(time, format="%d/%b/%Y:%H:%M:%S"),
               date=as.Date(time, tz="UTC-8"))

#daily categroy view
cate.view.count<-function(){
  tlog<-subset(daelog, category!="None")
  tlog<-ddply(tlog, .(date, user_id), summarize, cate.count=length(unique(category)))
  tlog<-ddply(tlog, .(date, cate.count), summarize, user.count=length(unique(user_id)))
}




