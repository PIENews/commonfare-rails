json.extract! story, :id, :title, :content_json, :place, :commoner_id, :created_at, :updated_at
json.url story_url(story, format: :json)
json.tags story.tags, :id, :name
