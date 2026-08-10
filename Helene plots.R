library(DBI)
myconn <- dbConnect(odbc::odbc(), "fiadb01p", timeout = 10) # function change w/DBI
vars_plots = paste0("select p.cn,p.plot_status_cd,p.invyr,p.eval_grp,p.measyear,p.measmon,p.measday,p.lat,p.lon,",#p.expcurr,p.adj_expcurr,p.adj_expvol_subp,p.adj_expvol_micr,p.macro_breakpoint_dia,",
                    "c.condid,c.cond_status_cd,c.owncd,c.fortypcd,",#c.condprop_unadj,c.prop_basis,c.alstkcd,",
                    #"p.cn,p.statecd,",#ps.expns,ps.adj_factor_macr,ps.adj_factor_subp,ps.adj_factor_micr,ps.rscd,pps.stratum_cn,pps.plt_cn,",
                    "sds.actual_lat,sds.actual_lon,t.plt_cn,t.mortyr,t.agentcd ")
tabs_plots = "from fs_nims_fiadb_srs.plotsnap p,fs_nims_fiadb_srs.cond c,fs_nims_fiadb_srs.sds_plot sds,fs_nims_fiadb_srs.tree t "#,fs_fiadb.pop_plot_stratum_assgn pps "
filts_plots = paste0("where p.eval_grp in (132024,122024,372024,452024,472024) and c.plt_cn = p.cn and sds.plt_cn = p.cn and t.plt_cn = p.cn ") #ps.cn = pps.stratum_cn and p.cn = pps.plt_cn 
plots_2024 = dbGetQuery(myconn,paste0(vars_plots,tabs_plots,filts_plots))
filts_plots = paste0("where p.eval_grp = in (132025,122025,372025,452025,472025) and c.plt_cn = p.cn and sds.plt_cn = p.cn and t.plt_cn = p.cn ") #ps.cn = pps.stratum_cn and p.cn = pps.plt_cn 
plots_2025 = dbGetQuery(myconn,paste0(vars_plots,tabs_plots,filts_plots))



#####  storm files 
library(dplyr)
library(sf)
library(terra)
swath <- rast("I:/Cyclone Products/Wind/v2/2024268N17278.tif")$MaxVel
swath_df<- as.data.frame(project(swath,"epsg:4326"),xy=TRUE)
precip <- rast("I:/Cyclone Products/Precip/v1/2024268N17278MSWEP.tif")
precip_df<- as.data.frame(project(precip,"epsg:4326"),xy=TRUE)
precip <- project(precip,crs(swath))
counties <- read_sf("E:/OneDrive - USDA/Hurricanes/Rapid Assessment/Shiny App/Spatial Data/ne_10m_admin_2_counties.shp")

ggplot(data=swath_df) +
  geom_raster(aes(x=x,y=y,fill=MaxVel))+
  scale_fill_gradientn(name="Wind Vel.\n(knots)",
    colours = c("black","lightgreen","#44AA99","#DDCC77","#CC6677","#882255"),
    values = scales::rescale(c(0,64, 83, 96, 113,137)), # breakpoints in data space
    limits = c(0, 150))+
  geom_sf(data=counties|>filter(REGION_COD %in% c(13)),fill=NA)+
  scale_x_continuous(limits = c(-86,-80.8),n.breaks=4)+
  ylim(30,35.5)+
  theme_void()+
  theme(legend.position = "bottom")
ggplot(data=swath_df|>mutate(MaxVel=if_else(MaxVel>=137,5,
                                            if_else(MaxVel>=113,4,
                                                    if_else(MaxVel>=96,3,
                                                            if_else(MaxVel>=83,2,
                                                                    if_else(MaxVel>=64,1,0))))))) +
  geom_raster(aes(x=x,y=y,fill=factor(MaxVel)))+
  scale_fill_manual(values=c(NA,"lightgreen","#44AA99","#DDCC77","#CC6677","#882255"),name="Wind Vel.\nCat.")+
  geom_sf(data=counties|>filter(REGION_COD %in% c(13)),fill=NA)+
  scale_x_continuous(limits = c(-86,-80.8),n.breaks=4)+
  ylim(30,35.5)+
  theme_void()+
  theme(legend.position = "bottom")

ggplot(data=precip_df|>mutate(SumPrecip=sum_prestorm2d+sum_storm)) +
  geom_raster(aes(x=x,y=y,fill=SumPrecip))+
  geom_sf(data=counties|>filter(REGION_COD %in% c(13)),fill=NA,col="grey")+
  scale_x_continuous(limits = c(-86,-80.8),n.breaks=4)+
  ylim(30,35.5)+
  theme_void()+
  guides(fill=guide_legend(title="Tot. Precip.\n(mm)"))+
  theme(legend.position = "bottom")

ggplot(data=precip_df|>mutate(SumPrecip=sum_prestorm2d+sum_storm,
                              SumPrecip=if_else(SumPrecip>=750,5,
                                             if_else(SumPrecip>=589,4,
                                                     if_else(SumPrecip>=426,3,
                                                             if_else(SumPrecip>=263,2,
                                                                     if_else(SumPrecip>=100,1,0))))))) +
  geom_raster(aes(x=x,y=y,fill=factor(SumPrecip)))+
  geom_sf(data=counties|>filter(REGION_COD %in% c(13)),fill=NA,col="grey")+
  scale_fill_manual(values=c("#132B43","#336A98","#56B1F7"),name="Tot. Precip.\nCat.")+
  scale_x_continuous(limits = c(-86,-80.8),n.breaks=4)+
  ylim(30,35.5)+
  theme_void()+
  theme(legend.position = "bottom")
  


GAtrees_agg <- rbind(plots_2024,plots_2025) %>%
  group_by(PLT_CN,EVAL_GRP) %>%
  summarise(TotTrees=n(),
            Totmort=100*sum(MORTYR>=2024,na.rm=TRUE)/(n()),
            WeatherMort=100*sum(MORTYR>=2024&AGENTCD==50,na.rm=TRUE)/n())

GAplots <- rbind(plots_2024,plots_2025)  %>%
  mutate(MEASDAY=if_else(is.na(MEASDAY),1,MEASDAY),
         measdate = as.Date(paste(MEASYEAR,MEASMON,MEASDAY,sep="-"),"%Y-%m-%d"))%>%
  filter(measdate>as.Date("2024-09-26")) %>%
  st_as_sf(coords=c("LON","LAT"), crs=4326,remove=FALSE) %>%
  st_transform(crs(swath))%>%
  #left_join(NCcond %>% select(PLT_CN,CONDID,DSTRBCD1,DSTRBYR1),by=join_by(CN==PLT_CN)) %>%
  #mutate(WeatherDSTRB = if_else(DSTRBCD1 %in% c(50,52,53) &DSTRBYR1>=2024,1,0)) %>%
  left_join(GAtrees_agg,by=join_by(CN==PLT_CN,EVAL_GRP==EVAL_GRP))

ggplot(GAplots|>filter(MEASYEAR>=2024)|>distinct(geometry,.keep_all = TRUE))+
  geom_sf(aes(col=factor(MEASYEAR)))+
  geom_sf(data=counties|>filter(REGION_COD==13))+
  theme_void()+
  facet_wrap(~EVAL_GRP)
  


plot(focal(rasterize(vect(GAplots|>filter(EVAL_GRP=="132024")|>distinct(geometry,.keep_all = TRUE)),crop(swath$MaxVel,GAplots),field="WeatherMort"),
           w=3,fun=function(x,na.rm=TRUE){mean(x,na.rm=na.rm)}),col=viridis::turbo(n=15),main="2024 Weather Mortality, %",axes=FALSE)
plot(focal(rasterize(vect(GAplots|>filter(EVAL_GRP=="132025")|>distinct(geometry,.keep_all = TRUE)),crop(swath$MaxVel,GAplots),field="WeatherMort"),
           w=3,fun=function(x,na.rm=TRUE){mean(x,na.rm=na.rm)}),col=viridis::turbo(n=15),main="2025 Weather Mortality, %",axes=FALSE)
plot(focal(rasterize(vect(GAplots|>distinct(geometry,.keep_all = TRUE)),crop(swath$MaxVel,GAplots),field="WeatherMort"),
           w=3,fun=function(x,na.rm=TRUE){mean(x,na.rm=na.rm)}),col=viridis::turbo(n=15),main="2024 & 2025 Weather Mortality, %",axes=FALSE)
plot(st_geometry(st_transform(counties,st_crs(GAplots))),add=TRUE)

plot(crop(swath,GAplots),main="Max. Winds, kts",axes=FALSE)
plot(st_geometry(GAplots),add=TRUE)  
plot(st_geometry(state),add=TRUE)

plot(crop(precip$sum_prestorm2d+precip$sum_storm,GAplots)*0.03937,main="Cum. Rain, in",axes=FALSE)
plot(st_geometry(GAplots),add=TRUE)  
plot(st_geometry(state),add=TRUE)

####  Evalidator API
source("E:/OneDrive - USDA/FIA Data/API funs.R", echo = TRUE)
mortnum = 574157 # Average annual mortality of sound bole wood volume of trees (timber species at least 5 inches d.b.h.), in cubic feet, on forest land
volnum = 574171 # Sound bole wood volume of live trees (timber species at least 5 inches d.b.h.), in cubic feet, on forest land
#EVALurl = "https://dev.wrk.fs.usda.gov/fiadb-api/fullreport" 
EVALurl = "https://apps.fs.usda.gov/fiadb-api/fullreport"
argList_mort <-list(snum = mortnum,cselected='Cause of death',rselected="County code and name",
               wc = 132024, pselected='Inventory year',
               outputFormat = 'NJSON')
argList_tot <-list(snum = volnum,cselected='Cause of death',rselected="County code and name",
                    wc = 132024, pselected='Inventory year',
                    outputFormat = 'NJSON')
FIAAPI_mort = fiadb_api_POST( EVALurl , argList_mort)
FIAAPI_tot = fiadb_api_POST( EVALurl , argList_tot)

estimates_mort <- bind_rows(FIAAPI_mort$estimates %>% mutate(variable="Average annual mortality"),
                       FIAAPI_mort$subtotals %>% 
                         mutate(across(c(ESTIMATE,PLOT_COUNT,VARIANCE,SE,SE_PERCENT),as.numeric),
                                variable="Average annual mortality") %>%
                         tidyr::unnest(c(GRP1,GRP2,GRP3)),
                       FIAAPI_mort$totals %>% mutate(variable="Average annual mortality") %>%
                         mutate(GRP1="All",GRP2="All",GRP3="All",table="totals",
                                across(c(ESTIMATE,PLOT_COUNT,VARIANCE,SE,SE_PERCENT),as.numeric)))
estimates_mort <- estimates_mort %>%select(-c(group,req)) %>%
  mutate(GRP3CD = as.numeric(gsub("([0-9]+).*$|`", "\\1",GRP3)),
         GRP3 = gsub('\\` ','',gsub('[[:digit:]]+', '', GRP3)),
         COUNTYCD =as.numeric(gsub("([0-9]+).*$|`", "\\1",GRP2)),
         GRP2=gsub('\\` ','',gsub('[[:digit:]]+', '', GRP2)),
         GRP2=gsub("GA ","", GRP2),
         GRP1=sapply(strsplit(GRP1," "),"[",2))%>%
  rename(COUNTY=GRP2,AGENT=GRP3,AGENTCD=GRP3CD,INVYR=GRP1)
###  now total volume
estimates_tot <- bind_rows(FIAAPI_tot$estimates %>% mutate(variable="Total Volume"),
                            FIAAPI_tot$subtotals %>% 
                              mutate(across(c(ESTIMATE,PLOT_COUNT,VARIANCE,SE,SE_PERCENT),as.numeric),
                                     variable="Total Volume") %>%
                              tidyr::unnest(c(GRP1,GRP2,GRP3)),
                            FIAAPI_tot$totals %>% mutate(variable="Total Volume") %>%
                              mutate(GRP1="All",GRP2="All",GRP3="All",table="totals",
                                     across(c(ESTIMATE,PLOT_COUNT,VARIANCE,SE,SE_PERCENT),as.numeric)))
estimates_tot <- estimates_tot %>%select(-c(group,req,GRP3)) %>%
  mutate(COUNTYCD =as.numeric(gsub("([0-9]+).*$|`", "\\1",GRP2)),
         GRP2=gsub('\\` ','',gsub('[[:digit:]]+', '', GRP2)),
         GRP2=gsub("GA ","", GRP2),
         GRP1=sapply(strsplit(GRP1," "),"[",2))%>%
  rename(COUNTY=GRP2,INVYR=GRP1)



estimates_mort <- estimates_mort |>
  left_join(estimates_tot|>filter(is.na(table))|>select(EVAL_GRP,INVYR,COUNTY,ESTIMATE)|>rename(ESTIMATE_TOT=ESTIMATE),by=join_by(EVAL_GRP,INVYR,COUNTY))|>
  mutate(ESTIMATE_PERC = round(100*ESTIMATE/ESTIMATE_TOT,1))|>
  left_join(counties|>select(CODE_LOCAL,geometry)|>mutate(CODE_LOCAL=as.numeric(CODE_LOCAL)),by=join_by(COUNTYCD==CODE_LOCAL))|>
  st_as_sf()
library(ggplot2)
estimates_mort |>
  filter(AGENT=="Weather",is.na(table),INVYR==2024)|>
  ggplot()+
  geom_sf(aes(fill=ESTIMATE))+
  facet_wrap(~INVYR)+
  scale_fill_gradientn(
    colours = c("black","lightgreen","#44AA99","#DDCC77","#CC6677","#882255"),
    values = scales::rescale(c(0, 2e6, 3e6, 5e6,7e6)), 
    limits = c(0, 2e6))+
  theme_void()
### as a percent
estimates_mort |>
  filter(AGENT=="Weather",is.na(table),INVYR==2024)|>
  ggplot()+
  geom_sf(aes(fill=ESTIMATE_PERC))+
  facet_wrap(~INVYR)+
  scale_fill_gradientn(
    colours = c("black","lightgreen","#44AA99","#DDCC77","#CC6677","#882255"),
    values = scales::rescale(c(0, 1, 2, 3,4)), 
    limits = c(0, 5))+
  theme_void()




Table1 <-  FIAAPI %>% ungroup() %>%
  mutate(
    WindZone=windzone,#substr(windzone,nchar(windzone),nchar(windzone)),
    RainZone=rainzone,#substr(rainzone,nchar(rainzone),nchar(rainzone)),
    SurgeZone=surgezone,#substr(surgezone,nchar(surgezone),nchar(surgezone)),
    Type= if_else(variable%in% c("TimberlandAcreage","ForestAcreage"),FORTYP,SPGRP),
    across(c(ESTIMATE,VARIANCE,PLOT_COUNT,SE,SE_PERCENT),as.numeric))%>%#,
  #ESTIMATE=if_else(variable%in% c("TimberlandAcreage","ForestAcreage"),ESTIMATE/1000,ESTIMATE/1000000),
  #VARIANCE=if_else(variable%in% c("TimberlandAcreage","ForestAcreage"),(sqrt(VARIANCE)/1000)^2,(sqrt(VARIANCE)/1000000)^2),
  #County=NAME) %>%
  select(variable,extent,STATECD,COUNTYCD,dT,Type,WindZone,RainZone,SurgeZone,DSTRB.AGENT,EVAL_GRP,PLOT_COUNT,ESTIMATE,VARIANCE,SE,SE_PERCENT,CNs,table) %>%
  mutate(SID=storm,
         season  =season)%>%
  filter(PLOT_COUNT>0)




#####  from the public warehouse files
GAplots <- read.csv("E:/OneDrive - USDA/FIA Data/GA_PLOTSNAP.csv")
GAtrees <- read.csv("E:/OneDrive - USDA/FIA Data/GA_TREE.csv")
GAcond <- read.csv("E:/OneDrive - USDA/FIA Data/GA_COND.csv")
state <- read_sf("E:/OneDrive - USDA/Hurricanes/Rapid Assessment/Shiny App/Spatial Data/ne_10m_admin_1_states_provinces.shp")%>%
  filter(adm0_a3=="USA",postal %in% c("NC","SC","TN","GA","VA","AL","FL")) %>%
  st_transform(crs(swath))
GAtrees_agg <- GAtrees %>%
  filter(PLT_CN %in% plots_2024$CN) %>%
  group_by(PLT_CN) %>%
  summarise(TotTrees=n(),
            Totmort=100*sum(MORTYR>=2024,na.rm=TRUE)/(n()),
            WeatherMort=100*sum(MORTYR>=2024&AGENTCD==50,na.rm=TRUE)/n())
GAplots <- plots_2024  %>%
  mutate(MEASDAY=if_else(is.na(MEASDAY),1,MEASDAY),
         measdate = as.Date(paste(MEASYEAR,MEASMON,MEASDAY,sep="-"),"%Y-%m-%d"))%>%
  filter(measdate>as.Date("2024-09-26")) %>%
  st_as_sf(coords=c("LON","LAT"), crs=4326,remove=FALSE) %>%
  st_transform(crs(swath))%>%
  #left_join(NCcond %>% select(PLT_CN,CONDID,DSTRBCD1,DSTRBYR1),by=join_by(CN==PLT_CN)) %>%
  #mutate(WeatherDSTRB = if_else(DSTRBCD1 %in% c(50,52,53) &DSTRBYR1>=2024,1,0)) %>%
  select(CN,LON,LAT,measdate) %>%
  left_join(GAtrees_agg,by=join_by(CN==PLT_CN)) 
  #mutate(color=colorRampPalette(turbo(n = 15))(n())[rank(WindMort)])
WNCplots <- NCplots %>% filter(UNITCD %in% c(3,4))
WNCplots %>% ungroup() %>% st_union %>% st_convex_hull()%>%st_area()

write.csv(st_drop_geometry(NCplots),"PrelimFIApostHeleneplots.csv",row.names=FALSE)

par(mfrow=c(3,1))
plot(crop(swath$MaxVel,NCplots),main="Max. Winds, kts",axes=FALSE)
plot(st_geometry(NCplots),add=TRUE)  
plot(st_geometry(state),add=TRUE)

plot(crop(precip$sum_prestorm2d+precip$sum_storm,NCplots)*0.03937,main="Cum. Rain, in",axes=FALSE)
plot(st_geometry(NCplots),add=TRUE)  
plot(st_geometry(state),add=TRUE)

plot(focal(rasterize(vect(NCplots),crop(swath$MaxVel,NCplots),field="WeatherMort"),
           w=3,fun=function(x,na.rm=TRUE){mean(x,na.rm=na.rm)}),col=viridis::turbo(n=15),main="Weather Mortality, %",axes=FALSE)
plot(st_geometry(state),add=TRUE)

