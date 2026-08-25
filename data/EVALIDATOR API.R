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
format_subtots <- function(st){
  stt <- sapply(st,function (x) do.call(rbind,x))
}
format_subtots2 <- function(st,eg,r1){
  browser()
  subtots_GRP1  <- lapply(st, '[[', 1)
  subtots_GRP1 <- do.call(rbind, lapply(seq_along(subtots_GRP1),function(x) subtots_GRP1[[x]]%>%
                                          data.frame()%>%
                                          mutate(EVAL_GRP=eg[x],req=x,table=if_else(r1[[x]]=="NJSON","GRP1_all","GRP1_custom"))))
  subtots_GRP1XGRP2 <- lapply(st, '[[', 2)
  subtots_GRP1XGRP2 <-   do.call(rbind,lapply(seq_along(subtots_GRP1XGRP2),function(x) subtots_GRP1XGRP2[[x]]%>%
                                                data.frame()%>%
                                                mutate(EVAL_GRP=eg[x],req=x,table=if_else(r1[[x]]=="NJSON","GRP1XGRP2_all","GRP1XGRP2_custom"))))
  
  subtots_GRP1XGRP3 <- lapply(st, '[[', 3)
  subtots_GRP1XGRP3 <-   do.call(rbind,lapply(seq_along(subtots_GRP1XGRP3),function(x) subtots_GRP1XGRP3[[x]]%>%
                                                data.frame()%>%
                                                mutate(EVAL_GRP=eg[x],req=x,table=if_else(r1[[x]]=="NJSON","GRP1XGRP3_all","GRP1XGRP3_custom"))))
  subtots_GRP2 <-lapply(st, '[[', 4)
  subtots_GRP2 <- do.call(rbind, lapply(seq_along(subtots_GRP2),function(x) subtots_GRP2[[x]]%>%
                                          data.frame()%>%
                                          mutate(EVAL_GRP=eg[x],req=x,table=if_else(r1[[x]]=="NJSON","GRP2_all","GRP2_custom"))))
  subtots_GRP2XGRP3 <-lapply(st, '[[', 5)
  subtots_GRP2XGRP3 <- do.call(rbind, lapply(seq_along(subtots_GRP2XGRP3),function(x) subtots_GRP2XGRP3[[x]]%>%
                                               data.frame()%>%
                                               mutate(EVAL_GRP=eg[x],req=x,table=if_else(r1[[x]]=="NJSON","GRP2XGRP3_all","GRP2XGRP3_custom"))))
  subtots_GRP3 <-lapply(st, '[[', 6)
  subtots_GRP3 <- do.call(rbind,lapply(seq_along(subtots_GRP3),function(x) subtots_GRP3[[x]]%>%
                                         data.frame()%>%
                                         mutate(EVAL_GRP=eg[x],req=x,table=if_else(r1[[x]]=="NJSON","GRP3_all","GRP3_custom"))))
  bind_rows(subtots_GRP1,subtots_GRP1XGRP2,subtots_GRP1XGRP3,subtots_GRP2,subtots_GRP2XGRP3,subtots_GRP3)%>%
    mutate(group=gsub("Custom ","",GRP2))
}
fiadb_api_POST <- function(postURL, argList,quiet=TRUE) { 
  # make request 
  resp <- httr::POST(url = postURL, body = argList, encode = "form") 
  # parse response from JSON to R list 
  respObj <- httr::content(resp, "parsed", encoding = "ISO-8859-1") 
  # create empty output list 
  outputList <- list() 
  # add estimates data frame to output list 
  if (!is.null(respObj$estimates)) { 
    r1s <- argList$outputFormat
    estimates <- respObj$estimates
    estimates <- estimates %>%data.table::rbindlist()%>%data.frame()
    subtots <- respObj$subtotals
    subtots <- lapply(subtots,function(x) x|>data.table::rbindlist()|>data.frame())
    egs <- argList$wc #if(length(nojsons)>0){unlist(lapply(argList,'[[',4))[-nojsons]}else{unlist(lapply(argList,'[[',4))}
    #subtots <- format_subtots(subtots)
    #subtots <- format_subtots2(list(subtots),egs,r1s)
    #subtots <- sapply(lapply(subtots, "["), format_estimate, simplify = F, USE.NAMES = T) 
    tots <-respObj$totals
    tots <- tots %>%data.table::rbindlist()%>%data.frame()
    #tots <- format_estimate(tots)
    met <- respObj$metadata
    sql <- met$sql
    #estimates <- estimates%>%mutate(EVAL_GRP=egs,group=gsub("Custom ","",GRP1))
    #tots <- tots%>%mutate(EVAL_GRP=egs)
    outputList$estimates = estimates
    outputList$subtotals = subtots#do.call(rbind,subtots)
    outputList$totals = data.frame(tots)
  } else { 
    if(quiet==FALSE){
      print("Problem with URL or API. No estimate returned.") 
    }
    return(list()) 
  } 
  return(outputList) 
} 
fiadb_api_POST_parallel <- function(postURL, argList,CNs,quiet=TRUE) { 

  # make request 
  #resp <- httr::POST(url = postURL, body = argList, encode = "form") 
  request_base <- request(postURL) %>%
    req_throttle(capacity=5,fill_time_s = 20) 
  reqs <- list()
  for (L in argList){
    #ps <- ifelse(L$snum%in%c(2,3),'Forest type group','Species group')
    reqs <- append(reqs,list(request_base %>%req_body_form(snum=L$snum,cselected=L$cselected,rselected="County code and name",
                                                           pselected=L$pselected,wc=L$wc,r1=L$r1,outputFormat=L$outputFormat)))
  }
  resps <- req_perform_parallel(reqs,on_error = "continue")
  fails <- which(sapply(resps, inherits, "httr2_error"))
  if (length(fails)==0){
    nojsons <- which(unlist(lapply(resps,resp_content_type))!="application/json")
  }else{nojsons=0}
  ntries=0
  while ((length(fails) > 0|length(nojsons)>0)&ntries<5) {
    failed_requests <- reqs[unique(c(fails,nojsons))]
    retry_resps <- req_perform_parallel(failed_requests, on_error = "continue")
    resps[unique(c(fails,nojsons))] <- retry_resps
    fails <- which(sapply(resps, inherits, "httr2_error"))
    if (length(fails)==0){
      nojsons <- which(unlist(lapply(resps,resp_content_type))!="application/json")
    }else{nojsons=0}
    ntries=ntries+1
  }
  if (ntries==5){
    resps <- resps_successes(resps)
    nojsons <- which(unlist(lapply(resps,resp_content_type))!="application/json")
    resps <- resps[-nojsons]
    if (length(nojsons)==length(argList)){
      return(list(estimates=NULL,subtotals=NULL,total=NULL))
    }
  }
  # if (sum(unlist(lapply(resps,resp_content_type))!="application/json")>0){browser()}
  respObj <- lapply(resps,resp_body_json)
  # create empty output list
  outputList <- list()
  browser()
  r1s <- lapply(argList,"[[",6)
  estimates <- lapply(respObj,'[[',2)
  estimates <- lapply(seq_along(estimates),function(x,e) e[[x]]%>%data.table::rbindlist()%>%data.frame()%>%
                        mutate(req=x,
                               table=if_else(r1s[[x]]=="NJSON","estimates_all","estimates_custom")),
                      e=estimates)
  subtots <- lapply(respObj,'[[',4)
  if (length(subtots)==0){browser()}
  # subtots <- subtots[[1]]$GRP1
  #subtots <-lapply(subtots, "[")
  egs <- if(length(nojsons)>0){unlist(lapply(argList,'[[',4))[-nojsons]}else{unlist(lapply(argList,'[[',4))}
  subtots <- lapply(subtots,format_subtots)
  subtots <- format_subtots2(subtots,egs,r1s)
  #subtots <- sapply(lapply(subtots, "["), format_estimate, simplify = F, USE.NAMES = T) 
  tots <- lapply(respObj,'[[',5)
  tots <- lapply(tots,format_estimate)
  met <- lapply(respObj,'[[',3)
  sql <- lapply(met,'[[',16)
  estimates <- lapply(1:length(estimates),function(x,est,e) est[[x]]%>%mutate(EVAL_GRP=e[x],group=gsub("Custom ","",GRP2)),est=estimates,e=egs)
  estimates <- do.call(rbind,estimates)%>%
    left_join(CNs %>%group_by(group,EVAL_GRP)%>%summarise(CNs=list(CN)),by=join_by(group==group,EVAL_GRP==EVAL_GRP))
  tots <- lapply(1:length(tots),function(x,tot,e) tot[[x]]%>%mutate(EVAL_GRP=e[x],req=x),tot=tots,e=egs)
  outputList$estimates = estimates
  outputList$subtotals = subtots#do.call(rbind,subtots)
  outputList$totals = do.call(rbind,tots)
  return(outputList) 
} 
format_subtots <- function(st){
  stt <- sapply(st,function (x) do.call(rbind,x))
}
format_subtots2 <- function(st,eg,r1){
  subtots_GRP1  <- lapply(st, '[[', 1)
  subtots_GRP1 <- do.call(rbind, lapply(seq_along(subtots_GRP1),function(x) subtots_GRP1[[x]]%>%
                                          data.frame()%>%
                                          mutate(EVAL_GRP=eg[x],req=x,table=if_else(r1[[x]]=="NJSON","GRP1_all","GRP1_custom"))))
  subtots_GRP1XGRP2 <- lapply(st, '[[', 2)
  subtots_GRP1XGRP2 <-   do.call(rbind,lapply(seq_along(subtots_GRP1XGRP2),function(x) subtots_GRP1XGRP2[[x]]%>%
                                                data.frame()%>%
                                                mutate(EVAL_GRP=eg[x],req=x,table=if_else(r1[[x]]=="NJSON","GRP1XGRP2_all","GRP1XGRP2_custom"))))
  
  subtots_GRP1XGRP3 <- lapply(st, '[[', 3)
  subtots_GRP1XGRP3 <-   do.call(rbind,lapply(seq_along(subtots_GRP1XGRP3),function(x) subtots_GRP1XGRP3[[x]]%>%
                                                data.frame()%>%
                                                mutate(EVAL_GRP=eg[x],req=x,table=if_else(r1[[x]]=="NJSON","GRP1XGRP3_all","GRP1XGRP3_custom"))))
  subtots_GRP2 <-lapply(st, '[[', 4)
  subtots_GRP2 <- do.call(rbind, lapply(seq_along(subtots_GRP2),function(x) subtots_GRP2[[x]]%>%
                                          data.frame()%>%
                                          mutate(EVAL_GRP=eg[x],req=x,table=if_else(r1[[x]]=="NJSON","GRP2_all","GRP2_custom"))))
  subtots_GRP2XGRP3 <-lapply(st, '[[', 5)
  subtots_GRP2XGRP3 <- do.call(rbind, lapply(seq_along(subtots_GRP2XGRP3),function(x) subtots_GRP2XGRP3[[x]]%>%
                                               data.frame()%>%
                                               mutate(EVAL_GRP=eg[x],req=x,table=if_else(r1[[x]]=="NJSON","GRP2XGRP3_all","GRP2XGRP3_custom"))))
  subtots_GRP3 <-lapply(st, '[[', 6)
  subtots_GRP3 <- do.call(rbind,lapply(seq_along(subtots_GRP3),function(x) subtots_GRP3[[x]]%>%
                                         data.frame()%>%
                                         mutate(EVAL_GRP=eg[x],req=x,table=if_else(r1[[x]]=="NJSON","GRP3_all","GRP3_custom"))))
  bind_rows(subtots_GRP1,subtots_GRP1XGRP2,subtots_GRP1XGRP3,subtots_GRP2,subtots_GRP2XGRP3,subtots_GRP3)%>%
    mutate(group=gsub("Custom ","",GRP2))
}