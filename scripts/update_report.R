# Update report in RPubs
id <- "https://api.rpubs.com/api/v1/document/70046/3d9afaee617847fa97f38103ab6a386f"
continueUrl <- "http://rpubs.com/publish/claim/70046/12b8d36ab2dd46f49e6c2bbfa3365615"

markdown::rpubsUpload(title = "Text prediction milestone report",
                      htmlFile = "./reports/milestone_report.html",
                      id = id)
