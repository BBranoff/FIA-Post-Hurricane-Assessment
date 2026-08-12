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