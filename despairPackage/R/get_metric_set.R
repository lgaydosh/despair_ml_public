#' Get metrics for multiple h2o models on single training or testing frame
#'
#' @param df a training or testing frame. Note, this is not an h2o frame.
#' @param model_list a list of h2o model objects
#'
#' @return a dataframe of metrics for each model in model_list
#'
#' @examples
#'
#' library(tidyerse)
#' library(h2o)
#' h2o.init()
#' iris_h2o <- as.h2o(iris)
#' gbm_h2o <- h2o.gbm(y = "Sepal.Length", training_frame = iris_h2o)
#' glm_h2o <- h2o.glm(y = "Sepal.Length", training_frame = iris_h2o)
#' metrics <- get_h2o_metric_set(iris, list(gmb_h2o, glm_h2o))
#'
#' @export

get_metric_set <- function(df, model_list){
  # df: Training or testing frame
  # model_list: list of h2o model objects
  # return: tibble with all applicable metrics for each model tested on df

  # get metric set
  metric_set <- model_list %>%
    map_df(get_metrics, df = df) %>%
    mutate(model = factor(1:length(model_list))) %>%
    select(model, everything())

  # return metric set
  return(metric_set)
}
