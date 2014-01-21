require 'sequel'
require "sequel/extensions/pg_array"
DB = Sequel.connect('postgres://ritesh:newpassword@localhost')
DB.create_table :user do
  primary_key :id
  String :first_name
  String :last_name
  String :email
  String :zipcode
  String :company_name
  String :google_profile
  String :skype  
  String :phone
  String :about
  String :linkedin_profile_url
  String :company_url
 column :needs , 'Text[]'
  column :offering , 'Text[]'
  column :upcoming_meetings, 'Integer[]'
  column :past_meetings , 'Integer[]'
  column :top_matches , 'Integer[]'
end

DB.create_table :upcoming_meeting do
  primary_key :id
  DateTime :date_of_meeting
  String :venue
  String :label  
end

DB.create_table :past_meeting do
 primary_key :id
 String :label
 DateTime :date_of_meeting
 Float :rating
 String :comment
 String :venue
end

users = DB[:user];
users.insert(:first_name => "Ritesh",:last_name => "Mehandiratta",:email=>'ritesh@iritesh.com',:company_name=>'Heroku',:google_profile=>'https://plus.google.com/108311822530391568304',:skype =>"sritesh" ,:phone => "9910728457" , :about =>'Hello world ' , :linkedin_profile_url => 'linkedin.com' ,:company_url => 'company url' ,:needs =>Sequel.pg_array(['hello1','hello2','hello3','hello4']) , :offering =>Sequel.pg_array(['offer1','offer2','offer3','offer4']) , :upcoming_meetings => Sequel.pg_array([1,2,3,4]), :past_meetings =>Sequel.pg_array([1,2,3,4]),:top_matches => Sequel.pg_array([1,2,3,4]));
puts users.all