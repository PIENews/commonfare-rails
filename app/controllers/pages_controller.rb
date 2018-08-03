class PagesController < ApplicationController
  include HighVoltage::StaticPage

  before_action :home
  before_action :dashboard
  # before_filter :authenticate
  # layout :layout_for_page

  private

  def layout_for_page
    case params[:id]
    when 'home'
      'home'
    else
      'application'
    end
  end

  def home
    if params[:id] == 'home'
      # Welfare provisions are already scoped in the current locale language
      @story_types_and_lists = {
        commoners_voice: get_commoner_voices,
        good_practice: Story.published.good_practice
          .includes(:commoner, :tags, :comments, :images, :translations)
          .first(6),
        welfare_provision: Story.published.welfare_provision
          .includes(:commoner, :tags, :comments, :images)
          .first(6)
      }
    end
  end

  def dashboard
    if params[:id] == 'dashboard'
      data_file_path = File.join('/host_tmp', 'dashboard_data.yml')
      json_file_path = File.join('/host_tmp', 'dashboard_graph_data.json')
      if File.exists? data_file_path
        data = YAML.load_file data_file_path
        @week_of          = data['week_of']
        @start_date       = data['start_date']
        @end_date         = data['end_date']
        @site_searches    = data['site_searches']
        @visits_overview = {
          s_('Dashboard|Visits')               => data['nb_visits'],
          s_('Dashboard|Unique visitors')      => data['nb_uniq_visitors'],
          s_('Dashboard|Pageviews')            => data['nb_pageviews'],
          s_('Dashboard|Total registered commoners') => data['nb_registered_commoners']
        }
        @json_data = JSON.parse(File.read(json_file_path)).to_json.html_safe if File.exists? json_file_path
      else
        @no_file = true
      end
    end
  end

  private
  def get_featured_stories_ids
    if ENV['FEATURED_STORIES'].present?
      ids = ENV['FEATURED_STORIES'].split(',').map(&:to_i)
      ids.select {|id| Story.published.commoners_voice.find_by(id: id).present?}
    else
      []
    end
  end

  # Returns 6 commoners_voices with the featured ones on top
  def get_commoner_voices
    filtered_stories_ids = (
      get_featured_stories_ids +
      Story.published.commoners_voice
        .first(12)
        .pluck(:id)
    ).uniq.first(6)
    filtered_stories_ids.map { |id| Story.includes(:commoner, :tags, :comments, :images, :translations).find(id) }
  end
end
