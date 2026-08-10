# FIA-Post-Hurricane-Assessment
Hurricane damage/loss estimates from collected plots after storms


Start by loading the plots from nims_srs_db.   Here, using the DBI library, which requires some initial setup to for successful credentialed connections to the db.
Once setup, can connect to the "fiadb01p" data base and access any tables you are authorized to access. Then, we can use SQL queries passed as string 
arguments to retrieve the desired data. Here we are asking for the Florida (132024, 132025) and Georgia (122024, 122025) evaluations since hurricane Helene. We
are asking for the plots, their trees, as well as the reference tables necessary for TPA calculations. 
```{r load-plots,eval=FALSE}
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

```
