require 'prometheus/client/formats/text'

class MetricsController < ActionController::Base
  protect_from_forgery with: :exception
  include RequiresHealthToken

  CHECKS = [
    Gitlab::HealthChecks::DbCheck,
    Gitlab::HealthChecks::RedisCheck,
    Gitlab::HealthChecks::FsShardsCheck,
  ].freeze

  def metrics
    return render_404 unless Gitlab::Metrics.prometheus_metrics_enabled?

    metrics_text = Prometheus::Client::Formats::Text.marshal_multiprocess(multiprocess_metrics_path)
    response = health_metrics_text + "\n" + metrics_text

    render text: response, content_type: 'text/plain; version=0.0.4'
  end

  private

  def multiprocess_metrics_path
    Rails.root.join(ENV['prometheus_multiproc_dir'])
  end

  def health_metrics_text
    results = CHECKS.flat_map(&:metrics)

    types = results.map(&:name)
              .uniq
              .map { |metric_name| "# TYPE #{metric_name} gauge" }
    metrics = results.map(&method(:metric_to_prom_line))
    types.concat(metrics).join("\n")
  end

  def metric_to_prom_line(metric)
    labels = metric.labels&.map { |key, value| "#{key}=\"#{value}\"" }&.join(',') || ''
    if labels.empty?
      "#{metric.name} #{metric.value}"
    else
      "#{metric.name}{#{labels}} #{metric.value}"
    end
  end
end
