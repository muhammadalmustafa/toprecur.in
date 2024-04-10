require 'sinatra'
require 'json'
enable :method_override

# File where posts are stored
FILE_PATH = 'posts.json'

# Read posts from the JSON file
def read_posts
  return [] unless File.exist?(FILE_PATH)
  file = File.read(FILE_PATH)
  JSON.parse(file)
rescue JSON::ParserError
  []
end

# Write posts to the JSON file
def write_posts(posts)
  File.write(FILE_PATH, posts.to_json)
end

get '/' do
  @posts = read_posts
  erb :index
end

get '/new' do
  erb :new
end

post '/posts' do
  posts = read_posts
  new_post = { "title" => params[:title], "body" => params[:body] }
  posts << new_post
  write_posts(posts)
  redirect '/'
end

delete '/delete/:id' do
  posts = read_posts
  index = params[:id].to_i
  posts.delete_at(index) if index < posts.size
  write_posts(posts)
  redirect '/'
end


__END__

@@ index
<!DOCTYPE html>
<html>
<head>
  <title>Simple Blog</title>
</head>
<body>
  <h1>Posts</h1>
  <a href="/new">Create Post</a>
  <% @posts.each_with_index do |post, index| %>
    <div>
      <h2><%= post["title"] %></h2>
      <pre><%= post["body"] %></pre>

      <form action="/delete/<%= index %>" method="post">
        <input type="hidden" name="_method" value="delete">
        <input type="submit" value="Delete">
      </form>



    </div>
  <% end %>
</body>
</html>

@@ new
<!DOCTYPE html>
<html>
<head>
  <title>New Post</title>
</head>
<body>
  <h1>New Post</h1>
  <form action="/posts" method="post">
    <div>
      <label>Title:</label>
      <input type="text" name="title">
    </div>
    <div>
      <label>Body:</label>
      <textarea rows="10" cols="30" name="body"></textarea>
    </div>
    <div>
      <input type="submit" value="Create Post">
    </div>
  </form>
  <a href="/">Back to Posts</a>
</body>
</html>

