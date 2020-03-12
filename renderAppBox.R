# function to render app info box 
# has to be sourced within server and local (involves reactive file reader)
require(loggit)

 renderAppBox <- function(app_name, 
                          app_ip, # e.g. google.com
                          channel_name, 
                          invalidate_interval, 
                          userlog_path) {
   
   # reactive to check changes to loggit file, invalidates renderInfoBox accordingly
    app_logdata <- reactiveFileReader(intervalMillis = 5000, 
                                      session = NULL, 
                                      filePath = userlog_path, 
                                      readFunc = readLines)
    renderInfoBox({
      validate(
        need(file.exists(userlog_path), message = paste("no userlog file found at", userlog_path))
      )
      
      invalidateLater(invalidate_interval) # this is needed to check online status of app_ip, independent of app_usercount
      status <- try( pingr::is_up(app_ip) ) # e.g. google.com
      #app_usercount <- app_logdata()
  
      if(status) {
        title <- paste(channel_name, "| online")
        subtitle <- HTML(paste("cores: <b>", 
                           parallel::detectCores(), "</b>",
                           "current users: <b>", 
                           app_logdata() 
                           )
                         )
        color <- "green"
        icon <- icon("play-circle")
      } else {
        title <- paste(channel_name, "| offline")
        subtitle <- "not available"
        color <- "red"
        icon <- icon("stop-circle")
      } 
  
      infoBox(title = title, 
          icon = icon,
          subtitle = subtitle,
          color = color,
          value = app_name, 
          href = paste("http://", app_ip, sep = "")) # e.g. http://google.com
    })
 }