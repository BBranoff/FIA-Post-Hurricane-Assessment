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
library(sf)
library(knitr)
library(kableExtra)
myconn <- dbConnect(odbc::odbc(), "fiadb01p", timeout = 10) # function change w/DBI
vars = paste0("select p.cn,p.prev_plt_cn,p.plot_status_cd,p.invyr,p.eval_grp,p.statecd,p.countycd,p.measyear,p.measmon,p.measday,p.lat,p.lon,",
                    "c.condid,c.cond_status_cd,c.owncd,c.fortypcd,c.condprop_unadj,c.prop_basis,",
              "ps.evalid,ps.estn_unit_cn,ps.adj_factor_macr,ps.adj_factor_subp,ps.expns,",
              "pps.stratum_cn ")
tabs = "from fs_nims_fiadb_srs.plotsnap p,fs_nims_fiadb_srs.cond c,fs_nims_fiadb_srs.pop_stratum ps,fs_nims_fiadb_srs.pop_plot_stratum_assgn pps "
filts = paste0("where p.eval_grp in (132024,122024,132025,122025) 
and ps.evalid in(122501,122401,132501,132401,122500,122400,132500,132400)
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
plots |> head() |>
  kable(format='html')|>
  kable_styling() |>
  scroll_box(width='100%')
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">

<thead>

<tr>

<th style="text-align:left;">

CN
</th>

<th style="text-align:left;">

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

<th style="text-align:left;">

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

<th style="text-align:left;">

STRATUM_CN
</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

1682647303290487
</td>

<td style="text-align:left;">

718562301290487
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

2025
</td>

<td style="text-align:right;">

12
</td>

<td style="text-align:right;">

9
</td>

<td style="text-align:right;">

31.43287
</td>

<td style="text-align:right;">

-82.67843
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

520
</td>

<td style="text-align:right;">

0.250000
</td>

<td style="text-align:left;">

SUBP
</td>

<td style="text-align:right;">

132500
</td>

<td style="text-align:left;">

1995549996290487
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1.000000
</td>

<td style="text-align:right;">

5928.287
</td>

<td style="text-align:left;">

1995522657290487
</td>

</tr>

<tr>

<td style="text-align:left;">

1682647304290487
</td>

<td style="text-align:left;">

718562302290487
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

<td style="text-align:left;">

1995550003290487
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

<td style="text-align:left;">

1995522681290487
</td>

</tr>

<tr>

<td style="text-align:left;">

1682647307290487
</td>

<td style="text-align:left;">

718562305290487
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

6
</td>

<td style="text-align:right;">

31.20386
</td>

<td style="text-align:right;">

-82.75826
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

132500
</td>

<td style="text-align:left;">

1995549996290487
</td>

<td style="text-align:right;">

0
</td>

<td style="text-align:right;">

1.000000
</td>

<td style="text-align:right;">

5928.287
</td>

<td style="text-align:left;">

1995522657290487
</td>

</tr>

<tr>

<td style="text-align:left;">

1682646798290487
</td>

<td style="text-align:left;">

718561796290487
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

<td style="text-align:left;">

1995550004290487
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

<td style="text-align:left;">

1995522694290487
</td>

</tr>

<tr>

<td style="text-align:left;">

1682646800290487
</td>

<td style="text-align:left;">

718561798290487
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

221
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

5
</td>

<td style="text-align:right;">

18
</td>

<td style="text-align:right;">

33.98447
</td>

<td style="text-align:right;">

-82.82930
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

<td style="text-align:left;">

1995550004290487
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

<td style="text-align:left;">

1995522693290487
</td>

</tr>

<tr>

<td style="text-align:left;">

1682646814290487
</td>

<td style="text-align:left;">

718561812290487
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

317
</td>

<td style="text-align:right;">

2026
</td>

<td style="text-align:right;">

5
</td>

<td style="text-align:right;">

24
</td>

<td style="text-align:right;">

33.67671
</td>

<td style="text-align:right;">

-82.78377
</td>

<td style="text-align:right;">

3
</td>

<td style="text-align:right;">

1
</td>

<td style="text-align:right;">

46
</td>

<td style="text-align:right;">

503
</td>

<td style="text-align:right;">

0.049886
</td>

<td style="text-align:left;">

SUBP
</td>

<td style="text-align:right;">

132501
</td>

<td style="text-align:left;">

1995550007290487
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

<td style="text-align:left;">

1995522690290487
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

Below demonstrates how the above hurricane data was obtained. First the
Cyclones package is downloaded and installed and it is used to ingest
the necessary data and process into the wind fields we need.  
First, download the package and get the storm track information. This is
the foundation for being able to retrieve the winds (and rain and storm
surge).

``` r
##  install, only needed once
# install.packages('remotes')
# remotes::install_github("BBranoff/Cyclones@development")

library(Cyclones)
##  get the storm information
Helene <- get_storms(name="HELENE",season=2024,erddap=FALSE)
```

    ## Downloading IBTrACS from: https://www.ncei.noaa.gov/products/international-best-track-archive

``` r
Helene$HELENE_2024_NA_2024268N17278
```

    ## # A tibble: 45 × 29
    ##    ID       SID   USA_ATCF_ID SEASON NAME  BASIN ISO_TIME            LAT     LON
    ##    <chr>    <chr> <chr>       <chr>  <chr> <chr> <dttm>              <chr> <dbl>
    ##  1 HELENE_… 2024… AL092024    2024   HELE… NA    2024-09-23 12:00:00 17.2  -81.7
    ##  2 HELENE_… 2024… AL092024    2024   HELE… NA    2024-09-23 15:00:00 17.5  -81.8
    ##  3 HELENE_… 2024… AL092024    2024   HELE… NA    2024-09-23 18:00:00 17.8  -81.9
    ##  4 HELENE_… 2024… AL092024    2024   HELE… NA    2024-09-23 21:00:00 18.0  -82  
    ##  5 HELENE_… 2024… AL092024    2024   HELE… NA    2024-09-24 00:00:00 18.2  -82.2
    ##  6 HELENE_… 2024… AL092024    2024   HELE… NA    2024-09-24 03:00:00 18.4  -82.5
    ##  7 HELENE_… 2024… AL092024    2024   HELE… NA    2024-09-24 06:00:00 18.6  -82.8
    ##  8 HELENE_… 2024… AL092024    2024   HELE… NA    2024-09-24 09:00:00 18.9  -83.2
    ##  9 HELENE_… 2024… AL092024    2024   HELE… NA    2024-09-24 12:00:00 19.2  -83.7
    ## 10 HELENE_… 2024… AL092024    2024   HELE… NA    2024-09-24 15:00:00 19.3  -84.2
    ## # ℹ 35 more rows
    ## # ℹ 20 more variables: USA_SSHS <int>, STORM_SPEED <chr>, CONS_WIND <dbl>,
    ## #   CONS_PRES <dbl>, CONS_RMW <dbl>, CONS_ROCI <dbl>, CONS_POCI <dbl>,
    ## #   CONS_EYE <dbl>, CONS_R34_NE <dbl>, CONS_R50_NE <dbl>, CONS_R64_NE <dbl>,
    ## #   CONS_R34_SE <dbl>, CONS_R50_SE <dbl>, CONS_R64_SE <dbl>, CONS_R34_SW <dbl>,
    ## #   CONS_R50_SW <dbl>, CONS_R64_SW <dbl>, CONS_R34_NW <dbl>, CONS_R50_NW <dbl>,
    ## #   CONS_R64_NW <dbl>

Now, calculate the wind field. Here we just use a theoretical (Boose)
equation based on the maximum wind speed. We calculate the wind onto a
grid with a spatial resolution of 5km.

``` r
###  first, interpolate the spatial wind information to every 30 mins
Helene_extents <- make_extents(Helene,t_res=30)
```

    ## Building wind extents for  HELENE_2024_NA_2024268N17278  : % 0.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 0.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 1.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 1.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 2.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 2.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 3.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 3.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 4.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 4.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 5.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 5.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 5.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 6.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 6.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 7.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 7.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 7.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 8.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 8.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 9.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 9.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 9.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 10.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 10.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 11.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 11.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 11.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 12.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 12.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 13Building wind extents for  HELENE_2024_NA_2024268N17278  : % 13.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 13.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 14.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 14.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 15Building wind extents for  HELENE_2024_NA_2024268N17278  : % 15.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 15.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 16.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 16.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 17Building wind extents for  HELENE_2024_NA_2024268N17278  : % 17.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 17.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 18.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 18.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 19Building wind extents for  HELENE_2024_NA_2024268N17278  : % 19.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 19.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 20.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 20.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 20.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 21.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 21.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 22.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 22.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 22.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 23.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 23.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 24.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 24.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 24.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 25.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 25.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 26.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 26.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 26.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 27.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 27.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 28.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 28.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 28.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 29.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 29.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 30Building wind extents for  HELENE_2024_NA_2024268N17278  : % 30.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 30.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 31.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 31.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 32Building wind extents for  HELENE_2024_NA_2024268N17278  : % 32.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 32.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 33.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 33.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 34Building wind extents for  HELENE_2024_NA_2024268N17278  : % 34.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 34.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 35.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 35.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 36Building wind extents for  HELENE_2024_NA_2024268N17278  : % 36.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 36.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 37.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 37.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 37.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 38.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 38.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 39.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 39.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 39.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 40.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 40.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 41.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 41.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 41.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 42.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 42.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 43.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 43.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 43.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 44.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 44.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 45.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 45.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 45.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 46.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 46.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 47Building wind extents for  HELENE_2024_NA_2024268N17278  : % 47.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 47.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 48.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 48.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 49Building wind extents for  HELENE_2024_NA_2024268N17278  : % 49.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 49.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 50.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 50.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 51Building wind extents for  HELENE_2024_NA_2024268N17278  : % 51.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 51.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 52.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 52.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 53Building wind extents for  HELENE_2024_NA_2024268N17278  : % 53.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 53.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 54.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 54.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 54.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 55.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 55.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 56.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 56.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 56.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 57.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 57.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 58.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 58.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 58.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 59.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 59.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 60.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 60.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 60.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 61.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 61.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 62.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 62.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 62.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 63.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 63.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 64Building wind extents for  HELENE_2024_NA_2024268N17278  : % 64.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 64.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 65.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 65.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 66Building wind extents for  HELENE_2024_NA_2024268N17278  : % 66.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 66.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 67.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 67.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 68Building wind extents for  HELENE_2024_NA_2024268N17278  : % 68.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 68.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 69.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 69.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 70Building wind extents for  HELENE_2024_NA_2024268N17278  : % 70.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 70.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 71.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 71.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 71.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 72.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 72.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 73.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 73.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 73.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 74.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 74.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 75.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 75.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 75.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 76.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 76.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 77.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 77.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 77.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 78.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 78.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 79.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 79.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 79.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 80.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 80.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 81Building wind extents for  HELENE_2024_NA_2024268N17278  : % 81.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 81.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 82.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 82.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 83Building wind extents for  HELENE_2024_NA_2024268N17278  : % 83.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 83.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 84.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 84.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 85Building wind extents for  HELENE_2024_NA_2024268N17278  : % 85.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 85.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 86.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 86.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 87Building wind extents for  HELENE_2024_NA_2024268N17278  : % 87.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 87.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 88.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 88.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 88.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 89.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 89.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 90.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 90.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 90.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 91.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 91.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 92.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 92.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 92.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 93.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 93.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 94.1Building wind extents for  HELENE_2024_NA_2024268N17278  : % 94.5Building wind extents for  HELENE_2024_NA_2024268N17278  : % 94.9Building wind extents for  HELENE_2024_NA_2024268N17278  : % 95.3Building wind extents for  HELENE_2024_NA_2024268N17278  : % 95.7Building wind extents for  HELENE_2024_NA_2024268N17278  : % 96Building wind extents for  HELENE_2024_NA_2024268N17278  : % 96.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 96.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 97.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 97.6Building wind extents for  HELENE_2024_NA_2024268N17278  : % 98Building wind extents for  HELENE_2024_NA_2024268N17278  : % 98.4Building wind extents for  HELENE_2024_NA_2024268N17278  : % 98.8Building wind extents for  HELENE_2024_NA_2024268N17278  : % 99.2Building wind extents for  HELENE_2024_NA_2024268N17278  : % 99.6Building wind extents for    : % 100

``` r
###  then interpolate spatially as a raster
Helene_winds <- get_wind(Helene_extents,method="Boose",agg=TRUE,s_res=5000)
```

    ## processing wind for HELENE_2024 via boose

    ## 
    ## interpolating to desired frequency: % 2interpolating to desired frequency: % 5interpolating to desired frequency: % 7interpolating to desired frequency: % 9interpolating to desired frequency: % 11interpolating to desired frequency: % 14interpolating to desired frequency: % 16interpolating to desired frequency: % 18interpolating to desired frequency: % 20interpolating to desired frequency: % 23interpolating to desired frequency: % 25interpolating to desired frequency: % 27interpolating to desired frequency: % 30interpolating to desired frequency: % 32interpolating to desired frequency: % 34interpolating to desired frequency: % 36interpolating to desired frequency: % 39interpolating to desired frequency: % 41interpolating to desired frequency: % 43interpolating to desired frequency: % 45interpolating to desired frequency: % 48interpolating to desired frequency: % 50interpolating to desired frequency: % 52interpolating to desired frequency: % 55interpolating to desired frequency: % 57interpolating to desired frequency: % 59interpolating to desired frequency: % 61interpolating to desired frequency: % 64interpolating to desired frequency: % 66interpolating to desired frequency: % 68interpolating to desired frequency: % 70interpolating to desired frequency: % 73interpolating to desired frequency: % 75interpolating to desired frequency: % 77interpolating to desired frequency: % 80interpolating to desired frequency: % 82interpolating to desired frequency: % 84interpolating to desired frequency: % 86interpolating to desired frequency: % 89interpolating to desired frequency: % 91interpolating to desired frequency: % 93interpolating to desired frequency: % 95interpolating to desired frequency: % 98

``` r
##  get some boundaries, mostly for display
##  county boundaries
counties <- read_sf("/vsizip//vsicurl/https://naciscdn.org/naturalearth/10m/cultural/ne_10m_admin_2_counties.zip",
                        layer = "ne_10m_admin_2_counties")
usa <- counties|>filter(REGION_COD %in% c(12,13,47,45,37))|>group_by(REGION_COD)|>summarise()

library(terra)
plot(Helene_winds$boose$max_msw,main="Maximum Sustained Winds (m/s)")
plot(st_geometry(st_transform(usa,crs(Helene_winds$boose$max_msw))),add=TRUE)
```

<figure>
<img src="README_files/figure-gfm/winds-1.png"
alt="Fig 1. Hurricane Helene’s maximum sustained winds in meters per second." />
<figcaption aria-hidden="true">Fig 1. Hurricane Helene’s maximum
sustained winds in meters per second.</figcaption>
</figure>

We can then categorize the wind into the familiar Saffir-Simpson scale.
These categories will be our intensity zones and they will be the
on-the-fly strata that we use to calculate sub-complete evaluation
estimates.

``` r
###  classify the maximum wind speed into the Saffir-Simpson scale
Helene_Cat <- as.factor(classify(Helene_winds$max_msw,
                       matrix(c(0,33,0,
                                33,43,1,
                                43,50,2,
                                50,60,3,
                                60,70,4,
                                70,Inf,5),ncol=3,byrow=TRUE),include.lowest=TRUE))
plot(Helene_Cat,main="Wind Intensity Categories")
plot(st_geometry(st_transform(usa,crs(Helene_Cat))),add=TRUE)
```

<figure>
<img src="README_files/figure-gfm/winds-hidden-1.png"
alt="Fig 2. Hurricane Helene’s wind field, categorized into intensity zones." />
<figcaption aria-hidden="true">Fig 2. Hurricane Helene’s wind field,
categorized into intensity zones.</figcaption>
</figure>

The Helene hurricane data is now processed and ready for overlays with
the plots.

With the hurricane intensity areas defined, we can assign them to each
plot. We also need to define the area of each wind zone. These will be
our artificial ‘strata’, and we will need to know the total area in
order to calculate the expansion factors. This is done two ways. The
first is using vectors (shapefiles) of the strata and the ‘st_area()’
function to calculate the areas. The second is using the raster image
and counting the number of pixels in each strata, then multiplying by
the resolution to get total area.

``` r
###  first, mask out the areas outside of our interest
###  for now, this can just be the plots
###  but this probably needs to be 'forested' areas
Helene_Cat_plots <- trim(mask(Helene_Cat,st_transform(st_as_sf(st_concave_hull(st_union(plots_geo),ratio=0.01)),crs(Helene_Cat))))

###  for the vector approach, convert to vector
Helene_Cat_shape <- as.polygons(Helene_Cat)
## intersect with the states
Helene_Cat_shape <- st_intersection(st_as_sf(Helene_Cat_shape), counties|>filter(REGION_COD %in% c(12,13))|>group_by(REGION_COD)|>summarise()|>st_transform(crs(Helene_Cat)))
```

    ## Warning: attribute variables are assumed to be spatially constant throughout
    ## all geometries

``` r
##  calculate the area and covert to acres
Helene_Cat_shape$area.m <- st_area(Helene_Cat_shape)
Helene_Cat_shape$area.ac <- Helene_Cat_shape$area.m/4046.86


##  now the raster approach
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

### compare the two
Areas |> left_join(Helene_Cat_shape|>
                     mutate(REGION_COD=as.numeric(REGION_COD))|>
  st_drop_geometry(),
  by=join_by(Var1==max_msw,STATECD==REGION_COD))|>
  ###  also compare with FIA shapefile
  left_join(FIAstates|>
  filter(STATEFP %in% c(12,13))|>
  st_transform(st_crs(Helene_Cat_shape))|>
  st_intersection(st_as_sf(as.polygons(Helene_Cat)))%>%
  mutate(AreaFIA.m=st_area(.),
         AreaFIA.ac=AreaFIA.m/4046.86,
         STATEFP=as.numeric(STATEFP)),by=join_by(Var1==max_msw,STATECD==STATEFP))
```

    ## Warning: attribute variables are assumed to be spatially constant throughout
    ## all geometries

    ##   Var1        Freq STATECD       Acres             area.m           area.ac
    ## 1    0 7.57750e+10      12 18724393.73 112332150206 [m^2] 27757854.29 [m^2]
    ## 2    1 1.85500e+10      12  4583800.77  18991517326 [m^2]  4692901.98 [m^2]
    ## 3    2 6.75000e+09      12  1667959.85   6678758883 [m^2]  1650355.80 [m^2]
    ## 4    3 7.95000e+09      12  1964486.05   7920417193 [m^2]  1957175.98 [m^2]
    ## 5    4 8.00000e+08      12   197684.13    789709525 [m^2]   195141.30 [m^2]
    ## 6    0 1.07775e+11      13 26631758.94 109451043293 [m^2] 27045917.90 [m^2]
    ## 7    1 3.68250e+10      13  9099647.63  36591767302 [m^2]  9042014.62 [m^2]
    ## 8    2 6.12500e+09      13  1513519.12   5799203623 [m^2]  1433013.16 [m^2]
    ## 9    3 3.75000e+08      13    92664.44    318858614 [m^2]    78791.61 [m^2]
    ##                             geom          AreaFIA.m        AreaFIA.ac
    ## 1 MULTIPOLYGON (((222988.8 -1... 132472745232 [m^2] 32734699.31 [m^2]
    ## 2 MULTIPOLYGON (((52034.85 51...  20720186432 [m^2]  5120065.05 [m^2]
    ## 3 MULTIPOLYGON (((112046.8 51...   7539289424 [m^2]  1862997.34 [m^2]
    ## 4 POLYGON ((156936.4 514838.7...   8635169848 [m^2]  2133795.05 [m^2]
    ## 5 POLYGON ((151473.9 384951.4...    942857399 [m^2]   232984.93 [m^2]
    ## 6 POLYGON ((173280 998018.7, ... 110970211278 [m^2] 27421312.15 [m^2]
    ## 7 POLYGON ((341810.9 526531.4...  36906880423 [m^2]  9119880.70 [m^2]
    ## 8 POLYGON ((236886.2 510691.6...   5739489088 [m^2]  1418257.39 [m^2]
    ## 9 POLYGON ((191418.1 512976.5...    293978362 [m^2]    72643.57 [m^2]

``` r
###  project onto geographic coordinates
#Helene_Cat_plots <- project(Helene_Cat_plots,"epsg:4326")
Helene_Cat_shape <- st_transform(Helene_Cat_shape,4326)
plot(Helene_Cat_shape['max_msw'],key.pos = NULL, reset = FALSE)
###  overlay the plots
plot(st_geometry(st_as_sf(plots_geo,coords=c("LON","LAT"),crs=4326)),add=TRUE,pch=19,cex=0.01)
plot(st_geometry(usa),add=TRUE,border="darkgrey")
plot(st_geometry(counties),add=TRUE,border="darkgrey")
```

<figure>
<img src="README_files/figure-gfm/extract-1.png"
alt="Fig 3. Hurricane Helene’s wind zones with the plots overlayed. Plots are assigned their respective wind zones and their expansion factors come from the total area of each wind zone divided by the number of plots in each zone." />
<figcaption aria-hidden="true">Fig 3. Hurricane Helene’s wind zones with
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
  mutate(nplots = length(unique(CN)),
         EXPNS_new_raster = Acres/nplots,
         EXPNS_new_vector = area.ac/nplots,
         EXPNS_new_FIA = AreaFIA.ac/nplots)

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
  filter(EVALID %in% c(122400,132400),EVAL_GRP %in% c(122024,132024))|>
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
            ForestedAcres=sum(ForestedAcres*AreaFIA.ac))
  
HeleneAcres|>
  filter(EVAL_GRP%in% c(122024,132024),FORTYP=="All",County=="All")|>
  group_by(EVAL_GRP) |>
  summarise(ForestedAcres=sum(ForestedAcres,na.rm=TRUE))|>
  mutate(EVALIDATORSacres = as.numeric(c(fiadb_api_GET(url="https://apps.fs.usda.gov/fiadb-api/fullreport?snum=02&wc=122024&outputFormat=NJSON")$totals$ESTIMATE,
                                                                                                                                                                                        fiadb_api_GET(url="https://apps.fs.usda.gov/fiadb-api/fullreport?snum=02&wc=132024&outputFormat=NJSON")$totals$ESTIMATE)))
```

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
