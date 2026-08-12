FIA-Post-Hurricane-Assessment
================
Ben Branoff & Andrés Baeza-Castro
2026-08-10

# FIA-Post-Hurricane-Assessment

Hurricane damage/loss estimates from collected plots after storms

Start by loading the plots from nims_srs_db. Here, using the DBI
library, which requires some initial setup for successful credentialed
connections to the db. Once setup, can connect to the “fiadb01p” data
base and access any tables you are authorized to access. Then, we can
use SQL queries passed as string arguments to retrieve the desired data.
Here we are asking for the Florida (132024, 132025) and Georgia (122024,
122025) evaluations since hurricane Helene. For now, we are only asking
for the plots, their conditions, and their associated strata variables.
Their trees and reference tables will be joined later.

``` r
library(DBI)
myconn <- dbConnect(odbc::odbc(), "fiadb01p", timeout = 10) # function change w/DBI
vars = paste0("select p.cn,p.prev_plt_cn,p.plot_status_cd,p.invyr,p.eval_grp,p.statecd,p.countycd,p.measyear,p.measmon,p.measday,p.lat,p.lon,",
                    "c.condid,c.cond_status_cd,c.owncd,c.fortypcd,c.condprop_unadj,c.prop_basis,",
              "ps.evalid,ps.estn_unit_cn,ps.adj_factor_macr,ps.adj_factor_subp,ps.expns,",
              "pps.stratum_cn ")
tabs = "from fs_nims_fiadb_srs.plotsnap p,fs_nims_fiadb_srs.cond c,fs_nims_fiadb_srs.pop_stratum ps,fs_nims_fiadb_srs.pop_plot_stratum_assgn pps "
filts = paste0("where p.eval_grp in (132024,122024,132025,122025) 
and ps.evalid in(122501,122401,132501,132401)
and c.plt_cn = p.cn
and pps.stratum_cn = ps.cn
and pps.plt_cn = p.cn
and c.cond_status_cd = 1 and c.condprop_unadj IS NOT NULL")
#and to_date(p.measyear || '-' || LPAD(p.measmon, 2, '0') || '-' || LPAD(p.measday, 2, '0')
#               default null on conversion error,
#               'YYYY-MM-DD') >= date '2024-09-26'") 
plots = dbGetQuery(myconn,paste0(vars,tabs,filts))
##  also, convert the plots to a spatial object
plots_geo <- st_as_sf(plots,coords=c("LON","LAT"),crs=4326)
plots
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">

<thead>

<tr>

<th style="text-align:right;">

X
</th>

<th style="text-align:right;">

CN
</th>

<th style="text-align:right;">

PREV_PLT_CN
</th>

<th style="text-align:right;">

PLOT_STATUS_CD
</th>

<th style="text-align:right;">

INVYR
</th>

<th style="text-align:right;">

EVAL_GRP
</th>

<th style="text-align:right;">

STATECD
</th>

<th style="text-align:right;">

COUNTYCD
</th>

<th style="text-align:right;">

MEASYEAR
</th>

<th style="text-align:right;">

MEASMON
</th>

<th style="text-align:right;">

MEASDAY
</th>

<th style="text-align:right;">

LAT
</th>

<th style="text-align:right;">

LON
</th>

<th style="text-align:right;">

CONDID
</th>

<th style="text-align:right;">

COND_STATUS_CD
</th>

<th style="text-align:right;">

OWNCD
</th>

<th style="text-align:right;">

FORTYPCD
</th>

<th style="text-align:right;">

CONDPROP_UNADJ
</th>

<th style="text-align:left;">

PROP_BASIS
</th>

<th style="text-align:right;">

EVALID
</th>

<th style="text-align:right;">

ESTN_UNIT_CN
</th>

<th style="text-align:right;">

ADJ_FACTOR_MACR
</th>

<th style="text-align:right;">

ADJ_FACTOR_SUBP
</th>

<th style="text-align:right;">

EXPNS
</th>

<th style="text-align:right;">

STRATUM_CN
</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1.682647e+15
</td>

<td style="text-align:right;">

7.185623e+14
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2025
</td>

<td style="text-align:right;">

132025
</td>

<td style="text-align:right;">

13
</td>

<td style="text-align:right;">

155
</td>

<td style="text-align:right;">

2025
</td>

<td style="text-align:right;">

11
</td>

<td style="text-align:right;">

7
</td>

<td style="text-align:right;">

31.59123
</td>

<td style="text-align:right;">

-83.06859
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

46
</td>

<td style="text-align:right;">

608
</td>

<td style="text-align:right;">

0.832980
</td>

<td style="text-align:left;">

SUBP
</td>

<td style="text-align:right;">

132501
</td>

<td style="text-align:right;">

1.99555e+15
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1.000000
</td>

<td style="text-align:right;">

6042.554
</td>

<td style="text-align:right;">

1.995523e+15
</td>

</tr>

<tr>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

1.682647e+15
</td>

<td style="text-align:right;">

7.185623e+14
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2025
</td>

<td style="text-align:right;">

132025
</td>

<td style="text-align:right;">

13
</td>

<td style="text-align:right;">

69
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

15
</td>

<td style="text-align:right;">

31.51980
</td>

<td style="text-align:right;">

-82.65338
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

46
</td>

<td style="text-align:right;">

161
</td>

<td style="text-align:right;">

0.816345
</td>

<td style="text-align:left;">

SUBP
</td>

<td style="text-align:right;">

132501
</td>

<td style="text-align:right;">

1.99555e+15
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1.000346
</td>

<td style="text-align:right;">

5798.479
</td>

<td style="text-align:right;">

1.995523e+15
</td>

</tr>

<tr>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

1.682647e+15
</td>

<td style="text-align:right;">

7.185616e+14
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2025
</td>

<td style="text-align:right;">

132025
</td>

<td style="text-align:right;">

13
</td>

<td style="text-align:right;">

255
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

26
</td>

<td style="text-align:right;">

33.29923
</td>

<td style="text-align:right;">

-84.16433
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

46
</td>

<td style="text-align:right;">

161
</td>

<td style="text-align:right;">

0.750000
</td>

<td style="text-align:left;">

SUBP
</td>

<td style="text-align:right;">

132501
</td>

<td style="text-align:right;">

1.99555e+15
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1.002237
</td>

<td style="text-align:right;">

6123.728
</td>

<td style="text-align:right;">

1.995523e+15
</td>

</tr>

<tr>

<td style="text-align:right;">

4
</td>

<td style="text-align:right;">

1.682647e+15
</td>

<td style="text-align:right;">

7.185623e+14
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2025
</td>

<td style="text-align:right;">

132025
</td>

<td style="text-align:right;">

13
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

12
</td>

<td style="text-align:right;">

31.27324
</td>

<td style="text-align:right;">

-82.74704
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

46
</td>

<td style="text-align:right;">

142
</td>

<td style="text-align:right;">

1.000000
</td>

<td style="text-align:left;">

SUBP
</td>

<td style="text-align:right;">

132501
</td>

<td style="text-align:right;">

1.99555e+15
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1.000346
</td>

<td style="text-align:right;">

5798.479
</td>

<td style="text-align:right;">

1.995523e+15
</td>

</tr>

<tr>

<td style="text-align:right;">

5
</td>

<td style="text-align:right;">

1.682647e+15
</td>

<td style="text-align:right;">

7.185618e+14
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2025
</td>

<td style="text-align:right;">

132025
</td>

<td style="text-align:right;">

13
</td>

<td style="text-align:right;">

35
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

24
</td>

<td style="text-align:right;">

33.33348
</td>

<td style="text-align:right;">

-83.93474
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

46
</td>

<td style="text-align:right;">

161
</td>

<td style="text-align:right;">

1.000000
</td>

<td style="text-align:left;">

SUBP
</td>

<td style="text-align:right;">

132501
</td>

<td style="text-align:right;">

1.99555e+15
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1.000934
</td>

<td style="text-align:right;">

5857.771
</td>

<td style="text-align:right;">

1.995523e+15
</td>

</tr>

<tr>

<td style="text-align:right;">

6
</td>

<td style="text-align:right;">

1.682647e+15
</td>

<td style="text-align:right;">

7.185618e+14
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

2025
</td>

<td style="text-align:right;">

132025
</td>

<td style="text-align:right;">

13
</td>

<td style="text-align:right;">

105
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

25
</td>

<td style="text-align:right;">

34.05846
</td>

<td style="text-align:right;">

-82.81808
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

46
</td>

<td style="text-align:right;">

508
</td>

<td style="text-align:right;">

1.000000
</td>

<td style="text-align:left;">

SUBP
</td>

<td style="text-align:right;">

132501
</td>

<td style="text-align:right;">

1.99555e+15
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1.001336
</td>

<td style="text-align:right;">

5872.472
</td>

<td style="text-align:right;">

1.995523e+15
</td>

</tr>

</tbody>

</table>

</div>

The above is a small subset, but there are around 8000 plots that have
been collected since the storm in Georgia and Florida.

Now, use the Cyclones package to recreate the winds for Helene and
create wind intensity zones. For now, Cyclones is only available on
Github, so an extra package (“remotes”) is required to install it. For
this workflow, the hurricane wind information is provided as part of the
download and there is no need to recalculate, but the process is
demonstrated anyways.

To download the hurricane data, as well as some other spatial boundary
files of the USA and counties:

``` r
HeleneStuff <- readRDS(gzcon(url("https://github.com/BBranoff/FIA-Post-Hurricane-Assessment/raw/refs/heads/main/data/Helene.RDS")))
Helene <- HeleneStuff$storm
Helene_extents <- HeleneStuff$extent
Helene_winds <- lapply(HeleneStuff$winds,unwrap)
usa <- rnaturalearth::ne_countries(country="united states of america",scale=10)
counties <- read_sf("/vsizip//vsicurl/https://naciscdn.org/naturalearth/10m/cultural/ne_10m_admin_2_counties.zip",
                        layer = "ne_10m_admin_2_counties")
```

Below demonstrates how the above hurricane data was obtained. First the
Cyclones package is downloaded and installed and it is used to ingest
the necessary data and process into the wind fields we need.  
First, download the package and get the storm track information. This is
the foundation for being able to retrieve the winds (and rain and storm
surge).

``` r
##  install
install.packages('remotes')
remotes::install_github("BBranoff/Cyclones")
library(Cyclones)
library(terra)
library(sf)
library(dplyr)
##  get the storm information
Helene <- get_storms(name="HELENE",season=2024)
Helene
```

Now, calculate the wind field. Here we just use a theoretical (Boose)
equation based on the maximum wind speed. We calculate the wind onto a
grid with a spatial resolution of 5km.

``` r
###  first, interpolate the spatial wind information to every 30 mins
Helene_extents <- make_extents(Helene,t_res=30)
###  then interpolate spatially as a raster
Helene_winds <- get_wind(Helene_extents,method="Boose",agg=TRUE,s_res=5000)
###  classify the maximum wind speed into the Saffir-Simpson scale
Helene_Cat <- as.factor(classify(Helene_winds$boose$max_msw,
                       matrix(c(0,33,0,
                                33,43,1,
                                43,50,2,
                                50,60,3,
                                60,70,4,
                                70,Inf,5),ncol=3,byrow=TRUE),include.lowest=TRUE))
plot(Helene_Cat)
plot(st_geometry(st_transform(usa,crs(Helene_Cat))),add=TRUE)
```

<figure>
<img src="README_files/figure-gfm/winds-hidden-1.png"
alt="Fig 1. Hurricane Helene’s wind field, categorized into intensity zones." />
<figcaption aria-hidden="true">Fig 1. Hurricane Helene’s wind field,
categorized into intensity zones.</figcaption>
</figure>

The Helene hurricane data is now processed and ready for overlays with
the plots.

With the hurricane intensity areas defined, we can assign them to each
plot. We also need to define the area of each wind zone. These will be
our artificial ‘strata’, and we will need to know the total area in
order to calculate the expansion factors.

``` r
###  first, mask out the areas outside of our interest
###  for now, this can just be the plots
###  but this probably needs to be 'forested' areas
Helene_Cat_plots <- trim(mask(Helene_Cat,st_transform(st_as_sf(st_concave_hull(st_union(plots_geo),ratio=0.001)),crs(Helene_Cat))))
##  now calculate area of each wind zone
##  important to do this while the raster is in projected, not geographic, coordinates
##  also important to do by state, as this is how the evaluation is done
Areas12 <- table(values(mask(Helene_Cat_plots,st_transform(counties|>filter(REGION_COD==12),crs(Helene_Cat_plots)))))
Areas13 <- table(values(mask(Helene_Cat_plots,st_transform(counties|>filter(REGION_COD==13),crs(Helene_Cat_plots)))))
Areas <- rbind(data.frame(Areas12)|>mutate(STATECD=12),
               data.frame(Areas13)|>mutate(STATECD=13))
##  this is the number of pixels of each wind zone
##  multiply by the raster resolution to get the area, in square meters
Areas$Freq <- Areas$Freq*res(Helene_Cat_plots )[1]*res(Helene_Cat_plots )[2]
##  then convert to acres
Areas$Acres <- Areas$Freq/4046.86

###  project onto geographic coordinates
Helene_Cat_plots <- project(Helene_Cat_plots,"epsg:4326")
plot(Helene_Cat_plots)
###  overlay the plots
plot(st_geometry(st_as_sf(plots_geo,coords=c("LON","LAT"),crs=4326)),add=TRUE,pch=19,cex=0.01)
plot(st_geometry(usa),add=TRUE,border="darkgrey")
plot(st_geometry(counties),add=TRUE,border="darkgrey")
```

<figure>
<img src="README_files/figure-gfm/extract-1.png"
alt="Fig 2. Hurricane Helene’s wind zones with the plots overlayed. Plots are assigned their respective wind zones and their expansion factors come from the total area of each wind zone divided by the number of plots in each zone." />
<figcaption aria-hidden="true">Fig 2. Hurricane Helene’s wind zones with
the plots overlayed. Plots are assigned their respective wind zones and
their expansion factors come from the total area of each wind zone
divided by the number of plots in each zone.</figcaption>
</figure>

We now have the plots and the areas associated with each wind zone. From
here, we can begin to assemble the necessary tables and calculate the
desired estimates.

Beginning with assembling the necessary tables. Forested area is likely
the most straight forward. We will get the forested acreage of each plot
and, using a custom expansion factor, estimate the total forested
acreage in each wind zone.

First, we need some helper functions to compare our estimates with
‘official’ numbers from FIA. We use the FIA EVALIDATOR API to do this.
These functions are provided here by following the below steps, but they
are taken directly from the [FIA EVALIDATOR API
instructions](https://apps.fs.usda.gov/fiadb-api/).

Now, extract the wind zones at each plot, calculate the new expansion
factor based on the area of each strata (wind zone) and then compute the
forested area for each zone.

As a proof of concept, we use the original expansion factor (EXPNS) and
sum everything within an EVAL_GRP. This should be equivalent to what is
computed by EVALIDATOR. To check, we use the API to retrieve the
EVALIDATOR estimate and compare it to ours. They are identical, meaning
we are calculating correctly for a full evaluation. We then try the same
calculation using EXPNS_new to estimate the areas for the custom wind
zones.

``` r
###  first, join the total 'strata' (wind zone) areas to the plot table
plots_geo$WindZone <- extract(Helene_Cat_plots,plots_geo)$max_msw
plots_geo<- plots_geo |>
  left_join(Areas,by=join_by(WindZone==Var1,STATECD))|>
  group_by(WindZone)|>
  mutate(EXPNS_new = Acres/length(unique(CN)))

##  first testing the concept on the full evaluation with the original expansion factors
ForestedAcres <- plots_geo |>
  mutate(ForestedAcres = if_else(PROP_BASIS=="MACR",
                                 CONDPROP_UNADJ*ADJ_FACTOR_MACR,CONDPROP_UNADJ*ADJ_FACTOR_SUBP))|>
  filter(EVALID %in% c(122401,132401),EVAL_GRP %in% c(122024,132024))|>
  group_by(EVAL_GRP)|>
  summarise(ForestedAcres=sum(ForestedAcres*EXPNS))|>
  st_drop_geometry()
###  our custom estimate versus EVALIDATOR
ForestedAcres |>
  mutate(EVALIDATORacres = as.numeric(c(fiadb_api_GET(url="https://apps.fs.usda.gov/fiadb-api/fullreport?snum=02&wc=122024&outputFormat=NJSON")$totals$ESTIMATE,
                             fiadb_api_GET(url="https://apps.fs.usda.gov/fiadb-api/fullreport?snum=02&wc=132024&outputFormat=NJSON")$totals$ESTIMATE)))
```

    ## # A tibble: 2 × 3
    ##   EVAL_GRP ForestedAcres EVALIDATORacres
    ##      <int>         <dbl>           <dbl>
    ## 1   122024     16679484.       16679484.
    ## 2   132024     24088910.       24088910.

From the above, the DIY ad-hoc estimate matches the total forested acres
for these two evaluations from EVALIDATOR. To apply it to our custom
stata (wind zones), we only need to change the EXPNS from the full
evaluation tables to our custom EXPNS_new that we calculated based on
the calculated area of the strata and the number of plots in each
strata.

We also add in the common request that this be done by county and by
forest type, although we limit the forest type to only the most common
requested types.

``` r
##  first testing the concept on the full evaluation with the original expansion factors
HeleneAcres <- plots_geo |>st_drop_geometry()|>
  mutate(ForestedAcres = if_else(PROP_BASIS=="MACR",
                                 CONDPROP_UNADJ*ADJ_FACTOR_MACR,CONDPROP_UNADJ*ADJ_FACTOR_SUBP))|>
  #filter(EVALID %in% c(122401,132401),EVAL_GRP %in% c(122024,132024),
  #       (FORTYPCD>=140&FORTYPCD<=150)|(FORTYPCD>=160&FORTYPCD<=170)|(FORTYPCD>=400&FORTYPCD<=500)|(FORTYPCD>=970&FORTYPCD<=980))|>  #limit to common forest types
    mutate(FORTYP = if_else(FORTYPCD>=140&FORTYPCD<=150,"longleaf/slash pine",
                          if_else(FORTYPCD>=160&FORTYPCD<=170,"loblolly/shortleaf pine",
                                  if_else(FORTYPCD>=400&FORTYPCD<=500,"oak/pine",
                                          if_else(FORTYPCD>=970&FORTYPCD<=980,"woodland hardwoods","all others")))))|>
  left_join(counties|>filter(REGION_COD %in% c(12,13))|>mutate(COUNTYCD=as.numeric(substr(CODE_LOCAL,3,6)),
                                                               REGION_COD=as.numeric(REGION_COD))|>
              select(NAME,REGION_COD,COUNTYCD)|>rename(County=NAME),by=join_by(STATECD==REGION_COD,COUNTYCD))
  
HeleneAcres <- rbind(HeleneAcres,
                     HeleneAcres|>mutate(FORTYP="All",County="All"),
                     HeleneAcres|>mutate(FORTYP="All"),
                     HeleneAcres|>mutate(County="All"))|>
  group_by(STATECD,EVAL_GRP,FORTYP,County,WindZone)|>
  summarise(nplots=length(unique(CN)),
            ForestedAcres=sum(ForestedAcres*EXPNS_new))
  
HeleneAcres|>
  filter(EVAL_GRP%in% c(122024,132024),FORTYP=="All",County=="All")|>
  group_by(EVAL_GRP) |>
  summarise(ForestedAcres=sum(ForestedAcres,na.rm=TRUE))|>
  mutate(EVALIDATORSacres = as.numeric(c(fiadb_api_GET(url="https://apps.fs.usda.gov/fiadb-api/fullreport?snum=02&wc=122024&outputFormat=NJSON")$totals$ESTIMATE,
                                                                                                                                                                                        fiadb_api_GET(url="https://apps.fs.usda.gov/fiadb-api/fullreport?snum=02&wc=132024&outputFormat=NJSON")$totals$ESTIMATE)))
```

    ## # A tibble: 2 × 3
    ##   EVAL_GRP ForestedAcres EVALIDATORSacres
    ##      <int>         <dbl>            <dbl>
    ## 1   122024     15534634.        16679484.
    ## 2   132024     27123515.        24088910.

These estimates are close to the totals from EVALIDATOR but a little
off. This is probably because we are using the total area of the strata
to calculate the expansion factor instead of using only the forested
area inside the strata (?).

To do tree level estimates (volume, biomass, etc.) we need the tree
tables as well as the GRM tables to back-calculate mortality volume or
biomass for when the tree died.

first the GRM, as this is probably the most complex.

``` r
library(DBI)
myconn <- dbConnect(odbc::odbc(), "fiadb01p", timeout = 10) # function change w/DBI

sql <- "select SUM(GRM.TPAMORT_UNADJ) as estimatedvalue from (select * from fs_nims_fiadb_srs.pop_stratum t where evalid = 132503) POP_STRATUM join (select stratum_cn, count(cn) as p2pointcnt_sy from fs_nims_fiadb_srs.POP_PLOT_STRATUM_ASSGN t where evalid = 132503 and invyr = 2025 group by stratum_cn) PPSA on cn = PPSA.stratum_cn join (select * from fs_nims_fiadb_srs.POP_ESTN_UNIT t where evalid = 132503) PEU on PEU.CN = POP_STRATUM.ESTN_UNIT_CN join fs_nims_fiadb_srs.POP_PLOT_STRATUM_ASSGN POP_PLOT_STRATUM_ASSGN ON (POP_PLOT_STRATUM_ASSGN.STRATUM_CN = POP_STRATUM.CN) JOIN fs_nims_fiadb_srs.plotsnap PLOT ON (POP_PLOT_STRATUM_ASSGN.PLT_CN = PLOT.CN) JOIN fs_nims_fiadb_srs.COND COND ON (COND.PLT_CN = PLOT.CN) JOIN (SELECT P.PREV_PLT_CN, T.* FROM fs_nims_fiadb_srs.plotsnap P JOIN fs_nims_fiadb_srs.TREE_VW T ON (P.CN = T.PLT_CN)) TREE ON ((TREE.CONDID = COND.CONDID) AND (TREE.PLT_CN = COND.PLT_CN)) LEFT OUTER JOIN fs_nims_fiadb_srs.plotsnap PPLOT ON (PLOT.PREV_PLT_CN = PPLOT.CN) LEFT OUTER JOIN fs_nims_fiadb_srs.COND PCOND ON ((TREE.PREVCOND = PCOND.CONDID) AND (TREE.PREV_PLT_CN = PCOND.PLT_CN)) LEFT OUTER JOIN fs_nims_fiadb_srs.TREE_VW PTREE ON (TREE.PREV_TRE_CN = PTREE.CN) LEFT OUTER JOIN fs_nims_fiadb_srs.TREE_GRM_BEGIN TRE_BEGIN ON (TREE.CN = TRE_BEGIN.TRE_CN) LEFT OUTER JOIN fs_nims_fiadb_srs.TREE_GRM_MIDPT TRE_MIDPT ON (TREE.CN = TRE_MIDPT.TRE_CN) LEFT OUTER JOIN (SELECT TRE_CN,DIA_BEGIN,DIA_MIDPT,DIA_END,MICR_COMPONENT_AL_TIMBER AS COMPONENT,MICR_SUBPTYP_GRM_AL_TIMBER AS SUBPTYP_GRM,MICR_TPAMORT_UNADJ_AL_TIMBER AS TPAMORT_UNADJ FROM fs_nims_fiadb_srs.TREE_GRM_COMPONENT) GRM ON (TREE.CN = GRM.TRE_CN) JOIN fs_nims_fiadb_srs.REF_SPECIES ON (TREE.SPCD = REF_SPECIES.SPCD) WHERE REF_SPECIES.WOODLAND = 'N' AND POP_PLOT_STRATUM_ASSGN.Invyr = 2025"

sql <- "select sum(POP_STRATUM.EXPNS) as estimatedvalue from (select * from fs_nims_fiadb_srs.pop_stratum t where evalid = 132503) POP_STRATUM"
test <- dbGetQuery(myconn,sql)


JOIN FS_nims_srs.REF_SPECIES
ON (TREE.SPCD = REF_SPECIES.SPCD)
WHERE REF_SPECIES.WOODLAND = 'N'
AND POP_PLOT_STRATUM_ASSGN.Invyr = 2025
AND 1 = 1
"





trees <- dbGetQuery(myconn,"select t.*,p.* from fs_nims_fiadb_srs.tree_vw t,fs_nims_fiadb_srs.plotsnap p where p.cn=t.plt_cn and p.eval_grp in (122024,132024,122025,132025)")
#write.csv(trees,"E:/OneDrive - USDA/Hurricanes/Followup Assessment/plotsHelene.csv")
trees <- read.csv("E:/OneDrive - USDA/Hurricanes/Followup Assessment/plotsHelene.csv")
trees <- dbGetQuery(myconn,"select * from fs_nims_fiadb_srs.pop_stratum ps where evalid in (132503,122503)") |>
  left_join(dbGetQuery(myconn,"select * from fs_nims_fiadb_srs.pop_plot_stratum_assgn where evalid in (122503,132503) and invyr=2025")|>
              group_by(STRATUM_CN)|>
              mutate(p2pointcnt_sy=length(unique(CN))),by=join_by(CN==STRATUM_CN)) |>
  left_join(dbGetQuery(myconn,"select * from fs_nims_fiadb_srs.pop_estn_unit where evalid in (122503,132503)"),by=join_by(ESTN_UNIT_CN==CN))|>
  left_join(plots|>mutate(CN=as.character(CN)),by=join_by(PLT_CN==CN))|>
  left_join(dbGetQuery(myconn,"select * from fs_nims_fiadb_srs.tree_vw where statecd in (12,13) and invyr=2025"),by=join_by(PLT_CN,CONDID))
trees <- trees |>
  left_join(plot,by=join_by(PREV_PLOT_CN==PLT_CN))


JOIN FS_nims_srs.NIMS_COND_VW COND
ON (COND.PLT_CN = PLOT.CN)
JOIN (SELECT P.PREV_PLT_CN, T.*
        FROM FS_nims_srs.NIMS_PLOT_VW P
      JOIN FS_nims_srs.NIMS_TREE_VW T
      ON (P.CN = T.PLT_CN)) TREE
ON ((TREE.CONDID = COND.CONDID) AND (TREE.PLT_CN = COND.PLT_CN))
###  same as
#pop_plot_stratum_assgn2 = dbGetQuery(myconn,"select * from fs_nims_fiadb_srs.pop_plot_stratum_assgn where evalid=132503 and invyr=2025")|>
# group_by(STRATUM_CN)|>
#  summarise(p2pointcnt_sy=length(unique(CN)))
ppsa <- pop_stratum |>
  left_join(pop_plot_stratum_assgn,by=join_by(CN==STRATUM_CN))
peu <- dbGetQuery(myconn,"select * from fs_nims_fiadb_srs.pop_estn_unit where evalid = 132503")


vars = paste0("select p.cn,p.plot_status_cd,p.invyr,p.eval_grp,p.statecd,p.countycd,p.measyear,p.measmon,p.measday,p.lat,p.lon,",
                    "c.condid,c.cond_status_cd,c.owncd,c.fortypcd,c.condprop_unadj,c.prop_basis,",
              "ps.evalid,ps.estn_unit_cn,ps.adj_factor_macr,ps.adj_factor_subp,ps.expns,",
              "pps.stratum_cn ")
tabs = "from fs_nims_srs.nims_pop_stratum ps, fs_nims_srs.pop_plot_stratum_assgn pps  fs_nims_srs.nims_plot_vw pplot,,fs_nims_srs.nims_tree_vw ptree,fs_nims_srs.nims_tree_grm_begin tre_begin,fs_nims_srs.nims_tree_grm_midpt tre_midpt,  "
filts = paste0("where p.eval_grp in (132024,122024,132025,122025) 
and ps.evalid in(122501,122401,132501,132401)
and c.plt_cn = p.cn
and pps.stratum_cn = ps.cn
and pps.plt_cn = p.cn
and c.cond_status_cd = 1 and c.condprop_unadj IS NOT NULL")

plots = dbGetQuery(myconn,paste0(vars,tabs,filts))
plots
```
