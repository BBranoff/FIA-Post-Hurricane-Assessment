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
vars = paste0("select p.cn,p.plot_status_cd,p.invyr,p.eval_grp,p.measyear,p.measmon,p.measday,p.lat,p.lon,",
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

PLOT_STATUS_CD
</th>

<th style="text-align:right;">

INVYR
</th>

<th style="text-align:right;">

EVAL_GRP
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

1
</td>

<td style="text-align:right;">

2025
</td>

<td style="text-align:right;">

132025
</td>

<td style="text-align:right;">

2025
</td>

<td style="text-align:right;">

10
</td>

<td style="text-align:right;">

27
</td>

<td style="text-align:right;">

32.00675
</td>

<td style="text-align:right;">

-82.74630
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

602
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

2
</td>

<td style="text-align:right;">

1.682647e+15
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

2025
</td>

<td style="text-align:right;">

7
</td>

<td style="text-align:right;">

25
</td>

<td style="text-align:right;">

31.35273
</td>

<td style="text-align:right;">

-83.00512
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

1
</td>

<td style="text-align:right;">

2025
</td>

<td style="text-align:right;">

132025
</td>

<td style="text-align:right;">

2025
</td>

<td style="text-align:right;">

7
</td>

<td style="text-align:right;">

25
</td>

<td style="text-align:right;">

31.35273
</td>

<td style="text-align:right;">

-83.00512
</td>

<td style="text-align:right;">

2
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

0.250000
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

4
</td>

<td style="text-align:right;">

1.682647e+15
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

2026
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

13
</td>

<td style="text-align:right;">

31.58309
</td>

<td style="text-align:right;">

-82.77409
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

0.500000
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

1.001100
</td>

<td style="text-align:right;">

6032.520
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

1
</td>

<td style="text-align:right;">

2025
</td>

<td style="text-align:right;">

132025
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

28
</td>

<td style="text-align:right;">

33.77128
</td>

<td style="text-align:right;">

-83.06053
</td>

<td style="text-align:right;">

2
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

46
</td>

<td style="text-align:right;">

999
</td>

<td style="text-align:right;">

0.250000
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

<tr>

<td style="text-align:right;">

6
</td>

<td style="text-align:right;">

1.682647e+15
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

2025
</td>

<td style="text-align:right;">

11
</td>

<td style="text-align:right;">

6
</td>

<td style="text-align:right;">

31.89829
</td>

<td style="text-align:right;">

-84.23754
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

0.859769
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

</tbody>

</table>

</div>

The above is a small subset, but there are around 8000 plots that have
been collected since the storm in Georgia and Florida.

Now, use the Cyclones package to recreate the winds for Helene and
create wind intensity zones. For now, Cyclones is only available on
Github, so an extra package (“remotes”) is required to install it.

First, get the storm track information. This is the foundation for being
able to retreive the winds (and rain and storm surge).

``` r
##  install
install.packages('remotes')
remotes::install_github("BBranoff/Cyclones")
library(Cyclones)
library(terra)
library(sf)
library(dplyr)
##  we will use the rnaturalearth package to get state boundaries
usa <- rnaturalearth::ne_countries(country="united states of america",scale=10)
##  can also download the county boundaries
counties <- read_sf("/vsizip//vsicurl/https://naciscdn.org/naturalearth/10m/cultural/ne_10m_admin_2_counties.zip",
                        layer = "ne_10m_admin_2_counties")
##  also, convert the plots to a spatial object
plots_geo <- st_as_sf(plots,coords=c("LON","LAT"),crs=4326)
##  get the storm information
Helene <- get_storms(name="HELENE",season=2024)
Helene
```

Now, calculate the wind field. Here we just use a theoretical (Boose)
equation based on the maximum wind speed. We calulate the wind onto a
grid with a spatial resolution of 5km.

``` r
###  first, interpolate the spatial wind information to every 30 mins
Helene_extents <- make_extents(Helene,t_res=30)
###  then interpolate spatially as a raster
Helene_winds <- get_wind(Helene_extents,method="Boose",agg=TRUE,s_res=5000)
###  classify the maximum wind speed into the Saffir-Simpson scale
Helene_Cat <- as.factor(classify(Helene_winds$boose$max_msw,
                       matrix(c(0,33,NA,
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

With the hurricane intensity areas defined, we can assign them to each
plot. We also need to define the area of each wind zone. These will be
our artificial ‘strata’, and we will need to know the total area in
order to calculate the expansion factors.

``` r
###  first, mask out the areas outside of our interest
###  for now, this can just be the plots
###  but this probably needs to be 'forested' areas
Helene_Cat_plots <- trim(mask(Helene_Cat,st_transform(st_as_sf(st_concave_hull(st_union(plots_geo),ratio=0.02)),crs(Helene_Cat))))
##  now calculate area of each wind zone
##  important to do this while the raster is in projected, not geographic, coordinates
Areas <- table(values(Helene_Cat_plots ))
##  this is the number of pixels of each wind zone
##  multiply by the raster resolution to get the area, in square meters
Areas <- Areas*res(Helene_Cat_plots )[1]*res(Helene_Cat_plots )[2]
##  then convert to acres
Areas <- Areas/4046.86

###  project onto geographic coordinates
Helene_Cat_plots <- project(Helene_Cat_plots,"epsg:4326")
plot(Helene_Cat_plots)
###  overlay the plots
plot(st_geometry(st_as_sf(plots_geo,coords=c("LON","LAT"),crs=4326)),add=TRUE,pch=19,cex=0.5)
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

``` r
fiadb_api_GET = function(url){

  # make request
  resp <- httr::GET(url=url)
  # parse response from JSON to R list
  respObj <- httr::content(resp, "parsed", encoding = "ISO-8859-1")

  # create empty output list
  outputList = list()

  # add estimates data frame to output list
  if (! is.null(respObj$estimates)) {
      outputList$estimates <- format_estimate(respObj$estimates)
  } else  {
      print("Problem with URL or API. No estimate returned.")
      return(list())
  }


  #Use lapply to break apart subtotal list, then call sapply to format with names
  if (! is.null(respObj$subtotals))
        outputList$subtotals <- sapply(lapply(respObj$subtotals, "["),
                                       format_estimate, simplify = F, USE.NAMES = T)

  # totals data frame
  if (! is.null(respObj$totals))
    outputList$totals <- format_estimate(respObj$totals)


  # add estimate metadata, doesn't need to be reformatted
  if (! is.null(respObj$metadata)) outputList$metadata <- respObj$metadata

  return(outputList)
}
format_estimate = function(respList) {

  return(as.data.frame(do.call(rbind, respList)))

}
```

``` r
###  first, join the total 'strata' (wind zone) areas to the plot table
plots_geo$WindZone <- extract(Helene_Cat_plots,plots_geo)$max_msw
plots_geo<- plots_geo |>
  left_join(as.data.frame(Areas)|>rename(Acres=Freq),by=join_by(WindZone==Var1))|>
  group_by(WindZone)|>
  mutate(EXPNS_new = Acres/n())

##  first testing the concept on the full evaluation with the original expansion factors
ForestedAcres <- plots_geo |>
  mutate(ForestedAcres = if_else(PROP_BASIS=="MACR",
                                 CONDPROP_UNADJ*ADJ_FACTOR_MACR,CONDPROP_UNADJ*ADJ_FACTOR_SUBP))|>
  filter(EVALID %in% c(122401,132401),EVAL_GRP %in% c(122024,132024))|>
  group_by(EVAL_GRP)|>
  summarise(ForestedAcres=sum(ForestedAcres*EXPNS))|>
  st_drop_geometry()
###  our custom estimate
ForestedAcres
```

    ## # A tibble: 2 × 2
    ##   EVAL_GRP ForestedAcres
    ## *    <int>         <dbl>
    ## 1   122024     16679484.
    ## 2   132024     24088910.

``` r
###  EVALIDATOR for Florida
fiadb_api_GET(url="https://apps.fs.usda.gov/fiadb-api/fullreport?snum=02&wc=122024&outputFormat=NJSON")$totals$ESTIMATE
```

    ## $ESTIMATE
    ## [1] 16679484

``` r
###  EVALIDATOR for Georgia
fiadb_api_GET(url="https://apps.fs.usda.gov/fiadb-api/fullreport?snum=02&wc=132024&outputFormat=NJSON")$totals$ESTIMATE
```

    ## $ESTIMATE
    ## [1] 24088910

Evalidator shows 16,679,484 acres for 122024 and 24,088,910 acres for
132024
