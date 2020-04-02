#' Get h2o model performance metrics
#'
#' @param df a training or testing data frame or tibble. Note, this is not an h2o frame.
#' @param h2o_model the h2o model object
#'
#' @return a data frame of model metrics for input data frame
#'
#' @examples
#'
#' library(tidyerse)
#' library(h2o)
#' h2o.init()
#' iris_h2o <- as.h2o(iris)
#' gbm_h2o <- h2o.gbm(y = "Sepal.Length", training_frame = iris_h2o)
#' metrics <- get_metrics(iris, gbm_h2o)
#'
#' @export


# This function returns the metric from an h20 model fit
get_metrics <- function(df, h2o_model){
  # df: training or testing frame
  # h2o_model: h2o model fit to use
  # returns: tibble of metrics

  h2o_df <- df %>% as.h2o()

  # calculate result
  result <- h2o.performance(model = h2o_model, newdata = h2o_df)

  # Quick convenience function to check null values
  # Note, intentionally not using if_else() to avoid strictness of if_else
  check_null <- function(...) ifelse(is.null(...), NA, ...)

  # get metrics of interest
  metrics <- tibble(auc = check_null(result@metrics$AUC),
                    mse = check_null(result@metrics$MSE),
                    rmse = check_null(result@metrics$RMSE),
                    r2 = check_null(result@metrics$r2),
                    logloss = check_null(result@metrics$logloss),
                    mean_resid_deviance = check_null(result@metrics$mean_residual_deviance),
                    mae = check_null(result@metrics$mae))

  # return metric tibble
  return(metrics)

}
