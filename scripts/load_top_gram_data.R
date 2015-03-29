files <- list.files(path = "./data/processed/top-grams/",
                    full.names = TRUE, pattern = "n[34]")

# Load data
invisible(sapply(files,
                 function(file){
                   assign(gsub("[^_]+/([^.]+)[.]rds", "\\1", file),
                          value = readRDS(file = file),
                          pos = search()[1])
                 }))

data_names <- gsub("[^_]+/([^.]+)[.]rds", "\\1", files)

# Tag data
n3_blogs$source <- "blogs"
n3_news$source <- "news"
n3_twitter$source <- "twitter"
n4_blogs$source <- "blogs"
n4_news$source <- "news"
n4_twitter$source <- "twitter"
thes_n3_blogs$source <- "blogs"
thes_n3_news$source <- "news"
thes_n3_twitter$source <- "twitter"
thes_n4_blogs$source <- "blogs"
thes_n4_news$source <- "news"
thes_n4_twitter$source <- "twitter"

thes_n3_blogs$type <- "more-informative"
thes_n3_news$type <- "more-informative"
thes_n3_twitter$type <- "more-informative"
thes_n4_blogs$type <- "more-informative"
thes_n4_news$type <- "more-informative"
thes_n4_twitter$type <- "more-informative"

n3_blogs$type <- "less-informative"
n3_news$type <- "less-informative"
n3_twitter$type <- "less-informative"
n4_blogs$type <- "less-informative"
n4_news$type <- "less-informative"
n4_twitter$type <- "less-informative"

# Process data

n3 <-
  bind_rows(n3_blogs, n3_news, n3_twitter,
            thes_n3_blogs, thes_n3_news, thes_n3_twitter) %>% 
  mutate(text = paste(n2, n1, n0)) %>%
  select(-c(n2, n1, n0)) %>%
  filter(type == "less-informative") %>% 
  group_by(source, type) %>%
  top_n(10, N)


save(n3, file = "./data/processed/n3_report.RData")
