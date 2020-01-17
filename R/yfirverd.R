

#' Title
#'
#' @param connection
#' @param ...
#' @param print_plot
#' @param eftir
#' @param filters
#' @import tidyverse
#' @import lubridate
#' @import glue
#'
#' @return
#' @export
#'
#' @examples
yfirverd <- function(connection, ..., print_plot = TRUE, eftir = NULL, filters = NULL){
  df <- yfirverd_get_data(connection = connection)
  if(NROW(df) == 0) stop("0 rows returned from DB")

  my_groups <- enquos(...)

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
    p <- plot_yfirverd(df2, title = title) +
      facet_wrap(facets = vars(!!!my_groups))

    print(p)
  }

  return(df2)

}


