require './grape_user_api'
require "rack/test"

describe RestUser::API do
  include Rack::Test::Methods

  def app
    RestUser::API
  end

  describe RestUser::API do
    describe "GET /api/users 1" do
      it "returns 500 response code because the existing user does not exist" do
        get "/users/1234"
        last_response.status.should == 500
        JSON.parse(last_response.body).to_s.should == '{"error"=>"500  Provided Id doesn\'t exist in database "}'
      end
    end
# when invalid parameter is passed .name is not a valid field
    describe "Get invalid include parameter" do
 it "returns an error invalid include parameter" do
 get "/users/1?include=id,name"
 last_response.status.should == 500
JSON.parse(last_response.body).to_s.should == '{"error"=>"500 following parameters are not valid[\"name\"]"}'

end
  end
#when invalid exclude parameter is passed .name is 
describe "Get invalid exclude parameter" do
it "returns an error invalid exclude parameter" do
get "/users/1?exclude=id,name"
last_response.status.should ==500
JSON.parse(last_response.body).to_s.should == '{"error"=>"500 following parameters are not valid [\"name\"]"}'
end
end
#when valid use is passed because in database there is a user with id 1
#this user automatically created when you run local_setup.rb
describe "Get valid user response" do
it "returns a json object containing all user attributes" do
get "/users/1"
last_response.status.should == 200
DB = Sequel.connect('postgres://ritesh:newpassword@localhost')
user = DB[:user]
upcoming_meeting =DB[:upcoming_meeting]
past_meeting = DB[:past_meeting]
row = user.filter(:id => 1).first


row_json = row.to_json
 
parseObject = JSON.parse(row_json)

upcoming_attribute = parseObject[ "upcoming_meetings" ]
if upcoming_attribute !=nil && upcoming_attribute.length() > 2
 upcoming_attribute.slice(1,upcoming_attribute.length() -2)
 
upcoming_array=upcoming_attribute.split(",").map { |s| s.to_i }
end

past_attribute = parseObject["past_meetings"]
if (past_attribute != nil && past_attribute.length() > 2 )
past_attribute.slice(1,past_attribute.length() -2)
past_array=past_attribute.split(",").map{ |s| s.to_i}

end
match_attribute=parseObject["top_matches"]
if(match_attribute != nil && match_attribute.length > 2)
match_attribute.slice(1,match_attribute.length() -2)
match_array = match_attribute.split(",").map{ |s| s.to_i}
end

user_json={}
user_json = {"first_name" => parseObject["first_name"] ,"last_name" => parseObject["last_name"], "email" => parseObject["email"] , "zipcode" => parseObject["zipcode"] , "comapny_name" => parseObject ["comapnay_name"] , "google_profile" => parseObject["google_profile"] ,"skype" => parseObject["skype"] , "phone" => parseObject ["phone"] , "about" => parseObject ["about"] , "linkedin_profile_url" =>parseObject["linkedin_profile_url"] , "company_url" => parseObject["company_url"] , "needs" => parseObject["needs"] , "offering" => parseObject["offering"] }
kk=JSON.parse(last_response.body)
#matching all user attributes
kk["first_name"].should == user_json["first_name"] 
kk["last_name"].should == user_json["last_name"]
kk["email"].should == user_json["email"]
kk["zipcode"].should == user_json["zipcode"]
kk["google_profile"].should == user_json["google_profile"]
kk["skype"].should == user_json["skype"]
kk["phone"].should ==user_json["phone"]
kk["about"].should == user_json["about"]
kk["linkedin_profile_url"].should == user_json["linkedin_profile_url"]
kk["company_url"].should == user_json["company_url"]
kk["needs"].should == user_json["needs"]
kk["offering"].should == user_json["offering"]

end
end
#when valid include parameters are used

describe "Get valid response when using appropriate include parameter" do

it "returns a json object containing all user attributes" do

get "/users/1?include=id,first_name"

last_response.status.should == 200

DB = Sequel.connect('postgres://ritesh:newpassword@localhost')

user = DB[:user]

upcoming_meeting =DB[:upcoming_meeting]

past_meeting = DB[:past_meeting]

row = user.filter(:id => 1).first

row_json = row.to_json
 
parseObject = JSON.parse(row_json)

upcoming_attribute = parseObject[ "upcoming_meetings" ]
if upcoming_attribute !=nil && upcoming_attribute.length() > 2
 upcoming_attribute.slice(1,upcoming_attribute.length() -2)
 
upcoming_array=upcoming_attribute.split(",").map { |s| s.to_i }
end

past_attribute = parseObject["past_meetings"]
if (past_attribute != nil && past_attribute.length() > 2 )
past_attribute.slice(1,past_attribute.length() -2)
past_array=past_attribute.split(",").map{ |s| s.to_i}

end
match_attribute=parseObject["top_matches"]
if(match_attribute != nil && match_attribute.length > 2)
match_attribute.slice(1,match_attribute.length() -2)
match_array = match_attribute.split(",").map{ |s| s.to_i}
end
user_json={}
include_parameter=["id","first_name"]
for aa in include_parameter
user_json[aa] =parseObject[aa]
end
kk=JSON.parse(last_response.body)
#comparing matching attributes
kk["id"] == user_json["id"]
kk["first_name"] =user_json["first_name"]
end
 end

  end
end
