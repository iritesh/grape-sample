require 'grape'
require 'sequel'
require 'json'
module RestUser
  class API < Grape::API

    version 'v1', :using => :header, :vendor => 'twitter'
    format :json

    resource :users do

     

      desc "Return a status."
      params do
        requires :id, :type => Integer, :desc => "Status id."
        optional :include , :type => String , :desc =>"parameter to include in "
        optional :exclude , :type => String , :desc =>"parameter to exclude"
      end

#method for responsing at the url /users/:id
      get ':id' do
# create a dataset from the items table
#for connecting to Postgre database ritesh is super user and newpassword is password of super user
#localhost where i am hosting it
DB = Sequel.connect('postgres://ritesh:newpassword@localhost')

user = DB[:user]

upcoming_meeting =DB[:upcoming_meeting]

past_meeting = DB[:past_meeting]
# populate the table

#row will be retrieved for the id specified in parameters   
row = user.filter(:id => params[:id]).first
#if no user exist then it will response code and error
if(row ==nil)
error!('500  Provided Id doesn\'t exist in database ' , 500)
end

row_json = row.to_json
 
parseObject = JSON.parse(row_json)

upcoming_attribute = parseObject[ "upcoming_meetings" ]
# retrieving rows related to upcoming_meetings ,past_meetings ,top_matches
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
#creating a hash to be retuned as json as the successful response
user_json={}
if( params[:include]==nil &&params[:exclude] ==nil )
user_json = {:first_name => parseObject["first_name"] ,:last_name => parseObject["last_name"], :email => parseObject["email"] , :zipcode => parseObject["zipcode"] , :company_name => parseObject ["company_name"] , :google_profile => parseObject["google_profile"] ,:skype => parseObject["skype"] , :phone => parseObject ["phone"] , :about => parseObject ["about"] , :linkedin_profile_url =>parseObject["linkedin_profile_url"] , :company_url => parseObject["company_url"] , :needs => parseObject["needs"] , :offering => parseObject["offering"] }


if(upcoming_array!= nil && upcoming_array.class == Array && upcoming_array.size() != 0)
user_json["upcoming_meetings"] = upcoming_meeting.filter(:id => upcoming_array).all
end

if (past_array != nil && upcoming_array.class == Array && upcoming_array.size != 0)

user_json["past_meetings"] =past_meeting.filter(:id => past_array).all

end

if(match_array != nil && match_array.class == Array && match_array.size != 0)

user_json["top_matches"] = user.select(:id,:first_name).filter(:id => match_array).all

end
end # close for when both params are zero


#if include parameter is specified by user
if(params[:include]!=nil)

include_parameter=params[:include].split(",").map{|s| s}

if((include_parameter-parseObject.keys).size !=0)

error!("500 following parameters are not valid" + (include_parameter - parseObject.keys).to_s, 500)

end

for aa in include_parameter
user_json[aa] =parseObject[aa]
if(aa == "upcoming_meetings")
if(upcoming_array!= nil && upcoming_array.class == Array && upcoming_array.size() != 0)
user_json[aa]=upcoming_meeting.filter(:id => upcoming_array).all
end
end
     
if(aa == "past_meetings")
if(past_array != nil && past_array.class == Array && past_array.size() != 0)
user_json[aa]=  past_meeting.filter(:id=> past_array).all
end 
end

if(aa == "top_matches")
if(match_array != nil && match_array.class == Array && match_array.size() != 0)
user_json[aa]= user.select(:id,:first_name).filter(:id => match_array).all
end
end

end #for end
end #outer if end

#one if block is ended
#if only exclude parameter is specified
if(params[:include] == nil &&params[:exclude] !=nil)
exclude_parameter=params[:exclude].split(",").map{|s| s}
if( (exclude_parameter - parseObject.keys).size != 0)
error!('500 following parameters are not valid ' + (exclude_parameter - parseObject.keys).to_s , 500)
end

for aa in (parseObject.keys - exclude_parameter)
user_json[aa] = parseObject[aa]
if(aa == "upcoming_meetings")
if(upcoming_array != nil && upcoming_array.class == Array && upcoming_array.size() != 0)
user_json[aa]= upcoming_meeting.filter(:id => upcoming_array).all
end
end
     
if(aa == "past_meetings" )
if(upcoming_array!= nil && upcoming_array.class == Array && upcoming_array.size() != 0)
user_json[aa]=  past_meeting.filter(:id=> past_array).all 
end
end

if(aa == "top_matches")
if(match_array != nil && match_array.class == Array && match_array.size() != 0)
user_json[aa]= user.select(:id,:first_name).filter(:id => match_array).all
end
end

end #for end

end


user_json

end
end
end
end
