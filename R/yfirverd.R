

#' Title
#'
#' @param connection A connection to the HMS database
#' @param ... Grouping variables (unquoted), used for faceting
#' @param print_plot
#' @param eftir Name of the groups to include in the title
#' @param filters
#' @import tidyverse
#' @import lubridate
#' @import glue
#'
#' @return The data data used for the plot.
#' @export yfirverd
#' @export yfirverd_get_data
#' @export plot_yfirverd
#'
#' @examples
yfirverd <- function(..., connection = get_connection_windows(), print_plot = TRUE, eftir = NULL, filters = NULL){
  df <- yfirverd_get_data(connection = connection)
  if(NROW(df) == 0) stop("0 rows returned from DB")

  my_groups <- enquos(...)
  number_of_grouping_variables <- length(my_groups)

  df2 <- df %>%
    sql_clean() %>%
    # map(filters, ~. %>% filter(!!!.x))
    filter(!!!filters) %>%
    mutate(timi = floor_date(Dim_Timi_Utgefid, unit = "months")) %>%
    group_by(timi, !!!my_groups) %>%
    summarise_at(
      vars(SeltYfirAuglystuSoluverdi, SeltAAuglystuSoluverdi, SeltUndirAuglystuSoluverdi),
      sum,
      na.rm = TRUE
    ) %>%
    select(SeltYfirAuglystuSoluverdi, SeltAAuglystuSoluverdi, SeltUndirAuglystuSoluverdi, timi, !!!my_groups) %>%
    gather(var, val, SeltYfirAuglystuSoluverdi, SeltAAuglystuSoluverdi, SeltUndirAuglystuSoluverdi) %>%
    mutate(
      var = var %>%
        fct_inorder() %>%
        fct_rev %>%
        fct_recode(
          `Selt undir auglýstu söluverði` = "SeltUndirAuglystuSoluverdi",
          `Selt á auglýstu söluverði` = "SeltAAuglystuSoluverdi",
          `Selt yfir auglýstu söluverði` = "SeltYfirAuglystuSoluverdi"
        )
    ) %>%
    group_by(var) %>%
    mutate(val = (val + lag(val) + lag(val, 2)) / 3)


  # Plot
  eftir <- if_else(is.null(eftir), "", paste0("eftir ", eftir, " "))
  title <- glue("Kaupverð íbúða {eftir}í samanburði við ásett verð")


  if(print_plot) {

    # p <- plot_yfirverd(df2, title = title) +
    #   facet_wrap(facets = vars(!!!my_groups))

    # only use facets if there is a grooping variable
    if(number_of_grouping_variables == 0){
      p <- plot_yfirverd(df2, title = title)
    } else {
      p <- plot_yfirverd(df2, title = title) +
        facet_wrap(facets = vars(!!!my_groups))
    }

    print(p)
  }

  return(df2)

}


yfirverd_get_data <- function(connection = get_connection_windows()){

  # sql script
  # Needed to take out Faerslunumer, kaupverd_nuvirdi and OnothaefurSamningur because of changes in the datawarehouse
  query_yfirverd <- "SELECT
        [Dim_Timi_Utgefid]
        ,[Dim_Timi_Thinglyst]
        ,[Dim_Fasteignir]
        ,[Postnumer]

        ,[Kaupverd]

        ,[FjoldiFasteigna]
        ,[FjoldiMatseininga]

        ,[AuglystDags]
        ,[AuglystSoluverd]
        ,[Landshluti]
        ,[Landshlutaflokkun]
        ,[HofudborgLandsbyggd]
        ,[SerbyliFjolbyli]
        ,[FjoldiHerbergja]
        ,[SeltYfirAuglystuSoluverdi]
        ,[SeltAAuglystuSoluverdi]
        ,[SeltUndirAuglystuSoluverdi]
        ,f.[LOAD_DATE]
        ,f.[RECORD_SOURCE]
        ,f.[ETL_ID]
    FROM
      [HgrDwh].[dwh].[Fact_Kaupsamningar_Stakar] f
          INNER JOIN dwh.Dim_Timi dtim
              ON f.Dim_Timi_Utgefid = dim_timi_sk
          JOIN dwh.Dim_Fasteignir dfst
  		    ON f.Dim_Fasteignir = dfst.Dim_Fasteignir_sk
   WHERE
      dtim.ar > 2012
  ORDER BY
   Dim_Timi_Utgefid ASC"

  df <- dbGetQuery(connection, query_yfirverd)
  df %>% as_tibble()
}

#' Title
#'
#' @param df
#' @param title
#' @import tidyverse
#' @return
#' @export plot_yfirverd
#'
#' @examples
plot_yfirverd <- function(df, title = NULL){

  df %>%
    ggplot(aes(x = timi, y = val, fill = var)) +
    geom_area(position = position_fill()) +
    scale_y_continuous(labels = scales::percent_format()) +
    scale_fill_manual(values = palette_hms) +
    labs(
      y = NULL,
      x = NULL,
      title = title,
      subtitle = "-3ja mánaða hlaupandi meðaltal",
      caption = "Heimild: Þjóðskrá Íslands, Fasteignaleit, hagdeild HMS"
    ) +
    theme_hms()
}


