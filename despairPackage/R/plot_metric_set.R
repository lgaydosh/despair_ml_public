#' Plot metric set for list of h2o models
#'
#' @param df a training or testing frame. Note this is not an h2o frame.
#' @param model_list list of h2o model objects
#'
#' @return ggplot object (scatterplot) show all models across all applicable metrics
#'
#' @examples
#'
#' library(tidyerse)
#' library(h2o)
#' h2o.init()
#' iris_h2o <- as.h2o(iris)
#' gbm_h2o <- h2o.gbm(y = "Sepal.Length", training_frame = iris_h2o)
#' glm_h2o <- h2o.glm(y = "Sepal.Length", training_frame = iris_h2o)
#' metric_plot <- plot_metric_set(iris, list(gbm_h2o, glm_h2o))
#' metric_plot
#'
#' @export

plot_metric_set <- function(df, model_list){
  # df: Training or testing frame
  # model_list: list of h2o model objects
  # return: ggplot object (scatterplot) comparing all models across all applicable metrics

  # Get metrics
  df_metrics <- get_metric_set(df, model_list)

  # pivot metrics to put in tidy format and plot
  df_metrics %>%
    pivot_longer(cols = -model,
                 names_to = "metric",
                 values_to = "metric_val") %>%
    drop_na() %>%
    ggplot() +
    geom_point(aes(x = metric, y = metric_val, color = model), size = 3) +
    xlab("Metric") +
    ylab("Metric Value") +
    ggtitle("Model Comparison Plot") +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5),
          axis.text = element_text(size = 11))
}
